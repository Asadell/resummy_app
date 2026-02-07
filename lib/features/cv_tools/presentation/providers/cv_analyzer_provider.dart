import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/features/auth/data/user_profile_repository.dart';

class CvAnalyzerProvider extends ChangeNotifier {
  final UserProfileRepository _userProfileRepository;

  CvAnalyzerProvider({required UserProfileRepository userProfileRepository})
      : _userProfileRepository = userProfileRepository;

  PlatformFile? _selectedFile;
  String _jobPosition = '';
  bool _isLoading = false;
  bool _isDataLoaded = false;

  PlatformFile? get selectedFile => _selectedFile;
  String get jobPosition => _jobPosition;
  bool get isLoading => _isLoading;

  FileInfo? get selectedFileInfo {
    if (_selectedFile == null) return null;

    return FileInfo(
      name: _selectedFile!.name,
      size: _selectedFile!.size,
      extension: _selectedFile!.extension!,
      path: _selectedFile!.path!,
    );
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
    _selectedFile = file;
    notifyListeners();
  }

  void clearSelectedFile() {
    _selectedFile = null;
    notifyListeners();
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
