import 'package:equatable/equatable.dart';

/// Simplified Interview Feedback entity
class InterviewFeedback extends Equatable {
  final int overallScore;
  final List<String> strengths;
  final List<String> improvements;
  final List<QuestionFeedbackItem> questionFeedback;
  final int communicationScore;
  final String summary;

  const InterviewFeedback({
    required this.overallScore,
    required this.strengths,
    required this.improvements,
    required this.questionFeedback,
    required this.communicationScore,
    required this.summary,
  });

  factory InterviewFeedback.fromJson(Map<String, dynamic> json) {
    return InterviewFeedback(
      overallScore: (json['overallScore'] as num? ?? 0).toInt(),
      strengths: List<String>.from(json['strengths'] as List? ?? []),
      improvements: List<String>.from(json['improvements'] as List? ?? []),
      questionFeedback: (json['questionFeedback'] as List? ?? [])
          .map((e) => QuestionFeedbackItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      communicationScore: (json['communicationScore'] as num? ?? 0).toInt(),
      summary: json['summary'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overallScore': overallScore,
      'strengths': strengths,
      'improvements': improvements,
      'questionFeedback': questionFeedback.map((e) => e.toJson()).toList(),
      'communicationScore': communicationScore,
      'summary': summary,
    };
  }

  @override
  List<Object?> get props => [
        overallScore,
        strengths,
        improvements,
        questionFeedback,
        communicationScore,
        summary,
      ];
}

/// Individual question feedback
class QuestionFeedbackItem extends Equatable {
  final String questionId;
  final int score;
  final String feedback;
  final int starCompleteness;

  const QuestionFeedbackItem({
    required this.questionId,
    required this.score,
    required this.feedback,
    required this.starCompleteness,
  });

  factory QuestionFeedbackItem.fromJson(Map<String, dynamic> json) {
    return QuestionFeedbackItem(
      questionId: json['questionId'] as String? ?? '',
      score: (json['score'] as num? ?? 0).toInt(),
      feedback: json['feedback'] as String? ?? '',
      starCompleteness: (json['starCompleteness'] as num? ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'score': score,
      'feedback': feedback,
      'starCompleteness': starCompleteness,
    };
  }

  @override
  List<Object?> get props => [questionId, score, feedback, starCompleteness];
}
