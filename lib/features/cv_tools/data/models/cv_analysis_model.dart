import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis_entity.dart';

class CvAnalysisModel extends CvAnalysisEntity {
  CvAnalysisModel({
    required super.overallScore,
    required super.metrics,
    required super.missingKeywords,
    required super.weakBulletPoints,
    required super.summaryFeedback,
  });

  factory CvAnalysisModel.fromJson(Map<String, dynamic> json) {
    return CvAnalysisModel(
      overallScore: json['overall_score'],
      metrics: CvAnalysisMetrics(
        keywordMatch: json['metrics']['keyword_match'],
        quantifiableAchievements: json['metrics']['quantifiable_achievements'],
        structureCompleteness: json['metrics']['structure_completeness'],
        languageProfessionalism: json['metrics']['language_professionalism'],
      ),
      missingKeywords: List<String>.from(json['missing_keywords']),
      weakBulletPoints: (json['weak_bullet_points'] as List)
          .map((e) => CvAnalysisWeakBulletPoint(
                title: e['title'],
                priority: CvAnalysisWeakBulletPointPriority.values
                    .firstWhere((p) => p.name == e['priority']),
                original: e['original'],
                suggestion: e['suggestion'],
              ))
          .toList(),
      summaryFeedback: json['summary_feedback'],
    );
  }

  factory CvAnalysisModel.fromEntity(CvAnalysisEntity entity) {
    return CvAnalysisModel(
      overallScore: entity.overallScore,
      metrics: entity.metrics,
      missingKeywords: entity.missingKeywords,
      weakBulletPoints: entity.weakBulletPoints,
      summaryFeedback: entity.summaryFeedback,
    );
  }
}
