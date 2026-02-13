import 'package:equatable/equatable.dart';

// ============================================================================
// Interview Report - Main Result Entity
// ============================================================================

class InterviewReport extends Equatable {
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

  @override
  List<Object?> get props => [
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
