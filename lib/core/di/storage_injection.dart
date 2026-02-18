import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resummy_app/core/services/do_spaces_service.dart';
import 'package:resummy_app/core/services/database_helper.dart';

/// Setup storage-related dependencies (Firestore, DO Spaces, SQLite)
Future<void> setupStorageDI(GetIt getIt) async {
  // Register Firestore instance
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Register DO Spaces service for PDF storage
  getIt.registerLazySingleton<DOSpacesService>(
    () => DOSpacesService(),
  );

  // Register SQLite database helper for offline storage
  getIt.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper(),
  );
}
