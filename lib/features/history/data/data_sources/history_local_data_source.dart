import 'dart:convert';
import 'package:resummy_app/core/services/database_helper.dart';
import 'package:resummy_app/features/history/domain/entities/activity_entity.dart';

class HistoryLocalDataSource {
  final DatabaseHelper _dbHelper;

  HistoryLocalDataSource(this._dbHelper);

  Future<List<ActivityEntity>> getActivities(String userId,
      {int limit = 20, int offset = 0}) async {
    try {
      final List<ActivityEntity> activities = [];

      final cvs = await _dbHelper.query(
        DatabaseHelper.tableCVs,
        where: 'userId = ?',
        whereArgs: [userId],
      );

      for (final cv in cvs) {
        activities.add(ActivityEntity(
          id: cv['id'] as String,
          userId: userId,
          type: ActivityType.cvCreated,
          title: cv['title'] as String? ?? 'Untitled CV',
          subtitle: 'Created ${cv['source'] ?? 'manually'}',
          timestamp:
              DateTime.fromMillisecondsSinceEpoch(cv['createdAt'] as int),
          relatedId: cv['id'] as String,
          metadata: {'source': cv['source']},
        ));
      }

      final analyses = await _dbHelper.query(
        DatabaseHelper.tableAnalysisHistory,
        where: 'userId = ?',
        whereArgs: [userId],
      );

      for (final analysis in analyses) {
        final score = analysis['score'] as int? ?? 0;
        activities.add(ActivityEntity(
          id: analysis['id'] as String,
          userId: userId,
          type: ActivityType.cvAnalyzed,
          title: 'CV Analysis',
          subtitle: 'Score: $score/100',
          timestamp:
              DateTime.fromMillisecondsSinceEpoch(analysis['createdAt'] as int),
          relatedId: analysis['cvId'] as String?,
          metadata: {'score': score},
        ));
      }

      final interviews = await _dbHelper.query(
        DatabaseHelper.tableInterviews,
        where: 'userId = ?',
        whereArgs: [userId],
      );

      for (final interview in interviews) {
        final isCompleted = (interview['isCompleted'] as int? ?? 0) == 1;
        final status = isCompleted ? 'Completed' : 'Draft';
        String title = 'Interview Prep';
        try {
          final sessionData = jsonDecode(interview['sessionData'] as String);
          title = sessionData['jobPosition'] ?? 'Interview Prep';
        } catch (e) {
          // sessionData might be malformed or missing
        }

        activities.add(ActivityEntity(
          id: interview['id'] as String,
          userId: userId,
          type: ActivityType.interviewPrep,
          title: title,
          subtitle: status,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
              interview['createdAt'] as int),
          relatedId: interview['id'] as String,
          metadata: {'status': status},
        ));
      }

      final translations = await _dbHelper.query(
        DatabaseHelper.tableTranslations,
        where: 'userId = ?',
        whereArgs: [userId],
      );

      for (final translation in translations) {
        activities.add(ActivityEntity(
          id: translation['id'] as String,
          userId: userId,
          type: ActivityType.cvTranslated,
          title: 'CV to ATS',
          subtitle: 'Converted to ${translation['toLang'] ?? 'English'}',
          timestamp: DateTime.fromMillisecondsSinceEpoch(
              translation['createdAt'] as int),
          relatedId: translation['id'] as String,
          metadata: {
            'from': translation['fromLang'],
            'to': translation['toLang']
          },
        ));
      }

      activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      if (offset >= activities.length) return [];
      final end = (offset + limit < activities.length)
          ? offset + limit
          : activities.length;
      return activities.sublist(offset, end);
    } catch (e) {
      return [];
    }
  }

  Future<void> clearHistory(String userId) async {}
}
