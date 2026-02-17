import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart'; // Keep for playback
import 'package:resummy_app/core/services/gemini_speech_service.dart';
import 'package:resummy_app/core/services/gemini_interview_service.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_question.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_report.dart';
import 'package:resummy_app/core/constants/app_constants.dart';

import 'package:resummy_app/features/interview/data/repositories/interview_history_repository.dart';

enum InterviewStatus { initial, loading, inProgress, analyzing, completed, error }
enum InterviewFocus { behavioral, technical, mixed }

class InterviewProvider extends ChangeNotifier {
  final GeminiSpeechService _geminiService;
  final GeminiInterviewService _interviewService;
  final InterviewHistoryRepository _repository;
  
  // State
  InterviewStatus _status = InterviewStatus.initial;
  String? _errorMessage;
  List<InterviewQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  
  // History
  List<InterviewReport> _history = [];
  List<InterviewReport> get history => _history;

  // Interview Data
  String? _cvText;
  String? _jdText;
  String? _role;
  String _locale = 'id-ID'; // Default locale
  InterviewFocus _selectedFocus = InterviewFocus.mixed;
  InterviewFocus get selectedFocus => _selectedFocus;
  
  // Recording
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;
  bool _isRecording = false;
  bool _isTranscribing = false;
  String? _currentRecordingPath;
  DateTime? _recordingStartTime;
  int _currentAudioDuration = 0;
  
  // Total Session Duration
  int _totalSessionDurationSeconds = 0;
  int get totalSessionDurationSeconds => _totalSessionDurationSeconds;
  Timer? _sessionTimer;

  // Playback
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingQuestion = false;
  File? _currentQuestionAudio;

  // Transcript
  String _currentTranscript = '';

  // UI State in Provider for Audio Coordination
  bool _isQuestionTextVisible = true;
  bool get isQuestionTextVisible => _isQuestionTextVisible;

  void setQuestionTextVisibility(bool isVisible) {
    _isQuestionTextVisible = isVisible;
    notifyListeners();
  }

  InterviewProvider({
    required GeminiSpeechService geminiService,
    required GeminiInterviewService interviewService,
    required InterviewHistoryRepository repository,
  }) : _geminiService = geminiService,
       _interviewService = interviewService,
       _repository = repository {
    // Suppress verbose audio logs
    AudioLogger.logLevel = AudioLogLevel.none;
    loadHistory();
  }

  Future<void> loadHistory() async {
    _history = await _repository.getInterviews();
    notifyListeners();
  }

  // Getters
  InterviewStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<InterviewQuestion> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  InterviewQuestion? get currentQuestion => 
      _questions.isNotEmpty && _currentQuestionIndex < _questions.length 
          ? _questions[_currentQuestionIndex] 
          : null;
  bool get isRecording => _isRecording;
  bool get isTranscribing => _isTranscribing;
  String get currentTranscript => _currentTranscript;
  bool get isPlayingQuestion => _isPlayingQuestion;
  String get locale => _locale;
  
  // Missing getters
  String? get role => _role;
  String? get cvText => _cvText;
  String? get jdText => _jdText;
  String? get cvFileName => _cvFileName;
  String? get companyName => _companyName;
  
  InterviewReport? _report;
  InterviewReport? get report => _report;

  void setReport(InterviewReport report) {
    _report = report;
    notifyListeners();
  }

  // Setup Setters
  void updateCvText(String text) {
    _cvText = text;
    notifyListeners();
  }

  void updateJdText(String text) {
    _jdText = text;
    notifyListeners();
  }

  void updateRole(String text) {
    _role = text;
    notifyListeners();
  }

  String? _cvFileName;
  String? _companyName;

  void updateCvFileName(String name) {
    _cvFileName = name;
    notifyListeners();
  }

  void updateCompanyName(String name) {
    _companyName = name;
    notifyListeners();
  }

  void updateFocus(InterviewFocus focus) {
    _selectedFocus = focus;
    notifyListeners();
  }


  Future<void> initRecorder() async {
    if (!_isRecorderInitialized) {
      if (kDebugMode) print("Requesting microphone permission...");
      final status = await Permission.microphone.request();
      if (kDebugMode) print("Microphone permission status: $status");
      
      if (status != PermissionStatus.granted) {
        throw Exception('Microphone permission not granted');
      }
      if (kDebugMode) print("Opening recorder...");
      await _audioRecorder.openRecorder();
      _isRecorderInitialized = true;
      if (kDebugMode) print("Recorder initialized");
    }
  }

  void updateTranscript(String text) {
    _currentTranscript = text;
    notifyListeners();
  }

  Future<void> startInterview({
    required String role,
    InterviewFocus focus = InterviewFocus.mixed,
    String locale = 'id-ID',
  }) async {
    if (kDebugMode) {
      print("Starting interview process...");
      print("CV Text Length: ${cvText?.length}");
      print("JD Text Length: ${jdText?.length}");
      print("Role: $role");
    }
    _cvText = cvText;
    _jdText = jdText;
    _role = role;
    _selectedFocus = focus;
    _locale = locale;
    _status = InterviewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      if (kDebugMode) print("Initializing recorder in startInterview...");
      await initRecorder();
      
      final questions = await _geminiService.generateQuestions(
        _cvText ?? '', 
        _jdText ?? '', 
        _role ?? '',
        focus: _selectedFocus,
        language: _locale,
      );
      _questions = questions;
      if (kDebugMode) print("Questions generated: ${_questions.length}");

      if (_questions.isEmpty) {
         throw Exception("Failed to generate questions (empty list)");
      }

      _currentQuestionIndex = 0;
      _status = InterviewStatus.inProgress;
      
      // Auto-generate audio for first question
      if (kDebugMode) print("Auto-starting session timer...");
      _startSessionTimer();
      
      if (kDebugMode) print("Generating audio for first question...");
      _generateAndPlayQuestionAudio();
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error in startInterview: $e");
      _status = InterviewStatus.error;
      
      String errorStr = e.toString();
      if (errorStr.contains('503')) {
        _errorMessage = "Layanan AI sedang sibuk karena permintaan sedang tinggi. Silakan coba lagi sebentar lagi.";
      } else if (errorStr.contains('401') || errorStr.contains('403')) {
        _errorMessage = "Masalah koneksi API (API Key bermasalah). Silakan periksa pengaturan.";
      } else if (errorStr.contains('Timeout') || errorStr.contains('connection')) {
        _errorMessage = "Koneksi internet bermasalah. Silakan periksa jaringan Anda.";
      } else {
        _errorMessage = "Terjadi kesalahan: $e";
      }
      
      notifyListeners();
    }
  }

  // DEBUG: Start with dummy data to skip interview
  Future<void> startInterviewWithDummyData() async {
    _status = InterviewStatus.loading;
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 1)); // Simulate loading
    
    // Dummy Questions
    _questions = [
      const InterviewQuestion(id: '1', text: 'Tell me about a time you faced a challenge.', difficulty: 'Medium', userAnswerTranscript: "I once faced a tight deadline where the backend API wasn't ready. I mocked the data using JSON files to continue frontend development, which allowed us to meet the deadline.", audioDurationSeconds: 15),
      const InterviewQuestion(id: '2', text: 'Describe a project where you demonstrated leadership.', difficulty: 'Medium', userAnswerTranscript: "In my final year project, I led a team of 4. I organized daily standups and used Trello to track progress. We finished the project 2 weeks early.", audioDurationSeconds: 20),
      const InterviewQuestion(id: '3', text: 'How do you prioritize tasks under pressure?', difficulty: 'Medium', userAnswerTranscript: "I use the Eisenhower Matrix to categorize tasks by urgency and importance. This helps me focus on what really matters.", audioDurationSeconds: 12),
      const InterviewQuestion(id: '4', text: 'What are your strengths and weaknesses?', difficulty: 'Medium', userAnswerTranscript: "My strengths are persistence and attention to detail. My weakness is sometimes taking on too much at once, but I am learning to delegate better.", audioDurationSeconds: 18),
      const InterviewQuestion(id: '5', text: 'Where do you see yourself in five years?', difficulty: 'Medium', userAnswerTranscript: "I see myself as a senior developer leading impact projects and mentoring junior devs to grow the team's technical excellence.", audioDurationSeconds: 10),
    ];
    
    _currentQuestionIndex = _questions.length - 1; // Set to last
    _status = InterviewStatus.analyzing;
    notifyListeners();
    
    // Auto-generate report
    generateReport();
  }

  Future<void> _generateAndPlayQuestionAudio() async {
    if (currentQuestion == null) return;
    
    // Use dedicated TTS key for this question
    final apiKey = _geminiService.getTtsApiKey(_currentQuestionIndex);

    try {
      final audioFile = await _geminiService.textToSpeech(
        text: currentQuestion!.text,
        apiKey: apiKey,
      );
      
      if (audioFile != null) {
        _currentQuestionAudio = audioFile;
        notifyListeners(); // Notify that audio is ready
        
        // Only auto-play if "AI Interviewer" text/mode is visible/active
        if (_isQuestionTextVisible) {
             await playQuestionAudio();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error generating TTS: $e');
      }
    }
  }

  StreamSubscription? _playerCompleteSubscription;


  Future<void> startRecording() async {
    if (_isTranscribing) {
      if (kDebugMode) print("Cannot start recording while transcribing is in progress");
      return;
    }
    try {
        // Stop AI audio if it's playing
        if (_isPlayingQuestion) {
          if (kDebugMode) print("Stopping AI audio before recording...");
          await stopAudio();
        }
        
        if (!_isRecorderInitialized) await initRecorder();

        final tempDir = await getTemporaryDirectory();
        final path = '${tempDir.path}/answer_${_currentQuestionIndex}_${DateTime.now().millisecondsSinceEpoch}.wav';
        _currentRecordingPath = path;

        await _audioRecorder.startRecorder(
            toFile: path,
            codec: Codec.pcm16WAV,
        );

        _isRecording = true;
        _recordingStartTime = DateTime.now();
        _currentTranscript = ''; // Reset transcript
        notifyListeners();
    } catch (e) {
        if (kDebugMode) print("Start recording error: $e");
        _errorMessage = "Could not start recorder: $e";
        notifyListeners();
    }
  }

  Future<void> stopRecording() async {
    try {
        final path = await _audioRecorder.stopRecorder();
        _isRecording = false;
        
        if (_recordingStartTime != null) {
            _currentAudioDuration = DateTime.now().difference(_recordingStartTime!).inSeconds;
        }

        if (path != null) {
            _currentRecordingPath = path;
            await _transcribeAudio(File(path), _currentQuestionIndex);
        } else if (_currentRecordingPath != null) {
             // Sometimes path is null on stop but file exists at _currentRecordingPath
             await _transcribeAudio(File(_currentRecordingPath!), _currentQuestionIndex);
        }
    } catch (e) {
         if (kDebugMode) print("Stop recording error: $e");
         _errorMessage = "Could not stop recorder: $e";
         notifyListeners();
    }
  }

  Future<void> cancelRecording() async {
    try {
        await _audioRecorder.stopRecorder();
        _isRecording = false;
        _currentRecordingPath = null;
        _currentTranscript = '';
        _recordingStartTime = null;
        _currentAudioDuration = 0;
        notifyListeners();
    } catch (e) {
         if (kDebugMode) print("Cancel recording error: $e");
         _errorMessage = "Could not cancel recorder: $e";
         notifyListeners();
    }
  }

  Future<void> _transcribeAudio(File audioFile, int questionIndex) async {
    // Use dedicated STT key for this question
    final apiKey = _geminiService.getSttApiKey(questionIndex);

    _isTranscribing = true;
    notifyListeners();

    try {
      final text = await _geminiService.speechToText(
        audioFile: audioFile,
        apiKey: apiKey,
      );
      
      // SAFETY CHECK: Only update if we are still on the same question
      if (_currentQuestionIndex == questionIndex) {
        _currentTranscript = text;
      } else {
        if (kDebugMode) print("Transcription arrived but question index changed (was $questionIndex, now $_currentQuestionIndex). Discarding result.");
        // We might want to save it to the actual question object even if index changed
        if (questionIndex < _questions.length) {
          _questions[questionIndex] = _questions[questionIndex].copyWith(
            userAnswerTranscript: text,
          );
        }
      }
    } catch (e) {
       if (_currentQuestionIndex == questionIndex) {
         _currentTranscript = "Error describing audio: $e";
       }
       if (kDebugMode) {
         print("STT Error: $e");
       }
    } finally {
      _isTranscribing = false;
      notifyListeners();
    }
  }

  Future<void> stopAudio() async {
    if (_isDisposed) return;
    await _audioPlayer.stop();
    await _playerCompleteSubscription?.cancel();
    _isPlayingQuestion = false;
    notifyListeners();
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _totalSessionDurationSeconds++;
      notifyListeners();
    });
  }

  void _stopSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  void nextQuestion() {
    if (_questions.isEmpty || _isTranscribing) return;

    // Save current answer
    _questions[_currentQuestionIndex] = _questions[_currentQuestionIndex].copyWith(
      userAnswerTranscript: _currentTranscript,
      audioDurationSeconds: _currentAudioDuration > 0 ? _currentAudioDuration : 60,
    );
    
    // Reset for next question
    _currentTranscript = '';
    _currentAudioDuration = 0;
    _recordingStartTime = null;
    _currentQuestionAudio = null;
    _isPlayingQuestion = false;

    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _generateAndPlayQuestionAudio();
      notifyListeners();
    } else {
      _status = InterviewStatus.analyzing;
      _stopSessionTimer();
      notifyListeners();
      // Generate report automatically
      generateReport();
    }
  }
  
  /// Generate interview feedback report
  Future<void> generateReport() async {
    if (_status != InterviewStatus.analyzing) {
      _status = InterviewStatus.analyzing;
      notifyListeners();
    }
    
    try {
      debugPrint('--- [InterviewProvider] generateReport: STARTING analysis ---');
      final startTime = DateTime.now();
      
      final report = await _interviewService.analyzeSession(
        _questions,
        language: _locale.startsWith('id') ? 'id' : 'en',
        shouldStop: () => _isDisposed,
      );
      
      if (_isDisposed) {
         debugPrint('--- [InterviewProvider] generateReport: Disposed during analysis. Discarding result. ---');
         return;
      }

      _report = report;
      _status = InterviewStatus.completed;
      
      // Save persistence
      await _repository.saveInterview(report);
      await loadHistory();
      
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inSeconds;
      debugPrint('--- [InterviewProvider] generateReport: SUCCESS in ${duration}s ---');
    } catch (e) {
      debugPrint('--- [InterviewProvider] generateReport: FAILED with error: $e ---');
      _status = InterviewStatus.error;
      _errorMessage = 'Failed to generate feedback: $e';
    } finally {
      notifyListeners();
    }
  }
  
  /// Cancel current interview analysis
  void cancelAnalysis() {
    debugPrint('--- [InterviewProvider] cancelAnalysis: Analysis cancelled by user ---');
    _isDisposed = true; // Signals the service to stop
    // We should also set status to initial or cancelled to update UI immediately if still mounted
    if (_status == InterviewStatus.analyzing) {
      _status = InterviewStatus.initial;
      notifyListeners();
    }
  }
  
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    _playerCompleteSubscription?.cancel();
    _audioPlayer.dispose();
    _stopSessionTimer();
    if (_isRecorderInitialized) {
        _audioRecorder.closeRecorder();
    }
    super.dispose();
  }

  Future<void> playQuestionAudio() async {
    if (_isDisposed) return;
    
    // Toggle logic: If playing, stop.
    if (_isPlayingQuestion) {
      await stopAudio();
      return;
    }

    // Guard: Don't play if recording
    if (_isRecording) {
      if (kDebugMode) print("Blocking AI audio playback because recording is in progress");
      return;
    }

    if (_currentQuestionAudio != null) {
      try {
        if (kDebugMode) print('Starting audio playback: ${_currentQuestionAudio!.path}');
        
        // Stop previous playback and cancel subscription
        if (!_isDisposed) {
           await _audioPlayer.stop();
        }
        await _playerCompleteSubscription?.cancel();
        
        if (_isDisposed) return;
        _isPlayingQuestion = true;
        notifyListeners();
        
        // Add 1s delay before playing as requested
        if (_isDisposed || _isRecording) return;
        
        if (kDebugMode) print('Playing audio...');
        // Re-check disposed before playing
        if (!_isDisposed) {
             await _audioPlayer.play(DeviceFileSource(_currentQuestionAudio!.path));
             
             _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((event) {
              if (kDebugMode) print('Audio playback complete');
              if (!_isDisposed) {
                  _isPlayingQuestion = false;
                  notifyListeners();
              }
            });
        }
      } catch (e) {
        if (kDebugMode) print('Error playing audio: $e');
        if (!_isDisposed) {
            _isPlayingQuestion = false;
            notifyListeners();
        }
        // Don't rethrow if disposed, just ignore
        if (!_isDisposed) rethrow; 
      }
    } else {
      if (kDebugMode) print('Cannot play audio: _currentQuestionAudio is null');
    }
  }

  void resetInterview() {
    if (_isDisposed) return;
    _status = InterviewStatus.initial;
    _questions = [];
    _currentQuestionIndex = 0;
    _errorMessage = null;
    _isPlayingQuestion = false;
    _currentQuestionAudio = null;
    _totalSessionDurationSeconds = 0;
    _stopSessionTimer();
    
    _playerCompleteSubscription?.cancel();
    _playerCompleteSubscription = null;
    
    if (_isRecorderInitialized) {
        _audioRecorder.closeRecorder();
    }
    _isRecorderInitialized = false;
    // Don't dispose _audioPlayer here if we want to reuse the provider?? 
    // Usually reset implies we might start again. 
    // But if we dispose _audioPlayer, we can't reuse it.
    // The previous code disposed it! 
    // If the provider lives on, this is bug. 
    // Let's assume resetInterview is called on Exit, and we want to keep the provider alive?
    // "context.read<InterviewProvider>().resetInterview(); context.router.push..."
    // If the provider is scoped to the session, it will be disposed.
    // However, calling dispose() on player and then reusing usage is bad.
    // I will NOT dispose _audioPlayer in resetInterview, just stop it.
    _audioPlayer.stop(); 
    
    notifyListeners();
  }
}
