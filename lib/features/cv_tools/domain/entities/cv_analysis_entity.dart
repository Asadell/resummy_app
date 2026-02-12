enum CvAnalysisWeakBulletPointPriority {
  high('High'),
  medium('Medium'),
  low('Low');

  final String value;
  const CvAnalysisWeakBulletPointPriority(this.value);
}

class CvAnalysisGradeThresholds {
  static const excellent = 85;
  static const good = 70;
  static const fair = 50;
  static const poor = 0;
}

class CvAnalysisMetrics {
  final int keywordMatch;
  final int quantifiableAchievements;
  final int structureCompleteness;
  final int languageProfessionalism;

  CvAnalysisMetrics({
    required this.keywordMatch,
    required this.quantifiableAchievements,
    required this.structureCompleteness,
    required this.languageProfessionalism,
  });
}

class CvAnalysisWeakBulletPoint {
  final String title;
  final CvAnalysisWeakBulletPointPriority priority;
  final String original;
  final String suggestion;

  CvAnalysisWeakBulletPoint({
    required this.title,
    required this.priority,
    required this.original,
    required this.suggestion,
  });
}

class CvAnalysisEntity {
  final int _overallScore;
  final CvAnalysisMetrics _metrics;
  final List<String> _missingKeywords;
  final List<CvAnalysisWeakBulletPoint> _weakBulletPoints;
  final String _summaryFeedback;

  CvAnalysisEntity({
    required int overallScore,
    required CvAnalysisMetrics metrics,
    required List<String> missingKeywords,
    required List<CvAnalysisWeakBulletPoint> weakBulletPoints,
    required String summaryFeedback,
  })  : _overallScore = overallScore,
        _metrics = metrics,
        _missingKeywords = missingKeywords,
        _weakBulletPoints = weakBulletPoints,
        _summaryFeedback = summaryFeedback;

  int get overallScore => _overallScore;
  CvAnalysisMetrics get metrics => _metrics;
  List<String> get missingKeywords => _missingKeywords;
  List<CvAnalysisWeakBulletPoint> get weakBulletPoints => _weakBulletPoints
    ..sort((a, b) {
      return a.priority.index.compareTo(b.priority.index);
    });
  String get summaryFeedback => _summaryFeedback;

  String get grade {
    if (_overallScore >= CvAnalysisGradeThresholds.excellent) {
      return "Excellent!";
    } else if (_overallScore >= CvAnalysisGradeThresholds.good) {
      return "Good!";
    } else if (_overallScore >= CvAnalysisGradeThresholds.fair) {
      return "Fair";
    } else {
      return "Poor";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'overallScore': _overallScore,
      'metrics': {
        'keywordMatch': _metrics.keywordMatch,
        'quantifiableAchievements': _metrics.quantifiableAchievements,
        'structureCompleteness': _metrics.structureCompleteness,
        'languageProfessionalism': _metrics.languageProfessionalism,
      },
      'missingKeywords': _missingKeywords,
      'weakBulletPoints': _weakBulletPoints
          .map((bp) => {
                'title': bp.title,
                'priority': bp.priority.value,
                'original': bp.original,
                'suggestion': bp.suggestion,
              })
          .toList(),
      'summaryFeedback': _summaryFeedback,
    };
  }
}
