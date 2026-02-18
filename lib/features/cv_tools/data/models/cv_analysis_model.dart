import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis.dart';

/// Data model for CV Suggestion with JSON serialization
class CvSuggestionModel extends CvSuggestion {
  const CvSuggestionModel({
    required super.id,
    required super.sectionTitle,
    required super.priority,
    required super.category,
    required super.original,
    required super.suggestion,
    required super.reason,
    super.isDismissed,
    super.isApplied,
  });

  factory CvSuggestionModel.fromJson(Map<String, dynamic> json, int index) {
    final priorityStr = (json['priority'] as String? ?? 'medium').toLowerCase();
    final categoryStr = (json['category'] as String? ?? 'style').toLowerCase();

    final priority = switch (priorityStr) {
      'high' => SuggestionPriority.high,
      'low' => SuggestionPriority.low,
      _ => SuggestionPriority.medium,
    };

    final category = switch (categoryStr) {
      'measurable_result' => SuggestionCategory.measurableResult,
      'spelling_grammar' => SuggestionCategory.spellingGrammar,
      'bullet_points' => SuggestionCategory.bulletPoints,
      'keywords' => SuggestionCategory.keywords,
      'sections' => SuggestionCategory.sections,
      _ => SuggestionCategory.style,
    };

    return CvSuggestionModel(
      id: 'sug_$index',
      sectionTitle: json['section_title'] as String? ?? 'General',
      priority: priority,
      category: category,
      original: json['original'] as String? ?? '',
      suggestion: json['suggestion'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'section_title': sectionTitle,
      'priority': priority.name,
      'category': category.name,
      'original': original,
      'suggestion': suggestion,
      'reason': reason,
      'is_dismissed': isDismissed,
      'is_applied': isApplied,
    };
  }

  factory CvSuggestionModel.fromEntity(CvSuggestion entity) {
    return CvSuggestionModel(
      id: entity.id,
      sectionTitle: entity.sectionTitle,
      priority: entity.priority,
      category: entity.category,
      original: entity.original,
      suggestion: entity.suggestion,
      reason: entity.reason,
      isDismissed: entity.isDismissed,
      isApplied: entity.isApplied,
    );
  }
}

/// Data model for CV Score Metrics with JSON serialization
class CvScoreMetricsModel extends CvScoreMetrics {
  const CvScoreMetricsModel({
    required super.keywordMatch,
    required super.quantifiableAchievements,
    required super.structureCompleteness,
    required super.languageProfessionalism,
  });

  factory CvScoreMetricsModel.fromJson(Map<String, dynamic> json) {
    return CvScoreMetricsModel(
      keywordMatch: (json['keyword_match'] as num? ?? 0).toInt(),
      quantifiableAchievements:
          (json['quantifiable_achievements'] as num? ?? 0).toInt(),
      structureCompleteness:
          (json['structure_completeness'] as num? ?? 0).toInt(),
      languageProfessionalism:
          (json['language_professionalism'] as num? ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keyword_match': keywordMatch,
      'quantifiable_achievements': quantifiableAchievements,
      'structure_completeness': structureCompleteness,
      'language_professionalism': languageProfessionalism,
    };
  }
}

/// Data model for CV Analysis Result with JSON serialization
class CvAnalysisResultModel extends CvAnalysisResult {
  const CvAnalysisResultModel({
    required super.id,
    required super.createdAt,
    required super.overallScore,
    required super.metrics,
    required super.summaryFeedback,
    required super.highlights,
    required super.improvements,
    required super.missingKeywords,
    required super.suggestions,
    required super.jobPosition,
    super.jobDescription,
  });

  factory CvAnalysisResultModel.fromJson(
    Map<String, dynamic> json, {
    required String id,
    required DateTime createdAt,
    required String jobPosition,
    String? jobDescription,
  }) {
    final rawSugs = json['suggestions'] as List<dynamic>? ?? [];
    return CvAnalysisResultModel(
      id: id,
      createdAt: createdAt,
      overallScore: (json['overall_score'] as num? ?? 0).toInt(),
      metrics: CvScoreMetricsModel.fromJson(
          json['metrics'] as Map<String, dynamic>? ?? {}),
      summaryFeedback: json['summary_feedback'] as String? ?? '',
      highlights: List<String>.from(json['highlights'] as List? ?? []),
      improvements: List<String>.from(json['improvements'] as List? ?? []),
      missingKeywords:
          List<String>.from(json['missing_keywords'] as List? ?? []),
      suggestions: rawSugs
          .asMap()
          .entries
          .map((e) =>
              CvSuggestionModel.fromJson(e.value as Map<String, dynamic>, e.key))
          .toList(),
      jobPosition: jobPosition,
      jobDescription: jobDescription,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'overall_score': overallScore,
      'metrics': (metrics as CvScoreMetricsModel).toJson(),
      'summary_feedback': summaryFeedback,
      'highlights': highlights,
      'improvements': improvements,
      'missing_keywords': missingKeywords,
      'suggestions': suggestions
          .map((s) => (s as CvSuggestionModel).toJson())
          .toList(),
      'job_position': jobPosition,
      'job_description': jobDescription,
    };
  }

  factory CvAnalysisResultModel.fromEntity(CvAnalysisResult entity) {
    return CvAnalysisResultModel(
      id: entity.id,
      createdAt: entity.createdAt,
      overallScore: entity.overallScore,
      metrics: entity.metrics,
      summaryFeedback: entity.summaryFeedback,
      highlights: entity.highlights,
      improvements: entity.improvements,
      missingKeywords: entity.missingKeywords,
      suggestions: entity.suggestions,
      jobPosition: entity.jobPosition,
      jobDescription: entity.jobDescription,
    );
  }
}
