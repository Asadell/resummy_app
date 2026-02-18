import 'package:get_it/get_it.dart';
import 'package:resummy_app/core/services/gemini_pool_manager.dart';
import 'package:resummy_app/core/di/storage_injection.dart';
import 'package:resummy_app/features/cv_tools/di/cv_builder_injection.dart';
import 'package:resummy_app/features/cv_tools/di/cv_analysis_injection.dart';
import 'package:resummy_app/features/interview/di/interview_injection.dart';
import 'package:resummy_app/features/history/di/history_injection.dart';
import 'package:resummy_app/features/auth/di/auth_injection.dart';
import 'package:resummy_app/features/profile/di/profile_injection.dart';

final getIt = GetIt.instance;

Future<void> setupDI() async {
  await _setupCoreServices();

  await setupCvBuilderDI(getIt);
  await setupCvAnalysisAndConversionDI(getIt);
  await setupInterviewDI(getIt);
  await setupHistoryDI(getIt);
  await setupAuthDI(getIt);
  await setupProfileDI(getIt);
}

Future<void> _setupCoreServices() async {
  getIt.registerSingleton<GeminiPoolManager>(GeminiPoolManager());

  await setupStorageDI(getIt);
}
