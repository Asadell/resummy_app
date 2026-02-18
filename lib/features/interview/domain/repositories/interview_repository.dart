import 'package:resummy_app/features/interview/domain/entities/interview_entity.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_question.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_report.dart';
import 'dart:io';

abstract class InterviewRepository {
  Future<List<InterviewQuestion>> generateQuestions({
    required String cvText,
    required String jdText,
    required String role,
    String language = 'en',
  });

  Future<STARAnalysis> analyzeSTARStructure({
    required String question,
    required String transcript,
    required String jobContext,
    String language = 'en',
  });

  Future<InterviewReport> generateInterviewReport({
    required List<InterviewQuestion> questions,
    required String jobContext,
    String language = 'en',
  });

  Future<File?> textToSpeech({
    required String text,
    String voiceName = 'Kore',
  });

  Future<String> speechToText({
    required File audioFile,
  });

  Future<void> saveInterview(InterviewEntity interview);

  Future<List<InterviewEntity>> getInterviewHistory(String userId);

  Future<InterviewEntity?> getInterviewById(String id);

  Future<void> deleteInterview(String id);
}
