import 'package:resummy_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:resummy_app/features/auth/domain/entities/user_entity.dart';

/// Repository interface for Authentication
abstract class AuthRepository {
  /// Sign in with Google
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// Sign out
  Future<Either<Failure, void>> signOut();

  /// Get current authenticated user
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Stream of user changes
  Stream<UserEntity?> get userStream;
}
