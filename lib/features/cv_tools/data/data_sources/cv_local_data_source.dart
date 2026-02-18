import 'dart:convert';
import 'package:resummy_app/core/services/database_helper.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:flutter/foundation.dart';

/// Local data source for CV storage using SQLite via DatabaseHelper
class CVLocalDataSource {
  final DatabaseHelper _dbHelper;

  CVLocalDataSource(this._dbHelper);

  /// Get all saved CVs for a specific user
  Future<List<CVData>> getAllCVs(String userId) async {
    try {
      final List<Map<String, dynamic>> maps = await _dbHelper.query(
        DatabaseHelper.tableCVs,
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'updatedAt DESC',
      );

      return maps.map((map) {
        final Map<String, dynamic> data = jsonDecode(map['data'] as String);
        return CVData.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('❌ Error getting CVs from local DB: $e');
      throw Exception('Failed to load CVs from local storage');
    }
  }

  /// Get a specific CV by ID
  Future<CVData?> getCVById(String id) async {
    try {
      final List<Map<String, dynamic>> maps = await _dbHelper.query(
        DatabaseHelper.tableCVs,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;

      final Map<String, dynamic> data = jsonDecode(maps.first['data'] as String);
      return CVData.fromJson(data);
    } catch (e) {
      debugPrint('❌ Error getting CV by ID from local DB: $e');
      return null;
    }
  }

  /// Save a new CV or update existing one
  Future<void> saveCV(CVData cv, String userId, {String syncStatus = 'synced'}) async {
    try {
      final cvMap = {
        'id': cv.id,
        'userId': userId,
        'title': cv.header.name,
        'source': cv.source,
        'data': jsonEncode(cv.toJson()),
        'createdAt': cv.createdAt.millisecondsSinceEpoch,
        'updatedAt': cv.updatedAt.millisecondsSinceEpoch,
        'syncStatus': syncStatus,
      };

      await _dbHelper.upsert(DatabaseHelper.tableCVs, cvMap);
    } catch (e) {
      debugPrint('❌ Error saving CV to local DB: $e');
      throw Exception('Failed to save CV to local storage');
    }
  }

  /// Delete a CV by ID
  Future<void> deleteCV(String id) async {
    try {
      await _dbHelper.delete(
        DatabaseHelper.tableCVs,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('❌ Error deleting CV from local DB: $e');
      throw Exception('Failed to delete CV from local storage');
    }
  }

  /// Clear all CVs for a user
  Future<void> clearAllCVs(String userId) async {
    try {
      await _dbHelper.delete(
        DatabaseHelper.tableCVs,
        where: 'userId = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      debugPrint('❌ Error clearing CVs from local DB: $e');
      throw Exception('Failed to clear local CV storage');
    }
  }
}
