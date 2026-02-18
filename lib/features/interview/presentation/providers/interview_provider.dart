import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_entity.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_question.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_report.dart';
import 'package:resummy_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:resummy_app/features/interview/domain/repositories/interview_repository.dart';
import 'package:uuid/uuid.dart';

enum InterviewStatus {
  initial,
  loading,
  inProgress,
  analyzing,
  completed,
  error
}

enum InterviewFocus { behavioral, technical, mixed }

class InterviewProvider extends ChangeNotifier {
  final InterviewRepository _repository;
  final AuthProvider _authProvider;

  InterviewStatus _status = InterviewStatus.initial;
  String? _errorMessage;
  List<InterviewQuestion> _questions = [];
  int _currentQuestionIndex = 0;

  List<InterviewEntity> _history = [];
  List<InterviewEntity> get history => _history;
  String? get _userId => _authProvider.currentUser?.id;

  String? _cvText;
  String? _jdText;
  String? _role;
  String _locale = 'id-ID';
  InterviewFocus _selectedFocus = InterviewFocus.mixed;
  InterviewFocus get selectedFocus => _selectedFocus;

  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;
  bool _isRecording = false;
  bool _isTranscribing = false;
  String? _currentRecordingPath;
  DateTime? _recordingStartTime;
  int _currentAudioDuration = 0;

  int _totalSessionDurationSeconds = 0;
  int get totalSessionDurationSeconds => _totalSessionDurationSeconds;
  Timer? _sessionTimer;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingQuestion = false;
  File? _currentQuestionAudio;
  bool _isDisposed = false;

  String _currentTranscript = '';

  bool _isQuestionTextVisible = true;
  bool get isQuestionTextVisible => _isQuestionTextVisible;

  void setQuestionTextVisibility(bool isVisible) {
    _isQuestionTextVisible = isVisible;
    notifyListeners();
  }

  InterviewProvider({
    required InterviewRepository repository,
    required AuthProvider authProvider,
  })  : _repository = repository,
        _authProvider = authProvider {
    AudioLogger.logLevel = AudioLogLevel.none;

    _authProvider.addListener(_onAuthChanged);
    _onAuthChanged();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    _isDisposed = true;
    _playerCompleteSubscription?.cancel();
    _audioPlayer.dispose();
    _stopSessionTimer();
    if (_isRecorderInitialized) {
      _audioRecorder.closeRecorder();
    }
    super.dispose();
  }

  void _onAuthChanged() {
    if (_userId != null) {
      loadHistory();
    } else {
      _history = [];
      notifyListeners();
    }
  }

  Future<void> loadHistory() async {
    if (_userId == null) return;
    try {
      _history = await _repository.getInterviewHistory(_userId!);
      notifyListeners();
    } catch (e) {
      // ignore: empty_catches
    }
  }

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
      final status = await Permission.microphone.request();

      if (status != PermissionStatus.granted) {
        throw Exception('Microphone permission not granted');
      }
      await _audioRecorder.openRecorder();
      _isRecorderInitialized = true;
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
    _cvText = cvText;
    _jdText = jdText;
    _role = role;
    _selectedFocus = focus;
    _locale = locale;
    _status = InterviewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await initRecorder();

      final questions = await _repository.generateQuestions(
        cvText: _cvText ?? '',
        jdText: _jdText ?? '',
        role: _role ?? '',
        language: _locale.startsWith('id') ? 'id' : 'en',
      );

      _questions = questions;

      if (_questions.isEmpty) {
        throw Exception("Failed to generate questions (empty list)");
      }

      _currentQuestionIndex = 0;
      _status = InterviewStatus.inProgress;

      _startSessionTimer();
      _generateAndPlayQuestionAudio();

      notifyListeners();
    } catch (e) {
      _status = InterviewStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> startInterviewWithDummyData() async {
    _status = InterviewStatus.loading;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Set defaults so generateReport() has valid context
    _role ??= 'Software Engineer';
    _cvText ??= 'Experienced Flutter developer with 2 years of experience building mobile apps. '
        'Proficient in Dart, Flutter, REST APIs, and state management. '
        'Worked on e-commerce and fintech projects.';

    _questions = [
      const InterviewQuestion(
          id: '1',
          text: 'Tell me about a time you faced a challenge at work.',
          difficulty: 'Medium',
          userAnswerTranscript:
              "I once faced a tight deadline where the backend API wasn't ready. I mocked the data using JSON files to continue frontend development, which allowed us to meet the deadline.",
          audioDurationSeconds: 15),
      const InterviewQuestion(
          id: '2',
          text: 'Describe a project where you demonstrated leadership.',
          difficulty: 'Medium',
          userAnswerTranscript:
              "In my final year project, I led a team of 4. I organized daily standups and used Trello to track progress. We finished the project 2 weeks early.",
          audioDurationSeconds: 20),
      const InterviewQuestion(
          id: '3',
          text: 'How do you handle conflict with a team member?',
          difficulty: 'Hard',
          userAnswerTranscript:
              "I once had a disagreement with a colleague about the architecture of a feature. I proposed we each write a brief doc on our approach and present it to the team. We ended up combining both ideas and the result was better than either original proposal.",
          audioDurationSeconds: 25),
      const InterviewQuestion(
          id: '4',
          text: 'Tell me about a time you had to learn something quickly.',
          difficulty: 'Easy',
          userAnswerTranscript:
              "When I joined my internship, I had to learn Flutter in two weeks. I dedicated 3 hours each evening to tutorials and built a small app to practice. By the end of the second week, I was contributing to the main codebase.",
          audioDurationSeconds: 18),
      const InterviewQuestion(
          id: '5',
          text: 'Where do you see yourself in 5 years?',
          difficulty: 'Easy',
          userAnswerTranscript:
              "I see myself as a senior mobile developer, possibly leading a small team. I want to deepen my expertise in Flutter and also explore cross-platform performance optimization. I am also interested in contributing to open source projects.",
          audioDurationSeconds: 22),
    ];

    _currentQuestionIndex = _questions.length - 1;
    _status = InterviewStatus.analyzing;
    notifyListeners();

    generateReport();
  }


  Future<void> _generateAndPlayQuestionAudio() async {
    if (currentQuestion == null) return;

    try {
      final audioFile = await _repository.textToSpeech(
        text: currentQuestion!.text,
      );

      if (audioFile != null) {
        _currentQuestionAudio = audioFile;
        notifyListeners();

        if (_isQuestionTextVisible) {
          await playQuestionAudio();
        }
      }
    } catch (e) {
      // ignore: empty_catches
    }
  }

  StreamSubscription? _playerCompleteSubscription;

  Future<void> startRecording() async {
    if (_isTranscribing) return;
    try {
      if (_isPlayingQuestion) {
        await stopAudio();
      }

      if (!_isRecorderInitialized) await initRecorder();

      final tempDir = await getTemporaryDirectory();
      final path =
          '${tempDir.path}/answer_${_currentQuestionIndex}_${DateTime.now().millisecondsSinceEpoch}.wav';
      _currentRecordingPath = path;

      await _audioRecorder.startRecorder(
        toFile: path,
        codec: Codec.pcm16WAV,
      );

      _isRecording = true;
      _recordingStartTime = DateTime.now();
      _currentTranscript = '';
      notifyListeners();
    } catch (e) {
      _errorMessage = "Could not start recorder: $e";
      notifyListeners();
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await _audioRecorder.stopRecorder();
      _isRecording = false;

      if (_recordingStartTime != null) {
        _currentAudioDuration =
            DateTime.now().difference(_recordingStartTime!).inSeconds;
      }

      if (path != null) {
        _currentRecordingPath = path;
        await _transcribeAudio(File(path), _currentQuestionIndex);
      } else if (_currentRecordingPath != null) {
        await _transcribeAudio(
            File(_currentRecordingPath!), _currentQuestionIndex);
      }
    } catch (e) {
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
      // ignore: empty_catches
    }
  }

  Future<void> _transcribeAudio(File audioFile, int questionIndex) async {
    _isTranscribing = true;
    notifyListeners();

    try {
      final text = await _repository.speechToText(
        audioFile: audioFile,
      );

      if (_currentQuestionIndex == questionIndex) {
        _currentTranscript = text;
      } else {
        if (questionIndex < _questions.length) {
          _questions[questionIndex] = _questions[questionIndex].copyWith(
            userAnswerTranscript: text,
          );
        }
      }
    } catch (e) {
      if (_currentQuestionIndex == questionIndex) {
        _currentTranscript = "Error transcribing: $e";
      }
      // ignore transcription error details in logs
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

    _questions[_currentQuestionIndex] =
        _questions[_currentQuestionIndex].copyWith(
      userAnswerTranscript: _currentTranscript,
      audioDurationSeconds:
          _currentAudioDuration > 0 ? _currentAudioDuration : 60,
    );

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
      generateReport();
    }
  }

  Future<void> generateReport() async {
    if (_status != InterviewStatus.analyzing) {
      _status = InterviewStatus.analyzing;
      notifyListeners();
    }

    try {
      final report = await _repository.generateInterviewReport(
        questions: _questions,
        jobContext: "Role: $_role. CV: $_cvText",
        language: _locale.startsWith('id') ? 'id' : 'en',
      );

      _report = report;
      _status = InterviewStatus.completed;

      final entity = InterviewEntity(
        id: const Uuid().v4(),
        userId: _userId ?? 'anonymous',
        jobPosition: _role ?? 'Unknown Role',
        jobDescription: _jdText,
        cvText: _cvText,
        questions: _questions,
        report: report,
        createdAt: DateTime.now(),
        isCompleted: true,
      );

      debugPrint('Interview Summary to Save:');
      debugPrint('User ID: ${entity.userId}');
      debugPrint('Report Score: ${report.overallScore}');
      debugPrint('Questions Count: ${entity.questions.length}');

      if (_userId != null) {
        await _repository.saveInterview(entity);
        await loadHistory();
      } else {
        debugPrint('Skip Cloud Save: User is anonymous');
      }
    } catch (e) {
      debugPrint('Error in InterviewProvider.generateReport: $e');
      _status = InterviewStatus.error;
      _errorMessage = 'Failed to generate feedback: $e';
    } finally {
      notifyListeners();
    }
  }

  void cancelAnalysis() {
    if (_status == InterviewStatus.analyzing) {
      _status = InterviewStatus.initial;
      notifyListeners();
    }
  }

  Future<void> playQuestionAudio() async {
    if (_isDisposed) return;

    if (_isPlayingQuestion) {
      await stopAudio();
      return;
    }

    if (_isRecording) return;

    if (_currentQuestionAudio != null) {
      try {
        if (!_isDisposed) {
          await _audioPlayer.stop();
        }
        await _playerCompleteSubscription?.cancel();

        if (_isDisposed) return;
        _isPlayingQuestion = true;
        notifyListeners();

        if (_isDisposed || _isRecording) return;

        if (!_isDisposed) {
          await _audioPlayer
              .play(DeviceFileSource(_currentQuestionAudio!.path));

          _playerCompleteSubscription =
              _audioPlayer.onPlayerComplete.listen((event) {
            if (!_isDisposed) {
              _isPlayingQuestion = false;
              notifyListeners();
            }
          });
        }
      } catch (e) {
        // ignore: empty_catches
        if (!_isDisposed) {
          _isPlayingQuestion = false;
          notifyListeners();
        }
      }
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
    _audioPlayer.stop();

    notifyListeners();
  }
}
