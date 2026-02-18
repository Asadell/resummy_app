import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:resummy_app/core/utils/pdf_utils.dart';
import 'package:resummy_app/features/cv_tools/data/services/cv_analyzer_service.dart';
import 'package:resummy_app/features/cv_tools/data/services/cv_ats_converter_service.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';

class CvAnalyzerProvider extends ChangeNotifier {
  final CvAnalyzerService _service;

  CvAnalyzerProvider({CvAnalyzerService? service}) 
      : _service = service ?? CvAnalyzerService();

  // ── File state ──
  PlatformFile? _selectedFile;
  String _extractedText = '';
  bool _isPickingFile = false;
  bool _isConverting = false;

  // ── Input state ──
  String _jobPosition = '';
  String _jobDescription = '';

  // ── Analysis state ──
  bool _isAnalyzing = false;
  CvAnalysisResult? _result;
  String? _errorMessage;

  // ── Getters ──
  PlatformFile? get selectedFile => _selectedFile;
  String get extractedText => _extractedText;
  bool get isPickingFile => _isPickingFile;
  bool get isConverting => _isConverting;
  bool get isAnalyzing => _isAnalyzing;
  CvAnalysisResult? get result => _result;
  String? get errorMessage => _errorMessage;
  String get jobPosition => _jobPosition;
  String get jobDescription => _jobDescription;

  bool get hasFile => _selectedFile != null && _extractedText.isNotEmpty;
  bool get hasResult => _result != null;

  String? get fileName => _selectedFile?.name;
  String? get fileSize {
    if (_selectedFile == null) return null;
    final mb = _selectedFile!.size / (1024 * 1024);
    return '${mb.toStringAsFixed(2)} MB';
  }

  // ── Setters ──
  void setJobPosition(String v) {
    _jobPosition = v;
    notifyListeners();
  }

  void setJobDescription(String v) {
    _jobDescription = v;
    notifyListeners();
  }

  // ── Pick PDF & extract text (stay on same screen) ──
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

      // Extract text di background isolate (max 5 halaman via PdfUtils)
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
      _result = null; // reset saat ganti file
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

  // ── Analyze ──
  Future<void> analyze(String languageCode) async {
    if (!hasFile) return;

    _isAnalyzing = true;
    _errorMessage = null;
    _result = null;
    notifyListeners();

    try {
      _result = await _service.analyze(
        cvText: _extractedText,
        jobPosition: _jobPosition.isNotEmpty ? _jobPosition : 'General Position',
        jobDescription: _jobDescription,
        language: languageCode,
      );
    } catch (e) {
      _errorMessage =
          'Analisis gagal: ${e.toString().replaceAll('Exception: ', '')}';
    }

    _isAnalyzing = false;
    notifyListeners();
  }

  // ── Convert to CV ──
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
      // Minta Gemini terapkan saran dan return JSON CVData
      final json = await _service.convertAppliedSuggestionsToCvJson(
        originalCvText: _extractedText,
        appliedSuggestions: applied,
        jobPosition: _jobPosition,
      );

      // Parse JSON → CVData (gunakan CvAtsConverterService yang sudah ada)
      final converterService = CvAtsConverterService();
      final cvData = converterService.parseCvJson(json, source: 'analyzer');

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

  // ── Suggestion actions ──
  void applySuggestion(String id) {
    _findSuggestion(id)
      ?..isApplied = true
      ..isDismissed = false;
    notifyListeners();
  }

  void dismissSuggestion(String id) {
    _findSuggestion(id)
      ?..isDismissed = true
      ..isApplied = false;
    notifyListeners();
  }

  void undoSuggestion(String id) {
    _findSuggestion(id)
      ?..isDismissed = false
      ..isApplied = false;
    notifyListeners();
  }

  CvSuggestion? _findSuggestion(String id) =>
      _result?.suggestions.where((s) => s.id == id).firstOrNull;

  // ── Clear ──
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

  // ── Helpers ──
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
