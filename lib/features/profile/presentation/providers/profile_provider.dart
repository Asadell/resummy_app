import 'package:flutter/material.dart';
import 'package:resummy_app/features/auth/domain/user_profile_model.dart';
import 'package:resummy_app/features/auth/data/user_profile_repository.dart';
import 'package:resummy_app/features/auth/presentation/providers/auth_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final UserProfileRepository _repository;
  final AuthProvider _authProvider;

  UserProfile? _profile;
  bool _isLoading = false;
  String? _error;

  ProfileProvider({
    required UserProfileRepository repository,
    required AuthProvider authProvider,
  })  : _repository = repository,
        _authProvider = authProvider {
    _authProvider.addListener(_onAuthChanged);

    _onAuthChanged();
  }

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    final user = _authProvider.currentUser;
    if (user != null) {
      if (_profile?.uid != user.id) {
        loadProfile(user.id);
      }
    } else {
      _profile = null;
      notifyListeners();
    }
  }

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

  Future<void> refreshProfile() async {
    if (_profile == null) return;
    await loadProfile(_profile!.uid);
  }

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
      final success =
          await _repository.updateUserProfile(_profile!.uid, updatedData);
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

  Future<void> createProfileIfNotExists(
    String uid, {
    required String email,
    String? fullName,
    String? photoUrl,
  }) async {
    try {
      final existing = await _repository.getUserProfile(uid);
      if (existing != null) {
        _profile = existing;
      } else {
        final newProfile = UserProfile(
          uid: uid,
          email: email,
          fullName: fullName ?? '',
          photoUrl: photoUrl,
          onboardingDone: false,
        );
        await _repository.createUserProfile(newProfile);
        _profile = newProfile;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
