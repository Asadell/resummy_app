import 'dart:convert';
import 'package:resummy_app/core/services/database_helper.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_entity.dart';
import 'package:flutter/foundation.dart';

class InterviewLocalDataSource {
  final DatabaseHelper _dbHelper;

  InterviewLocalDataSource(this._dbHelper);

  Future<void> saveInterview(InterviewEntity interview) async {
    try {
      final data = {
        'id': interview.id,
        'userId': interview.userId,
        'jobPosition': interview.jobPosition,
        'data': jsonEncode(interview.toJson()),
        'createdAt': interview.createdAt.millisecondsSinceEpoch,
        'completedAt': interview.completedAt?.millisecondsSinceEpoch,
        'isCompleted': interview.isCompleted ? 1 : 0,
        'syncStatus': 'synced',
      };

      await _dbHelper.upsert(DatabaseHelper.tableInterviews, data);
      debugPrint('✅ Interview saved to local DB: ${interview.id}');
    } catch (e) {
      debugPrint('❌ Error saving interview: $e');
      rethrow;
    }
  }

  Future<List<InterviewEntity>> getInterviewHistory(String userId) async {
    try {
      final maps = await _dbHelper.query(
        DatabaseHelper.tableInterviews,
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'createdAt DESC',
      );

      return maps.map((map) {
        final data = jsonDecode(map['data'] as String) as Map<String, dynamic>;
        return InterviewEntity.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('❌ Error getting interview history: $e');
      return [];
    }
  }

  Future<InterviewEntity?> getInterviewById(String id) async {
    try {
      final maps = await _dbHelper.query(
        DatabaseHelper.tableInterviews,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;

      final map = maps.first;
      final data = jsonDecode(map['data'] as String) as Map<String, dynamic>;

      return InterviewEntity.fromJson(data);
    } catch (e) {
      debugPrint('❌ Error getting interview by ID: $e');
      return null;
    }
  }

  Future<void> deleteInterview(String id) async {
    try {
      await _dbHelper.delete(
        DatabaseHelper.tableInterviews,
        where: 'id = ?',
        whereArgs: [id],
      );
      debugPrint('✅ Interview deleted: $id');
    } catch (e) {
      debugPrint('❌ Error deleting interview: $e');
      rethrow;
    }
  }
}
