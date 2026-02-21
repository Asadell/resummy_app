import 'package:get_it/get_it.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_analysis_repository.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_builder_repository.dart';
import 'package:resummy_app/features/history/data/repositories/history_repository_impl.dart';
import 'package:resummy_app/features/history/domain/repositories/history_repository.dart';
import 'package:resummy_app/features/history/presentation/providers/history_provider.dart';
import 'package:resummy_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:resummy_app/features/interview/domain/repositories/interview_repository.dart';

Future<void> setupHistoryDI(GetIt getIt) async {
  getIt.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(
      getIt<CVBuilderRepository>(),
      getIt<InterviewRepository>(),
      getIt<CVAnalysisRepository>(),
    ),
  );

  getIt.registerFactory<HistoryProvider>(
    () => HistoryProvider(
      repository: getIt<HistoryRepository>(),
      authProvider: getIt<AuthProvider>(),
    ),
  );
}
