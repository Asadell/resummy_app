import 'package:equatable/equatable.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_question.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_report.dart';

/// Interview session entity
class InterviewEntity extends Equatable {
  final String id;
  final String userId;
  final String jobPosition;
  final String? jobDescription;
  final String? cvText;
  final List<InterviewQuestion> questions;
  final InterviewReport? report;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool isCompleted;

  const InterviewEntity({
    required this.id,
    required this.userId,
    required this.jobPosition,
    this.jobDescription,
    this.cvText,
    required this.questions,
    this.report,
    required this.createdAt,
    this.completedAt,
    this.isCompleted = false,
  });

  InterviewEntity copyWith({
    List<InterviewQuestion>? questions,
    InterviewReport? report,
    DateTime? completedAt,
    bool? isCompleted,
  }) {
    return InterviewEntity(
      id: id,
      userId: userId,
      jobPosition: jobPosition,
      jobDescription: jobDescription,
      cvText: cvText,
      questions: questions ?? this.questions,
      report: report ?? this.report,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'jobPosition': jobPosition,
      'jobDescription': jobDescription,
      'cvText': cvText,
      'questions': questions.map((q) => {
        'id': q.id,
        'text': q.text,
        'difficulty': q.difficulty,
        'starHint': q.starHint,
        'userAnswerTranscript': q.userAnswerTranscript,
        'audioPath': q.audioPath,
        'audioDurationSeconds': q.audioDurationSeconds,
      }).toList(),
      'report': report?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory InterviewEntity.fromJson(Map<String, dynamic> json) {
    return InterviewEntity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      jobPosition: json['jobPosition'] as String,
      jobDescription: json['jobDescription'] as String?,
      cvText: json['cvText'] as String?,
      questions: (json['questions'] as List? ?? [])
          .map((q) => InterviewQuestion(
                id: q['id'] as String,
                text: q['text'] as String,
                difficulty: q['difficulty'] as String,
                starHint: q['starHint'] as String?,
                userAnswerTranscript: q['userAnswerTranscript'] as String?,
                audioPath: q['audioPath'] as String?,
                audioDurationSeconds: q['audioDurationSeconds'] as int?,
              ))
          .toList(),
      report: json['report'] != null
          ? InterviewReport.fromJson(json['report'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        jobPosition,
        jobDescription,
        cvText,
        questions,
        report,
        createdAt,
        completedAt,
        isCompleted,
      ];
}
