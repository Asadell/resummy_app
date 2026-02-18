import 'dart:async';
import 'package:flutter/material.dart';
import 'package:resummy_app/features/auth/domain/entities/user_entity.dart';
import 'package:resummy_app/features/auth/domain/usecases/get_user_stream_usecase.dart';
import 'package:resummy_app/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:resummy_app/features/auth/domain/usecases/sign_out_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final GetUserStreamUseCase _getUserStreamUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignOutUseCase _signOutUseCase;

  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<UserEntity?>? _userSubscription;

  AuthProvider({
    required GetUserStreamUseCase getUserStreamUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required SignOutUseCase signOutUseCase,
  })  : _getUserStreamUseCase = getUserStreamUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        _signOutUseCase = signOutUseCase {
    _init();
  }

  UserEntity? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _init() {
    _userSubscription = _getUserStreamUseCase().listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _signInWithGoogleUseCase();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (user) {
        // User update handled by stream
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    final result = await _signOutUseCase();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (_) {
        // User update handled by stream
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}
