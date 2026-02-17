import 'package:equatable/equatable.dart';

// ============================================================================
// Interview Report - Main Result Entity
// ============================================================================

class InterviewReport extends Equatable {
  final String id;
  final DateTime createdAt;
  final int overallScore; // 0-10 (average of 4 categories)
  
  // 4 Category Average Scores
  final double starAverageScore;
  final double contentQualityAverageScore;
  final double fluencyAverageScore;
  final double confidenceAverageScore;
  
  final String overallFeedback;
  final List<String> strengths;
  final List<String> improvements;
  final List<QuestionFeedback> questionFeedbacks;

  const InterviewReport({
    required this.id,
    required this.createdAt,
    required this.overallScore,
    required this.starAverageScore,
    required this.contentQualityAverageScore,
    required this.fluencyAverageScore,
    required this.confidenceAverageScore,
    required this.overallFeedback,
    required this.strengths,
    required this.improvements,
    required this.questionFeedbacks,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'overallScore': overallScore,
      'starAverageScore': starAverageScore,
      'contentQualityAverageScore': contentQualityAverageScore,
      'fluencyAverageScore': fluencyAverageScore,
      'confidenceAverageScore': confidenceAverageScore,
      'overallFeedback': overallFeedback,
      'strengths': strengths,
      'improvements': improvements,
      'questionFeedbacks': questionFeedbacks.map((q) => q.toJson()).toList(),
    };
  }

  factory InterviewReport.fromJson(Map<String, dynamic> json) {
    return InterviewReport(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      overallScore: json['overallScore'] as int,
      starAverageScore: (json['starAverageScore'] as num).toDouble(),
      contentQualityAverageScore: (json['contentQualityAverageScore'] as num).toDouble(),
      fluencyAverageScore: (json['fluencyAverageScore'] as num).toDouble(),
      confidenceAverageScore: (json['confidenceAverageScore'] as num).toDouble(),
      overallFeedback: json['overallFeedback'] as String,
      strengths: List<String>.from(json['strengths'] as List),
      improvements: List<String>.from(json['improvements'] as List),
      questionFeedbacks: (json['questionFeedbacks'] as List)
          .map((q) => QuestionFeedback.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        createdAt,
        overallScore,
        starAverageScore,
        contentQualityAverageScore,
        fluencyAverageScore,
        confidenceAverageScore,
        overallFeedback,
        strengths,
        improvements,
        questionFeedbacks,
      ];
}

// ============================================================================
// Question Feedback - Per Question Analysis
// ============================================================================

class QuestionFeedback extends Equatable {
  final String questionId;
  
  // 5 Analysis Components (from 5 separate API calls)
  final STARAnalysis starAnalysis;
  final ContentQualityAnalysis contentAnalysis;
  final FluencyAnalysis fluencyAnalysis;
  final ConfidenceAnalysis confidenceAnalysis;
  final ImprovedSpeechData improvedSpeech;

  const QuestionFeedback({
    required this.questionId,
    required this.starAnalysis,
    required this.contentAnalysis,
    required this.fluencyAnalysis,
    required this.confidenceAnalysis,
    required this.improvedSpeech,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'starAnalysis': starAnalysis.toJson(),
      'contentAnalysis': contentAnalysis.toJson(),
      'fluencyAnalysis': fluencyAnalysis.toJson(),
      'confidenceAnalysis': confidenceAnalysis.toJson(),
      'improvedSpeech': improvedSpeech.toJson(),
    };
  }

  factory QuestionFeedback.fromJson(Map<String, dynamic> json) {
    return QuestionFeedback(
      questionId: json['questionId'] as String,
      starAnalysis: STARAnalysis.fromJson(json['starAnalysis'] as Map<String, dynamic>),
      contentAnalysis: ContentQualityAnalysis.fromJson(json['contentAnalysis'] as Map<String, dynamic>),
      fluencyAnalysis: FluencyAnalysis.fromJson(json['fluencyAnalysis'] as Map<String, dynamic>),
      confidenceAnalysis: ConfidenceAnalysis.fromJson(json['confidenceAnalysis'] as Map<String, dynamic>),
      improvedSpeech: ImprovedSpeechData.fromJson(json['improvedSpeech'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [
        questionId,
        starAnalysis,
        contentAnalysis,
        fluencyAnalysis,
        confidenceAnalysis,
        improvedSpeech,
      ];
}

// ============================================================================
// API Call #1: STAR Structure Analysis
// ============================================================================

class STARAnalysis extends Equatable {
  final int score; // 0-10
  final ComponentDetection situation;
  final ComponentDetection task;
  final ComponentDetection action;
  final ComponentDetection result;
  final String overallFeedback;
  final List<String> suggestions;

  const STARAnalysis({
    required this.score,
    required this.situation,
    required this.task,
    required this.action,
    required this.result,
    required this.overallFeedback,
    required this.suggestions,
  });

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'situation': situation.toJson(),
      'task': task.toJson(),
      'action': action.toJson(),
      'result': result.toJson(),
      'overallFeedback': overallFeedback,
      'suggestions': suggestions,
    };
  }

  factory STARAnalysis.fromJson(Map<String, dynamic> json) {
    return STARAnalysis(
      score: json['score'] as int,
      situation: ComponentDetection.fromJson(json['situation'] as Map<String, dynamic>),
      task: ComponentDetection.fromJson(json['task'] as Map<String, dynamic>),
      action: ComponentDetection.fromJson(json['action'] as Map<String, dynamic>),
      result: ComponentDetection.fromJson(json['result'] as Map<String, dynamic>),
      overallFeedback: json['overallFeedback'] as String,
      suggestions: List<String>.from(json['suggestions'] as List),
    );
  }

  @override
  List<Object?> get props => [score, situation, task, action, result, overallFeedback, suggestions];
}

class ComponentDetection extends Equatable {
  final bool present;
  final String excerpt;
  final String quality; // "weak", "good", "excellent"

  const ComponentDetection({
    required this.present,
    required this.excerpt,
    required this.quality,
  });

  Map<String, dynamic> toJson() {
    return {
      'present': present,
      'excerpt': excerpt,
      'quality': quality,
    };
  }

  factory ComponentDetection.fromJson(Map<String, dynamic> json) {
    return ComponentDetection(
      present: json['present'] as bool,
      excerpt: json['excerpt'] as String,
      quality: json['quality'] as String,
    );
  }

  @override
  List<Object?> get props => [present, excerpt, quality];
}

// ============================================================================
// API Call #2: Content Quality Analysis
// ============================================================================

class ContentQualityAnalysis extends Equatable {
  final int score; // 0-10 (overall content quality score)
  final int relevanceScore; // 0-10
  final int depthScore; // 0-10
  final int professionalImpact; // 0-10
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> suggestions;

  const ContentQualityAnalysis({
    required this.score,
    required this.relevanceScore,
    required this.depthScore,
    required this.professionalImpact,
    required this.strengths,
    required this.weaknesses,
    required this.suggestions,
  });

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'relevanceScore': relevanceScore,
      'depthScore': depthScore,
      'professionalImpact': professionalImpact,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'suggestions': suggestions,
    };
  }

  factory ContentQualityAnalysis.fromJson(Map<String, dynamic> json) {
    return ContentQualityAnalysis(
      score: json['score'] as int,
      relevanceScore: json['relevanceScore'] as int,
      depthScore: json['depthScore'] as int,
      professionalImpact: json['professionalImpact'] as int,
      strengths: List<String>.from(json['strengths'] as List),
      weaknesses: List<String>.from(json['weaknesses'] as List),
      suggestions: List<String>.from(json['suggestions'] as List),
    );
  }

  @override
  List<Object?> get props => [
        score,
        relevanceScore,
        depthScore,
        professionalImpact,
        strengths,
        weaknesses,
        suggestions,
      ];
}

// ============================================================================
// API Call #3: Fluency Analysis (Estimated from Transcript)
// ============================================================================

class FluencyAnalysis extends Equatable {
  final int score; // 0-10
  final int wordCount;
  final double wpm; // Words per minute
  final List<FillerWord> fillerWords;
  final double fillerPercentage;
  final String paceAssessment; // "too slow" | "good pace" | "too fast"
  final List<String> suggestions;

  const FluencyAnalysis({
    required this.score,
    required this.wordCount,
    required this.wpm,
    required this.fillerWords,
    required this.fillerPercentage,
    required this.paceAssessment,
    required this.suggestions,
  });

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'wordCount': wordCount,
      'wpm': wpm,
      'fillerWords': fillerWords.map((f) => f.toJson()).toList(),
      'fillerPercentage': fillerPercentage,
      'paceAssessment': paceAssessment,
      'suggestions': suggestions,
    };
  }

  factory FluencyAnalysis.fromJson(Map<String, dynamic> json) {
    return FluencyAnalysis(
      score: json['score'] as int,
      wordCount: json['wordCount'] as int,
      wpm: (json['wpm'] as num).toDouble(),
      fillerWords: (json['fillerWords'] as List)
          .map((f) => FillerWord.fromJson(f as Map<String, dynamic>))
          .toList(),
      fillerPercentage: (json['fillerPercentage'] as num).toDouble(),
      paceAssessment: json['paceAssessment'] as String,
      suggestions: List<String>.from(json['suggestions'] as List),
    );
  }

  @override
  List<Object?> get props => [
        score,
        wordCount,
        wpm,
        fillerWords,
        fillerPercentage,
        paceAssessment,
        suggestions,
      ];
}

class FillerWord extends Equatable {
  final String word;
  final int count;
  final double percentage;

  const FillerWord({
    required this.word,
    required this.count,
    required this.percentage,
  });

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'count': count,
      'percentage': percentage,
    };
  }

  factory FillerWord.fromJson(Map<String, dynamic> json) {
    return FillerWord(
      word: json['word'] as String,
      count: json['count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [word, count, percentage];
}

// ============================================================================
// API Call #4: Confidence Assessment
// ============================================================================

class ConfidenceAnalysis extends Equatable {
  final int score; // 0-10
  final String toneAssessment; // "positive", "neutral", "hesitant", "defensive"
  final String energyLevel; // "high", "medium", "low"
  final String convictionLevel; // "strong", "moderate", "weak"
  final List<String> strengthIndicators;
  final List<String> weaknessIndicators;
  final List<String> tips;

  const ConfidenceAnalysis({
    required this.score,
    required this.toneAssessment,
    required this.energyLevel,
    required this.convictionLevel,
    required this.strengthIndicators,
    required this.weaknessIndicators,
    required this.tips,
  });

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'toneAssessment': toneAssessment,
      'energyLevel': energyLevel,
      'convictionLevel': convictionLevel,
      'strengthIndicators': strengthIndicators,
      'weaknessIndicators': weaknessIndicators,
      'tips': tips,
    };
  }

  factory ConfidenceAnalysis.fromJson(Map<String, dynamic> json) {
    return ConfidenceAnalysis(
      score: json['score'] as int,
      toneAssessment: json['toneAssessment'] as String,
      energyLevel: json['energyLevel'] as String,
      convictionLevel: json['convictionLevel'] as String,
      strengthIndicators: List<String>.from(json['strengthIndicators'] as List),
      weaknessIndicators: List<String>.from(json['weaknessIndicators'] as List),
      tips: List<String>.from(json['tips'] as List),
    );
  }

  @override
  List<Object?> get props => [
        score,
        toneAssessment,
        energyLevel,
        convictionLevel,
        strengthIndicators,
        weaknessIndicators,
        tips,
      ];
}

// ============================================================================
// API Call #5: Improved Speech Generation
// ============================================================================

class ImprovedSpeechData extends Equatable {
  final String originalText;
  final String improvedText;
  final int fillerWordsRemoved;
  final List<String> keyChanges;
  final double wpmBefore;
  final double wpmAfter;

  const ImprovedSpeechData({
    required this.originalText,
    required this.improvedText,
    required this.fillerWordsRemoved,
    required this.keyChanges,
    required this.wpmBefore,
    required this.wpmAfter,
  });

  Map<String, dynamic> toJson() {
    return {
      'originalText': originalText,
      'improvedText': improvedText,
      'fillerWordsRemoved': fillerWordsRemoved,
      'keyChanges': keyChanges,
      'wpmBefore': wpmBefore,
      'wpmAfter': wpmAfter,
    };
  }

  factory ImprovedSpeechData.fromJson(Map<String, dynamic> json) {
    return ImprovedSpeechData(
      originalText: json['originalText'] as String,
      improvedText: json['improvedText'] as String,
      fillerWordsRemoved: json['fillerWordsRemoved'] as int,
      keyChanges: List<String>.from(json['keyChanges'] as List),
      wpmBefore: (json['wpmBefore'] as num).toDouble(),
      wpmAfter: (json['wpmAfter'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        originalText,
        improvedText,
        fillerWordsRemoved,
        keyChanges,
        wpmBefore,
        wpmAfter,
      ];
}
