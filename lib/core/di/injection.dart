import 'package:get_it/get_it.dart';
import 'package:resummy_app/core/services/gemini_pool_manager.dart';
import 'package:resummy_app/core/di/storage_injection.dart';
import 'package:resummy_app/features/cv_tools/di/cv_builder_injection.dart';

/// Global GetIt instance for dependency injection
final getIt = GetIt.instance;

/// Initialize all dependencies for the application
/// This should be called in main() before runApp()
Future<void> setupDI() async {
  // Setup core services first
  await _setupCoreServices();

  // Feature-specific DI
  await setupCvBuilderDI(getIt);
  
  // TODO: Add other features
  // await setupCvAnalyzerDI(getIt);
  // await setupCvConverterDI(getIt);
  // await setupCvTranslatorDI(getIt);
  // await setupInterviewDI(getIt);
  // await setupHistoryDI(getIt);
  // await setupAuthDI(getIt);
  // await setupProfileDI(getIt);
}

/// Setup core services (Gemini Pool Manager, Storage, etc.)
Future<void> _setupCoreServices() async {
  // Initialize Gemini Pool Manager as singleton
  // This will pre-initialize all 51 GenerativeModel instances
  getIt.registerSingleton<GeminiPoolManager>(GeminiPoolManager());

  // Setup storage services (Firestore, DO Spaces, SQLite)
  await setupStorageDI(getIt);
}
