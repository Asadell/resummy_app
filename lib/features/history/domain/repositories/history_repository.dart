import 'package:resummy_app/features/history/domain/entities/activity_entity.dart';

abstract class HistoryRepository {
  Future<List<ActivityEntity>> getActivities({
    required String userId,
    int limit = 20,
    int offset = 0,
  });

  Future<void> clearHistory(String userId);
}
