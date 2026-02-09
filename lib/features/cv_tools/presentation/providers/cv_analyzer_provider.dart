import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:resummy_app/core/utils/pdf_utils.dart';
import 'package:resummy_app/features/auth/data/user_profile_repository.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis_entity.dart';
import 'package:resummy_app/features/cv_tools/domain/usecases/analyze_cv_usecase.dart';

class CvAnalyzerProvider extends ChangeNotifier {
  final UserProfileRepository _userProfileRepository;

  CvAnalyzerProvider({required UserProfileRepository userProfileRepository})
      : _userProfileRepository = userProfileRepository;

  PlatformFile? _selectedFile;
  CvAnalysisEntity? cvAnalysisResult;
  String _extractedText = '';
  String _jobPosition = '';
  bool _isLoading = false;
  bool _isDataLoaded = false;

  PlatformFile? get selectedFile => _selectedFile;
  CvAnalysisEntity? get analysisResult => cvAnalysisResult;
  String get jobPosition => _jobPosition;
  bool get isLoading => _isLoading;
  String get extractedText => _extractedText;
  FileInfo? get selectedFileInfo {
    if (_selectedFile != null) {
      return FileInfo(
        name: _selectedFile!.name,
        size: _selectedFile!.size,
        extension: _selectedFile!.extension!,
        path: _selectedFile!.path!,
      );
    }

    return null;
  }

  Future<void> loadInitialData(String userId) async {
    if (_isDataLoaded) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _userProfileRepository.getUserProfile(userId);

      _isDataLoaded = true;
      _jobPosition = result?.targetRole ?? '';
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void setJobPosition(String newJobPosition) {
    _jobPosition = newJobPosition;
    notifyListeners();
  }

  void setSelectedFile(PlatformFile? file) {
    clearState();
    _selectedFile = file;

    notifyListeners();
  }

  void clearState() {
    _selectedFile = null;
    cvAnalysisResult = null;
    _extractedText = '';
    _jobPosition = '';
    _isLoading = false;
    _isDataLoaded = false;

    notifyListeners();
  }

  Future<void> readPdfText() async {
    if (_selectedFile == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _extractedText =
          await compute(PdfUtils().extractText, _selectedFile!.path!);
    } catch (e) {
      debugPrint('Error extracting text from PDF: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> analyzeCv() async {
    if (_extractedText.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      cvAnalysisResult =
          await AnalyzeCvUseCase().call(_jobPosition, _extractedText);
    } catch (e) {
      debugPrint('Error during CV analysis: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  bool verifyCvFile() {
    final textLower = _extractedText.toLowerCase();
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

    int matchCount = 0;

    for (final keyword in keywords) {
      if (textLower.contains(keyword)) {
        matchCount++;
      }
    }

    return matchCount >= 3;
  }
}

class FileInfo {
  /// The name of the file.
  late String name;

  /// The size of the file in megabytes.
  late String size;

  /// The file extension.
  late String extension;

  /// The file path.
  late String path;

  FileInfo({
    required this.name,
    required int size,
    required this.extension,
    required this.path,
  }) : size = (size / (1024 * 1024)).toStringAsFixed(2);
}
