import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resummy_app/core/services/gemini_pool_manager.dart';

/// Setup Gemini-related dependencies
Future<void> setupGeminiDI(GetIt getIt) async {
  // GeminiPoolManager is already registered in core injection.dart
  // This file is for future Gemini-specific configurations if needed
}

/// Setup storage-related dependencies (Firestore, DO Spaces, local storage)
Future<void> setupStorageDI(GetIt getIt) async {
  // Register Firestore instance
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // DO Spaces and local storage will be added here
  // - MinioClient for DO Spaces
  // - Hive/SharedPreferences for local cache
}
