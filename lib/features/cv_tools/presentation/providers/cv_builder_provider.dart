import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_builder_repository.dart';

/// Provider for CV Builder state management
class CVBuilderProvider extends ChangeNotifier {
  final CVBuilderRepository _repository;
  final Uuid _uuid = const Uuid();

  CVBuilderProvider(this._repository);

  // Current CV being edited
  CVData? _currentCV;
  CVData? get currentCV => _currentCV;

  // Current step (0-7: Welcome, Step1-7)
  int _currentStep = 0;
  int get currentStep => _currentStep;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // List of all saved CVs
  List<CVData> _savedCVs = [];
  List<CVData> get savedCVs => _savedCVs;

  /// Initialize a new CV
  void startNewCV({bool useProfileData = false}) {
    final now = DateTime.now();
    _currentCV = CVData(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
      name: useProfileData ? '' : '', // TODO: Load from user profile if available
      email: useProfileData ? '' : null,
      phone: useProfileData ? '' : null,
      location: useProfileData ? '' : null,
    );
    _currentStep = 1; // Start at Step 1 (Personal Info)
    _errorMessage = null;
    notifyListeners();
  }

  /// Load existing CV for editing
  Future<void> loadCV(String cvId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cv = await _repository.getCVById(cvId);
      if (cv != null) {
        _currentCV = cv;
        _currentStep = 1; // Start at Step 1 when editing
      } else {
        _errorMessage = 'CV not found';
      }
    } catch (e) {
      _errorMessage = 'Failed to load CV: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all saved CVs
  Future<void> loadAllCVs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _savedCVs = await _repository.getAllCVs();
      // Sort by updated date (newest first)
      _savedCVs.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      _errorMessage = 'Failed to load CVs: $e';
      _savedCVs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save current CV
  Future<bool> saveCurrentCV() async {
    if (_currentCV == null) {
      _errorMessage = 'No CV to save';
      return false;
    }

    // Validate: only name is required
    if (!_currentCV!.isValid) {
      _errorMessage = 'Name is required to save CV';
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedCV = _currentCV!.copyWith(updatedAt: DateTime.now());
      await _repository.saveCV(updatedCV);
      _currentCV = updatedCV;
      await loadAllCVs(); // Refresh the list
      return true;
    } catch (e) {
      _errorMessage = 'Failed to save CV: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a CV
  Future<bool> deleteCV(String cvId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteCV(cvId);
      await loadAllCVs(); // Refresh the list
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete CV: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Navigate to next step
  void nextStep() {
    if (_currentStep < 7) {
      _currentStep++;
      notifyListeners();
    }
  }

  /// Navigate to previous step
  void previousStep() {
    if (_currentStep > 1) {
      _currentStep--;
      notifyListeners();
    }
  }

  /// Go to specific step
  void goToStep(int step) {
    if (step >= 1 && step <= 7) {
      _currentStep = step;
      notifyListeners();
    }
  }

  /// Update personal info (Step 1)
  void updatePersonalInfo({
    String? name,
    String? email,
    String? phone,
    String? linkedin,
    String? portfolio,
    String? location,
  }) {
    if (_currentCV == null) return;

    _currentCV = _currentCV!.copyWith(
      name: name ?? _currentCV!.name,
      email: email,
      phone: phone,
      linkedin: linkedin,
      portfolio: portfolio,
      location: location,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Add education entry (Step 2)
  void addEducation(Education education) {
    if (_currentCV == null) return;

    final updatedEducation = List<Education>.from(_currentCV!.education)..add(education);
    _currentCV = _currentCV!.copyWith(
      education: updatedEducation,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Update education entry
  void updateEducation(int index, Education education) {
    if (_currentCV == null || index >= _currentCV!.education.length) return;

    final updatedEducation = List<Education>.from(_currentCV!.education);
    updatedEducation[index] = education;
    _currentCV = _currentCV!.copyWith(
      education: updatedEducation,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Remove education entry
  void removeEducation(int index) {
    if (_currentCV == null || index >= _currentCV!.education.length) return;

    final updatedEducation = List<Education>.from(_currentCV!.education)..removeAt(index);
    _currentCV = _currentCV!.copyWith(
      education: updatedEducation,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Add work experience entry (Step 3)
  void addWorkExperience(WorkExperience experience) {
    if (_currentCV == null) return;

    final updatedExperience = List<WorkExperience>.from(_currentCV!.workExperience)..add(experience);
    _currentCV = _currentCV!.copyWith(
      workExperience: updatedExperience,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Update work experience entry
  void updateWorkExperience(int index, WorkExperience experience) {
    if (_currentCV == null || index >= _currentCV!.workExperience.length) return;

    final updatedExperience = List<WorkExperience>.from(_currentCV!.workExperience);
    updatedExperience[index] = experience;
    _currentCV = _currentCV!.copyWith(
      workExperience: updatedExperience,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Remove work experience entry
  void removeWorkExperience(int index) {
    if (_currentCV == null || index >= _currentCV!.workExperience.length) return;

    final updatedExperience = List<WorkExperience>.from(_currentCV!.workExperience)..removeAt(index);
    _currentCV = _currentCV!.copyWith(
      workExperience: updatedExperience,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Add certification (Step 4)
  void addCertification(Certification certification) {
    if (_currentCV == null) return;

    final updatedCertifications = List<Certification>.from(_currentCV!.certifications)..add(certification);
    _currentCV = _currentCV!.copyWith(
      certifications: updatedCertifications,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Update certification
  void updateCertification(int index, Certification certification) {
    if (_currentCV == null || index >= _currentCV!.certifications.length) return;

    final updatedCertifications = List<Certification>.from(_currentCV!.certifications);
    updatedCertifications[index] = certification;
    _currentCV = _currentCV!.copyWith(
      certifications: updatedCertifications,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Remove certification
  void removeCertification(int index) {
    if (_currentCV == null || index >= _currentCV!.certifications.length) return;

    final updatedCertifications = List<Certification>.from(_currentCV!.certifications)..removeAt(index);
    _currentCV = _currentCV!.copyWith(
      certifications: updatedCertifications,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Update skills (Step 5)
  void updateSkills({
    List<String>? technicalSkills,
    List<String>? softSkills,
  }) {
    if (_currentCV == null) return;

    _currentCV = _currentCV!.copyWith(
      technicalSkills: technicalSkills ?? _currentCV!.technicalSkills,
      softSkills: softSkills ?? _currentCV!.softSkills,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Update professional summary (Step 6)
  void updateProfessionalSummary(String? summary) {
    if (_currentCV == null) return;

    _currentCV = _currentCV!.copyWith(
      professionalSummary: summary,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Update additional sections (Step 7)
  void updateAdditionalSections(Map<String, dynamic> sections) {
    if (_currentCV == null) return;

    _currentCV = _currentCV!.copyWith(
      additionalSections: sections,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Update template
  void updateTemplate(String template) {
    if (_currentCV == null) return;

    _currentCV = _currentCV!.copyWith(
      template: template,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Clear current CV
  void clearCurrentCV() {
    _currentCV = null;
    _currentStep = 0;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Helper methods for UI compatibility
  void addSkill(String skill) {
    if (_currentCV == null) return;
    if (!_currentCV!.technicalSkills.contains(skill)) {
      updateSkills(technicalSkills: List.from(_currentCV!.technicalSkills)..add(skill));
    }
  }

  void removeSkill(String skill) {
    if (_currentCV == null) return;
    updateSkills(technicalSkills: List.from(_currentCV!.technicalSkills)..remove(skill));
  }

  void updateSummary(String summary) {
    updateProfessionalSummary(summary);
  }
}
