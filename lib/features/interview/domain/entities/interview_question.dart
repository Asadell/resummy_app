import 'package:equatable/equatable.dart';

class InterviewQuestion extends Equatable {
  final String id;
  final String text;
  final String difficulty;
  final String? starHint;
  final String? userAnswerTranscript;
  final String? audioPath;
  final int? audioDurationSeconds;

  const InterviewQuestion({
    required this.id,
    required this.text,
    required this.difficulty,
    this.starHint,
    this.userAnswerTranscript,
    this.audioPath,
    this.audioDurationSeconds,
  });

  InterviewQuestion copyWith({
    String? id,
    String? text,
    String? difficulty,
    String? starHint,
    String? userAnswerTranscript,
    String? audioPath,
    int? audioDurationSeconds,
  }) {
    return InterviewQuestion(
      id: id ?? this.id,
      text: text ?? this.text,
      difficulty: difficulty ?? this.difficulty,
      starHint: starHint ?? this.starHint,
      userAnswerTranscript: userAnswerTranscript ?? this.userAnswerTranscript,
      audioPath: audioPath ?? this.audioPath,
      audioDurationSeconds: audioDurationSeconds ?? this.audioDurationSeconds,
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        difficulty,
        starHint,
        userAnswerTranscript,
        audioPath,
        audioDurationSeconds
      ];
}
