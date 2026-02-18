import 'dart:convert';
import 'package:resummy_app/core/services/database_helper.dart';
import 'package:resummy_app/features/history/domain/entities/activity_entity.dart';
import 'package:flutter/foundation.dart';

/// Local data source for History aggregation
class HistoryLocalDataSource {
  final DatabaseHelper _dbHelper;

  HistoryLocalDataSource(this._dbHelper);

  /// Get aggregated history from CVs, Interviews, and Analysis tables
  /// Returns a sorted list of ActivityEntity (newest first)
  Future<List<ActivityEntity>> getActivities(String userId, {int limit = 20, int offset = 0}) async {
    try {
      final List<ActivityEntity> activities = [];

      // 1. Fetch CVs
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
          timestamp: DateTime.fromMillisecondsSinceEpoch(cv['createdAt'] as int),
          relatedId: cv['id'] as String,
          metadata: {'source': cv['source']},
        ));
      }

      // 2. Fetch Analysis History
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
          timestamp: DateTime.fromMillisecondsSinceEpoch(analysis['createdAt'] as int),
          relatedId: analysis['cvId'] as String?,
          metadata: {'score': score},
        ));
      }

      // 3. Fetch Interviews
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
        } catch(e) {
            // ignore
        }

        activities.add(ActivityEntity(
          id: interview['id'] as String,
          userId: userId,
          type: ActivityType.interviewPrep,
          title: title,
          subtitle: status,
          timestamp: DateTime.fromMillisecondsSinceEpoch(interview['createdAt'] as int),
          relatedId: interview['id'] as String,
          metadata: {'status': status},
        ));
      }
      
      // 4. Fetch Translations (ATS Conversions)
      final translations = await _dbHelper.query(
        DatabaseHelper.tableTranslations,
        where: 'userId = ?',
        whereArgs: [userId],
      );

      for (final translation in translations) {
        activities.add(ActivityEntity(
          id: translation['id'] as String,
          userId: userId,
          type: ActivityType.cvTranslated, // Treated as ATS Converter in UI
          title: 'CV to ATS', // Generic title as per user request
          subtitle: 'Converted to ${translation['toLang'] ?? 'English'}',
          timestamp: DateTime.fromMillisecondsSinceEpoch(translation['createdAt'] as int),
          relatedId: translation['id'] as String,
          metadata: {'from': translation['fromLang'], 'to': translation['toLang']},
        ));
      }

      // Sort by timestamp descending
      activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Apply pagination
      if (offset >= activities.length) return [];
      final end = (offset + limit < activities.length) ? offset + limit : activities.length;
      return activities.sublist(offset, end);

    } catch (e) {
      debugPrint('❌ Error aggregating history: $e');
      return [];
    }
  }

  Future<void> clearHistory(String userId) async {
    // This is tricky because we are reading from source of truth tables.
    // Deleting history effectively means deleting the CVs, Interviews, etc.
    // Maybe we shouldn't allow "Clear History" in this architecture unless it means
    // "Delete All Data".
    // For now, let's just implement it as "not supported" or leave empty to be safe.
    debugPrint('⚠️ Clear history requested but not implemented to prevent data loss.');
  }
}
