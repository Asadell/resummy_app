import 'package:resummy_app/features/auth/domain/entities/user_entity.dart';
import 'package:resummy_app/features/auth/domain/repositories/auth_repository.dart';

class GetUserStreamUseCase {
  final AuthRepository _repository;

  GetUserStreamUseCase(this._repository);

  Stream<UserEntity?> call() {
    return _repository.userStream;
  }
}
