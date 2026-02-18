import 'package:resummy_app/features/history/domain/entities/activity_item.dart';

abstract class HistoryRepository {
  Future<List<ActivityItem>> getActivities(String userId);
}
