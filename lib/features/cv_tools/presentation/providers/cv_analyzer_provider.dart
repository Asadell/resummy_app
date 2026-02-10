import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:resummy_app/core/resources/data_state.dart';
import 'package:resummy_app/core/utils/pdf_utils.dart';
import 'package:resummy_app/features/auth/data/user_profile_repository.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis_entity.dart';
import 'package:resummy_app/features/cv_tools/domain/usecases/analyze_cv_usecase.dart';

class CvAnalyzerProvider extends ChangeNotifier {
  final UserProfileRepository _userProfileRepository;
  final AnalyzeCvUseCase _analyzeCvUseCase;

  CvAnalyzerProvider({
    required UserProfileRepository userProfileRepository,
    required AnalyzeCvUseCase analyzeCvUseCase,
  })  : _userProfileRepository = userProfileRepository,
        _analyzeCvUseCase = analyzeCvUseCase;

  PlatformFile? _selectedFile;
  CvAnalysisEntity? _cvAnalysisResult;
  String _extractedText = '';
  String _jobPosition = '';
  String _errorMessage = '';
  bool _isLoading = false;
  bool _isDataLoaded = false;

  PlatformFile? get selectedFile => _selectedFile;
  CvAnalysisEntity? get analysisResult => _cvAnalysisResult;
  String get jobPosition => _jobPosition;
  bool get isLoading => _isLoading;
  String get extractedText => _extractedText;
  String get errorMessage => _errorMessage;
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
    if (_isDataLoaded || _jobPosition.isNotEmpty) return;

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

  Future<void> selectFileAndVerify() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      _errorMessage = '';
      _isLoading = true;
      notifyListeners();

      if (result != null && result.files.isNotEmpty) {
        final temporarySelectedFile = result.files.first;
        final temporaryExtractedText =
            await compute(PdfUtils().extractText, temporarySelectedFile.path!);

        if (isValidCvContent(temporaryExtractedText)) {
          _selectedFile = temporarySelectedFile;
          _extractedText = temporaryExtractedText;
        } else {
          _errorMessage =
              'The selected file does not appear to be a valid CV. Please select a different file.';
        }
      }
    } catch (e) {
      debugPrint('Error selecting file: $e');
      _errorMessage =
          'An error occurred while selecting the file. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearState() {
    _selectedFile = null;
    _cvAnalysisResult = null;
    _extractedText = '';
    _isLoading = false;
    _errorMessage = '';
    _isDataLoaded = false;

    notifyListeners();
  }

  void clearPdfText() {
    _extractedText = '';
    _errorMessage = '';
    notifyListeners();
  }

  void clearAnalysisResult() {
    _cvAnalysisResult = null;
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> analyzeCv(String language) async {
    if (_extractedText.isEmpty) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await _analyzeCvUseCase.call(
      params: AnalyzeCvParams(
        cvText: _extractedText,
        role: _jobPosition,
        language: language,
      ),
    );

    if (result is DataSuccess) {
      _cvAnalysisResult = result.data;
    } else if (result is DataFailed) {
      _errorMessage = result.error?.message ?? '';
    }

    _isLoading = false;
    notifyListeners();
  }

  bool isValidCvContent(String text) {
    final textLower = text.toLowerCase();
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
