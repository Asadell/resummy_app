import 'dart:convert';
import 'package:resummy_app/core/services/database_helper.dart';
import 'package:resummy_app/features/cv_tools/data/models/cv_analysis_model.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis.dart';
import 'package:flutter/foundation.dart';

/// Local data source for CV Analysis results using SQLite
class CVAnalysisLocalDataSource {
  final DatabaseHelper _dbHelper;

  CVAnalysisLocalDataSource(this._dbHelper);

  /// Save analysis result to local database
  Future<void> saveAnalysisResult(CvAnalysisResult result, String userId) async {
    try {
      final model = CvAnalysisResultModel.fromEntity(result);
      final data = {
        'id': result.id,
        'userId': userId,
        'jobPosition': result.jobPosition,
        'overallScore': result.overallScore,
        'data': jsonEncode(model.toJson()),
        'createdAt': result.createdAt.millisecondsSinceEpoch,
        'syncStatus': 'synced',
      };

      await _dbHelper.upsert(DatabaseHelper.tableAnalysisHistory, data);
      debugPrint('✅ Analysis result saved to local DB: ${result.id}');
    } catch (e) {
      debugPrint('❌ Error saving analysis result: $e');
      rethrow;
    }
  }

  /// Get all analysis history for a user
  Future<List<CvAnalysisResult>> getAnalysisHistory(String userId) async {
    try {
      final maps = await _dbHelper.query(
        DatabaseHelper.tableAnalysisHistory,
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'createdAt DESC',
      );

      return maps.map((map) {
        final data = jsonDecode(map['data'] as String) as Map<String, dynamic>;
        return CvAnalysisResultModel.fromJson(
          data,
          id: map['id'] as String,
          createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
          jobPosition: map['jobPosition'] as String,
          jobDescription: data['job_description'] as String?,
        );
      }).toList();
    } catch (e) {
      debugPrint('❌ Error getting analysis history: $e');
      return [];
    }
  }

  /// Get specific analysis result by ID
  Future<CvAnalysisResult?> getAnalysisById(String id) async {
    try {
      final maps = await _dbHelper.query(
        DatabaseHelper.tableAnalysisHistory,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;

      final map = maps.first;
      final data = jsonDecode(map['data'] as String) as Map<String, dynamic>;
      
      return CvAnalysisResultModel.fromJson(
        data,
        id: map['id'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        jobPosition: map['jobPosition'] as String,
        jobDescription: data['job_description'] as String?,
      );
    } catch (e) {
      debugPrint('❌ Error getting analysis by ID: $e');
      return null;
    }
  }

  /// Delete analysis result
  Future<void> deleteAnalysis(String id) async {
    try {
      await _dbHelper.delete(
        DatabaseHelper.tableAnalysisHistory,
        where: 'id = ?',
        whereArgs: [id],
      );
      debugPrint('✅ Analysis deleted: $id');
    } catch (e) {
      debugPrint('❌ Error deleting analysis: $e');
      rethrow;
    }
  }
}
