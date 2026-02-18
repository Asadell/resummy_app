import 'package:dartz/dartz.dart';
import 'package:resummy_app/core/error/failures.dart';
import 'package:resummy_app/features/auth/domain/entities/user_entity.dart';
import 'package:resummy_app/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository _repository;

  SignInWithGoogleUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await _repository.signInWithGoogle();
  }
}
