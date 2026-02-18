import 'package:resummy_app/features/history/domain/entities/activity_entity.dart';

/// Repository interface for History operations
abstract class HistoryRepository {
  /// Get aggregated activity history for a user
  Future<List<ActivityEntity>> getActivities({
    required String userId,
    int limit = 20,
    int offset = 0,
  });

  /// Clear all history for a user (local only)
  Future<void> clearHistory(String userId);
}
