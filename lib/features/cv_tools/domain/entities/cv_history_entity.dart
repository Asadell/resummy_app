import 'package:equatable/equatable.dart';

class CvAnalysisHistory extends Equatable {
  final String id;
  final String userId;
  final String cvFileName;
  final int score;
  final String grade;
  final String summary;
  final DateTime analyzedAt;
  final String? positionTarget;
  final String language;
  
  // Full analysis data
  final Map<String, dynamic>? analysisData;

  const CvAnalysisHistory({
    required this.id,
    required this.userId,
    required this.cvFileName,
    required this.score,
    required this.grade,
    required this.summary,
    required this.analyzedAt,
    this.positionTarget,
    required this.language,
    this.analysisData,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        cvFileName,
        score,
        grade,
        summary,
        analyzedAt,
        positionTarget,
        language,
        analysisData,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'cvFileName': cvFileName,
      'score': score,
      'grade': grade,
      'summary': summary,
      'analyzedAt': analyzedAt.toIso8601String(),
      'positionTarget': positionTarget,
      'language': language,
      'analysisData': analysisData,
    };
  }

  factory CvAnalysisHistory.fromJson(Map<String, dynamic> json) {
    return CvAnalysisHistory(
      id: json['id'] as String,
      userId: json['userId'] as String,
      cvFileName: json['cvFileName'] as String,
      score: json['score'] as int,
      grade: json['grade'] as String,
      summary: json['summary'] as String,
      analyzedAt: DateTime.parse(json['analyzedAt'] as String),
      positionTarget: json['positionTarget'] as String?,
      language: json['language'] as String,
      analysisData: json['analysisData'] as Map<String, dynamic>?,
    );
  }
}
