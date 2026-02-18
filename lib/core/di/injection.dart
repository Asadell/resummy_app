import 'package:get_it/get_it.dart';
import 'package:resummy_app/core/services/gemini_pool_manager.dart';

/// Global GetIt instance for dependency injection
final getIt = GetIt.instance;

/// Initialize all dependencies for the application
/// This should be called in main() before runApp()
Future<void> setupDI() async {
  // Setup core services first
  await _setupCoreServices();

  // Feature-specific DI will be added here:
  // await setupCvBuilderDI();
  // await setupCvAnalyzerDI();
  // await setupCvConverterDI();
  // await setupCvTranslatorDI();
  // await setupInterviewDI();
  // await setupHistoryDI();
  // await setupAuthDI();
  // await setupProfileDI();
}

/// Setup core services (Gemini Pool Manager, Storage, etc.)
Future<void> _setupCoreServices() async {
  // Initialize Gemini Pool Manager as singleton
  // This will pre-initialize all 51 GenerativeModel instances
  getIt.registerSingleton<GeminiPoolManager>(GeminiPoolManager());

  // Additional core services will be registered here:
  // - DO Spaces client
  // - Offline manager
  // - FirebaseFirestore instance
  // - etc.
}
