import 'package:dartz/dartz.dart';
import 'package:resummy_app/core/error/failures.dart';
import 'package:resummy_app/core/error/exceptions.dart';
import 'package:resummy_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:resummy_app/features/auth/domain/entities/user_entity.dart';
import 'package:resummy_app/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of Auth Repository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<UserEntity?> get userStream => _remoteDataSource.userStream;

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = _remoteDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await _remoteDataSource.signInWithGoogle();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
