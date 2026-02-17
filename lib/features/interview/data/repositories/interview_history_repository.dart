import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/interview_report.dart';

class InterviewHistoryRepository {
  static const String _kInterviewHistoryKey = 'interview_history';
  final SharedPreferences _prefs;

  InterviewHistoryRepository(this._prefs);

  Future<List<InterviewReport>> getInterviews() async {
    final String? jsonString = _prefs.getString(_kInterviewHistoryKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => InterviewReport.fromJson(json))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by newest description
    } catch (e) {
      debugPrint('Error parsing interview history: $e');
      return [];
    }
  }

  Future<void> saveInterview(InterviewReport report) async {
    final List<InterviewReport> current = await getInterviews();
    
    // Check if exists update, else add
    final index = current.indexWhere((r) => r.id == report.id);
    if (index >= 0) {
      current[index] = report;
    } else {
      current.add(report);
    }

    final jsonList = current.map((r) => r.toJson()).toList();
    await _prefs.setString(_kInterviewHistoryKey, jsonEncode(jsonList));
  }

  Future<void> deleteInterview(String id) async {
    final List<InterviewReport> current = await getInterviews();
    current.removeWhere((r) => r.id == id);
    final jsonList = current.map((r) => r.toJson()).toList();
    await _prefs.setString(_kInterviewHistoryKey, jsonEncode(jsonList));
  }
  
  Future<void> clearHistory() async {
    await _prefs.remove(_kInterviewHistoryKey);
  }
}
