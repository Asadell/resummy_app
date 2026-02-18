import 'package:get_it/get_it.dart';
import 'package:resummy_app/core/services/database_helper.dart';
import 'package:resummy_app/features/history/data/data_sources/history_local_data_source.dart';
import 'package:resummy_app/features/history/data/repositories/history_repository_impl.dart';
import 'package:resummy_app/features/history/domain/repositories/history_repository.dart';

/// Setup Dependency Injection for History feature
Future<void> setupHistoryDI(GetIt getIt) async {
  // Data Source
  getIt.registerLazySingleton<HistoryLocalDataSource>(
    () => HistoryLocalDataSource(getIt<DatabaseHelper>()),
  );

  // Repository
  getIt.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(getIt<HistoryLocalDataSource>()),
  );
}
