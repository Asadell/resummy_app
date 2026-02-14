import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';

/// Local data source for CV storage using SharedPreferences
class CVLocalDataSource {
  static const String _kSavedCVsKey = 'saved_cvs';
  final SharedPreferences _prefs;

  CVLocalDataSource(this._prefs);

  /// Get all saved CVs
  Future<List<CVData>> getAllCVs() async {
    try {
      final String? cvsJson = _prefs.getString(_kSavedCVsKey);
      if (cvsJson == null || cvsJson.isEmpty) {
        return [];
      }

      final List<dynamic> cvsList = jsonDecode(cvsJson) as List<dynamic>;
      return cvsList
          .map((json) => CVData.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load CVs: $e');
    }
  }

  /// Get a specific CV by ID
  Future<CVData?> getCVById(String id) async {
    final cvs = await getAllCVs();
    try {
      return cvs.firstWhere((cv) => cv.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Save a new CV or update existing one
  Future<void> saveCV(CVData cv) async {
    try {
      final cvs = await getAllCVs();
      
      // Check if CV with this ID already exists
      final existingIndex = cvs.indexWhere((c) => c.id == cv.id);
      
      if (existingIndex != -1) {
        // Update existing CV
        cvs[existingIndex] = cv.copyWith(updatedAt: DateTime.now());
      } else {
        // Add new CV
        cvs.add(cv);
      }

      // Save to SharedPreferences
      final cvsJson = jsonEncode(cvs.map((c) => c.toJson()).toList());
      await _prefs.setString(_kSavedCVsKey, cvsJson);
    } catch (e) {
      throw Exception('Failed to save CV: $e');
    }
  }

  /// Delete a CV by ID
  Future<void> deleteCV(String id) async {
    try {
      final cvs = await getAllCVs();
      cvs.removeWhere((cv) => cv.id == id);

      final cvsJson = jsonEncode(cvs.map((c) => c.toJson()).toList());
      await _prefs.setString(_kSavedCVsKey, cvsJson);
    } catch (e) {
      throw Exception('Failed to delete CV: $e');
    }
  }

  /// Clear all CVs (for testing/debugging)
  Future<void> clearAllCVs() async {
    await _prefs.remove(_kSavedCVsKey);
  }
}
