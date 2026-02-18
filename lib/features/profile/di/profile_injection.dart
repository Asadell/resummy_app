import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resummy_app/features/auth/data/user_profile_repository.dart';
import 'package:resummy_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:resummy_app/features/auth/presentation/providers/auth_provider.dart';

/// Setup Dependency Injection for Profile feature
Future<void> setupProfileDI(GetIt getIt) async {
  // Repository
  getIt.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepository(getIt<FirebaseFirestore>()),
  );

  // Provider
  getIt.registerLazySingleton<ProfileProvider>(
    () => ProfileProvider(
      repository: getIt<UserProfileRepository>(),
      authProvider: getIt<AuthProvider>(),
    ),
  );
}
