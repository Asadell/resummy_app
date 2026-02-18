import 'package:resummy_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:resummy_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Stream<UserEntity?> get userStream;
}
