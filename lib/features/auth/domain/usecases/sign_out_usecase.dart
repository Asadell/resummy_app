import 'package:dartz/dartz.dart';
import 'package:resummy_app/core/error/failures.dart';
import 'package:resummy_app/features/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    return await _repository.signOut();
  }
}
