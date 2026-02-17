import 'package:flutter/material.dart';
import 'package:resummy_app/features/auth/domain/user_profile_model.dart';
import 'package:resummy_app/features/auth/data/user_profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final UserProfileRepository _repository = UserProfileRepository();
  UserProfile? _profile;
  bool _isLoading = false;
  String? _error;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initial load called when AuthProvider changes
  Future<void> loadProfile(String? uid) async {
    if (uid == null) {
      _profile = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _repository.getUserProfile(uid);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reload manually
  Future<void> refreshProfile() async {
    if (_profile == null) return;
    await loadProfile(_profile!.uid);
  }

  // Update profile and sync with Firestore
  Future<void> updateProfile({
    String? fullName,
    String? email,
    String? workStatus,
    String? targetRole,
    String? careerGoal,
  }) async {
    if (_profile == null) return;

    final updatedData = {
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      if (workStatus != null) 'workStatus': workStatus,
      if (targetRole != null) 'targetRole': targetRole,
      if (careerGoal != null) 'careerGoal': careerGoal,
    };

    if (updatedData.isEmpty) return;

    try {
      final success = await _repository.updateUserProfile(_profile!.uid, updatedData);
      if (success) {
        _profile = _profile!.copyWith(
          fullName: fullName,
          email: email,
          workStatus: workStatus,
          targetRole: targetRole,
          careerGoal: careerGoal,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
