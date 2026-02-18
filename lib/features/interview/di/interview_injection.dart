import 'package:get_it/get_it.dart';
import 'package:resummy_app/core/services/gemini_pool_manager.dart';
import 'package:resummy_app/core/services/database_helper.dart';
import 'package:resummy_app/features/interview/data/data_sources/interview_local_data_source.dart';
import 'package:resummy_app/features/interview/data/data_sources/interview_remote_data_source.dart';
import 'package:resummy_app/features/interview/data/data_sources/speech_data_source.dart';
import 'package:resummy_app/features/interview/data/repositories/interview_repository_impl.dart';
import 'package:resummy_app/features/interview/domain/repositories/interview_repository.dart';

/// Setup Dependency Injection for Interview feature
Future<void> setupInterviewDI(GetIt getIt) async {
  // Data Sources
  getIt.registerLazySingleton<InterviewRemoteDataSource>(
    () => InterviewRemoteDataSource(getIt<GeminiPoolManager>()),
  );

  getIt.registerLazySingleton<InterviewLocalDataSource>(
    () => InterviewLocalDataSource(getIt<DatabaseHelper>()),
  );

  getIt.registerLazySingleton<SpeechDataSource>(
    () => SpeechDataSource(getIt<GeminiPoolManager>()),
  );

  // Repository
  getIt.registerLazySingleton<InterviewRepository>(
    () => InterviewRepositoryImpl(
      getIt<InterviewRemoteDataSource>(),
      getIt<InterviewLocalDataSource>(),
      getIt<SpeechDataSource>(),
    ),
  );
}
