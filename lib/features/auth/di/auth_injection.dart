import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resummy_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:resummy_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:resummy_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:resummy_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:resummy_app/features/auth/domain/usecases/get_user_stream_usecase.dart';
import 'package:resummy_app/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:resummy_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:resummy_app/features/auth/presentation/providers/auth_provider.dart';

/// Setup Dependency Injection for Auth feature
Future<void> setupAuthDI(GetIt getIt) async {
  // External
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => GoogleSignIn());

  // Data Source
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt(), getIt()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => SignInWithGoogleUseCase(getIt()));
  getIt.registerLazySingleton(() => SignOutUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => GetUserStreamUseCase(getIt()));

  // Provider
  getIt.registerLazySingleton<AuthProvider>(
    () => AuthProvider(
      getUserStreamUseCase: getIt(),
      signInWithGoogleUseCase: getIt(),
      signOutUseCase: getIt(),
    ),
  );
}
