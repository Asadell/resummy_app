import 'package:resummy_app/features/history/data/data_sources/history_local_data_source.dart';
import 'package:resummy_app/features/history/domain/entities/activity_entity.dart';
import 'package:resummy_app/features/history/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource _localDataSource;

  HistoryRepositoryImpl(this._localDataSource);

  @override
  Future<List<ActivityEntity>> getActivities({
    required String userId,
    int limit = 20,
    int offset = 0,
  }) async {
    return await _localDataSource.getActivities(
      userId,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<void> clearHistory(String userId) async {
    await _localDataSource.clearHistory(userId);
  }
}
