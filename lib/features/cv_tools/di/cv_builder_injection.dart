import 'package:get_it/get_it.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/cv_local_data_source.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/cv_remote_data_source.dart';
import 'package:resummy_app/features/cv_tools/data/repositories/cv_builder_repository_impl.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_builder_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resummy_app/core/services/database_helper.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';

Future<void> setupCvBuilderDI(GetIt getIt) async {
  getIt.registerLazySingleton<CVLocalDataSource>(
    () => CVLocalDataSource(getIt<DatabaseHelper>()),
  );

  getIt.registerLazySingleton<CVRemoteDataSource>(
    () => CVRemoteDataSource(getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<CVBuilderRepository>(
    () => CVBuilderRepositoryImpl(
      getIt<CVLocalDataSource>(),
      getIt<CVRemoteDataSource>(),
      FirebaseAuth.instance,
    ),
  );

  getIt.registerLazySingleton<CVBuilderProvider>(
    () => CVBuilderProvider(getIt<CVBuilderRepository>()),
  );
}
