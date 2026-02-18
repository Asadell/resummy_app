import 'package:equatable/equatable.dart';

enum SuggestionPriority { high, medium, low }

enum SuggestionCategory {
  measurableResult,
  spellingGrammar,
  bulletPoints,
  keywords,
  style,
  sections,
}

extension SuggestionCategoryLabel on SuggestionCategory {
  String get label {
    switch (this) {
      case SuggestionCategory.measurableResult:
        return 'Measurable Result';
      case SuggestionCategory.spellingGrammar:
        return 'Spelling & Grammar';
      case SuggestionCategory.bulletPoints:
        return 'Bullet Points';
      case SuggestionCategory.keywords:
        return 'Keywords';
      case SuggestionCategory.style:
        return 'Style';
      case SuggestionCategory.sections:
        return 'Sections';
    }
  }
}

class CvSuggestion extends Equatable {
  final String id;
  final String sectionTitle;
  final SuggestionPriority priority;
  final SuggestionCategory category;
  final String original;
  final String suggestion;
  final String reason;
  final bool isDismissed;
  final bool isApplied;

  const CvSuggestion({
    required this.id,
    required this.sectionTitle,
    required this.priority,
    required this.category,
    required this.original,
    required this.suggestion,
    required this.reason,
    this.isDismissed = false,
    this.isApplied = false,
  });

  CvSuggestion copyWith({
    bool? isDismissed,
    bool? isApplied,
  }) {
    return CvSuggestion(
      id: id,
      sectionTitle: sectionTitle,
      priority: priority,
      category: category,
      original: original,
      suggestion: suggestion,
      reason: reason,
      isDismissed: isDismissed ?? this.isDismissed,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  @override
  List<Object?> get props => [
        id,
        sectionTitle,
        priority,
        category,
        original,
        suggestion,
        reason,
        isDismissed,
        isApplied,
      ];
}

class CvScoreMetrics extends Equatable {
  final int keywordMatch;
  final int quantifiableAchievements;
  final int structureCompleteness;
  final int languageProfessionalism;

  const CvScoreMetrics({
    required this.keywordMatch,
    required this.quantifiableAchievements,
    required this.structureCompleteness,
    required this.languageProfessionalism,
  });

  @override
  List<Object?> get props => [
        keywordMatch,
        quantifiableAchievements,
        structureCompleteness,
        languageProfessionalism,
      ];
}

class CvAnalysisResult extends Equatable {
  final String id;
  final DateTime createdAt;
  final int overallScore;
  final CvScoreMetrics metrics;
  final String summaryFeedback;
  final List<String> highlights;
  final List<String> improvements;
  final List<String> missingKeywords;
  final List<CvSuggestion> suggestions;
  final String jobPosition;
  final String? jobDescription;

  const CvAnalysisResult({
    required this.id,
    required this.createdAt,
    required this.overallScore,
    required this.metrics,
    required this.summaryFeedback,
    required this.highlights,
    required this.improvements,
    required this.missingKeywords,
    required this.suggestions,
    required this.jobPosition,
    this.jobDescription,
  });

  String get grade {
    if (overallScore >= 85) return 'Excellent!';
    if (overallScore >= 70) return 'Good';
    if (overallScore >= 50) return 'Fair';
    return 'Needs Work';
  }

  int get pendingCount =>
      suggestions.where((s) => !s.isDismissed && !s.isApplied).length;
  int get appliedCount => suggestions.where((s) => s.isApplied).length;
  int get dismissedCount => suggestions.where((s) => s.isDismissed).length;

  CvAnalysisResult copyWith({
    List<CvSuggestion>? suggestions,
  }) {
    return CvAnalysisResult(
      id: id,
      createdAt: createdAt,
      overallScore: overallScore,
      metrics: metrics,
      summaryFeedback: summaryFeedback,
      highlights: highlights,
      improvements: improvements,
      missingKeywords: missingKeywords,
      suggestions: suggestions ?? this.suggestions,
      jobPosition: jobPosition,
      jobDescription: jobDescription,
    );
  }

  @override
  List<Object?> get props => [
        id,
        createdAt,
        overallScore,
        metrics,
        summaryFeedback,
        highlights,
        improvements,
        missingKeywords,
        suggestions,
        jobPosition,
        jobDescription,
      ];
}
