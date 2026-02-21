import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:resummy_app/core/di/injection.dart';
import 'package:resummy_app/core/utils/pdf_utils.dart';
import 'package:resummy_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_analysis_repository.dart';

class CvAnalyzerProvider extends ChangeNotifier {
  final CVAnalysisRepository _repository;
  final AuthProvider _authProvider;

  CvAnalyzerProvider({
    CVAnalysisRepository? repository,
    AuthProvider? authProvider,
  })  : _repository = repository ?? getIt<CVAnalysisRepository>(),
        _authProvider = authProvider ?? getIt<AuthProvider>();

  PlatformFile? _selectedFile;
  String _extractedText = '';
  bool _isPickingFile = false;
  bool _isConverting = false;

  String _jobPosition = '';
  String _jobDescription = '';

  bool _isAnalyzing = false;
  bool _isLoadingHistory = false;
  CvAnalysisResult? _result;
  String? _errorMessage;

  List<CvAnalysisResult> _savedAnalyses = [];

  PlatformFile? get selectedFile => _selectedFile;
  String get extractedText => _extractedText;
  bool get isPickingFile => _isPickingFile;
  bool get isConverting => _isConverting;
  bool get isAnalyzing => _isAnalyzing;
  bool get isLoadingHistory => _isLoadingHistory;
  CvAnalysisResult? get result => _result;
  String? get errorMessage => _errorMessage;
  String get jobPosition => _jobPosition;
  String get jobDescription => _jobDescription;

  List<CvAnalysisResult> get savedAnalyses => _savedAnalyses;

  bool get hasFile => _extractedText.isNotEmpty;
  bool get hasResult => _result != null;

  String? get fileName => _selectedFile?.name;
  String? get fileSize {
    if (_selectedFile == null) return null;
    final mb = _selectedFile!.size / (1024 * 1024);
    return '${mb.toStringAsFixed(2)} MB';
  }

  void setJobPosition(String v) {
    _jobPosition = v;
    notifyListeners();
  }

  void setJobDescription(String v) {
    _jobDescription = v;
    notifyListeners();
  }

  void loadResult(CvAnalysisResult result) {
    _result = result;
    _jobPosition = result.jobPosition;
    _jobDescription = result.jobDescription ?? '';
    _extractedText = 'Analysis history item';
    notifyListeners();
  }

  Future<void> loadAnalysisHistory() async {
    _isLoadingHistory = true;
    notifyListeners();

    try {
      final userId = _authProvider.isAuthenticated
          ? _authProvider.currentUser!.id
          : 'anonymous';
      _savedAnalyses = await _repository.getAnalysisHistory(userId);
    } catch (e) {
      _savedAnalyses = [];
    }

    _isLoadingHistory = false;
    notifyListeners();
  }

  void prepareForNewAnalysis() {
    _selectedFile = null;
    _extractedText = '';
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> deleteResult(String id) async {
    await _repository.deleteAnalysis(id);
    if (_result?.id == id) {
      clearAll();
    }
    await loadAnalysisHistory();
  }

  void setExtractedText(String text) {
    _extractedText = text;
    _selectedFile = null;
    notifyListeners();
  }

  Future<void> pickAndExtract() async {
    _isPickingFile = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (picked == null || picked.files.isEmpty) {
        _isPickingFile = false;
        notifyListeners();
        return;
      }

      final file = picked.files.first;
      if (file.path == null) {
        _errorMessage = 'Gagal membaca file. Coba lagi.';
        _isPickingFile = false;
        notifyListeners();
        return;
      }

      final text = await compute(PdfUtils().extractText, file.path!);

      if (!_isValidCv(text)) {
        _errorMessage =
            'File tidak terdeteksi sebagai CV. Pastikan PDF berisi teks CV/Resume.';
        _isPickingFile = false;
        notifyListeners();
        return;
      }

      _selectedFile = file;
      _extractedText = text;
      _result = null;
      _errorMessage = null;
    } catch (e) {
      if (e.toString().contains('MAX_PAGES_EXCEEDED')) {
        _errorMessage = 'Maksimal 5 halaman untuk analisis CV.';
      } else {
        _errorMessage = 'Error membaca PDF: $e';
      }
    }

    _isPickingFile = false;
    notifyListeners();
  }

  Future<void> analyze(String languageCode) async {
    if (!hasFile) return;

    _isAnalyzing = true;
    _errorMessage = null;
    _result = null;
    notifyListeners();

    try {
      final result = await _repository.analyzeCV(
        cvText: _extractedText,
        jobPosition:
            _jobPosition.isNotEmpty ? _jobPosition : 'General Position',
        jobDescription: _jobDescription,
        language: languageCode,
      );

      _result = result;

      final userId = _authProvider.isAuthenticated
          ? _authProvider.currentUser!.id
          : 'anonymous';
      await _repository.saveAnalysisResult(
        _result!,
        userId,
      );

      await loadAnalysisHistory();
    } catch (e) {
      _errorMessage =
          'Analisis gagal: ${e.toString().replaceAll('Exception: ', '')}';
    }

    _isAnalyzing = false;
    notifyListeners();
  }

  Future<CVData?> convertAppliedToCv() async {
    if (_result == null) return null;

    final applied = _result!.suggestions.where((s) => s.isApplied).toList();
    if (applied.isEmpty) {
      return null;
    }

    _isConverting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cvData = await _repository.applyAnalysisSuggestions(
        originalCvText: _extractedText,
        appliedSuggestions: applied,
        jobPosition: _jobPosition,
      );

      _isConverting = false;
      notifyListeners();
      return cvData;
    } catch (e) {
      _errorMessage =
          'Gagal membuat CV: ${e.toString().replaceAll('Exception: ', '')}';
      _isConverting = false;
      notifyListeners();
      return null;
    }
  }

  void applySuggestion(String id) {
    _updateSuggestion(id, isApplied: true, isDismissed: false);
  }

  void dismissSuggestion(String id) {
    _updateSuggestion(id, isDismissed: true, isApplied: false);
  }

  void undoSuggestion(String id) {
    _updateSuggestion(id, isDismissed: false, isApplied: false);
  }

  void _updateSuggestion(String id,
      {required bool isApplied, required bool isDismissed}) {
    if (_result == null) return;
    final index = _result!.suggestions.indexWhere((s) => s.id == id);
    if (index == -1) return;

    final newSuggestion = _result!.suggestions[index].copyWith(
      isApplied: isApplied,
      isDismissed: isDismissed,
    );

    final newSuggestions = List<CvSuggestion>.from(_result!.suggestions);
    newSuggestions[index] = newSuggestion;

    _result = _result!.copyWith(suggestions: newSuggestions);
    notifyListeners();
  }

  void clearFile() {
    _selectedFile = null;
    _extractedText = '';
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearAll() {
    _selectedFile = null;
    _extractedText = '';
    _jobPosition = '';
    _jobDescription = '';
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }

  bool _isValidCv(String text) {
    final lower = text.toLowerCase();
    final keywords = [
      'experience',
      'pengalaman',
      'education',
      'pendidikan',
      'skills',
      'keahlian',
      'kemampuan',
      'summary',
      'profile',
      'tentang saya',
      'projects',
      'proyek',
      'achievement',
      'prestasi',
      'work',
      'kerja',
      'contact',
      'kontak',
    ];
    int count = 0;
    for (final kw in keywords) {
      if (lower.contains(kw)) count++;
    }
    return count >= 2;
  }
}
