import 'package:resummy_app/features/interview/domain/entities/interview_entity.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_question.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_report.dart';
import 'dart:io';

/// Repository interface for Interview operations
abstract class InterviewRepository {
  /// Generate interview questions based on CV and JD
  Future<List<InterviewQuestion>> generateQuestions({
    required String cvText,
    required String jdText,
    required String role,
    String language = 'en',
  });

  /// Analyze STAR structure of an answer
  Future<STARAnalysis> analyzeSTARStructure({
    required String question,
    required String transcript,
    required String jobContext,
    String language = 'en',
  });

  /// Generate comprehensive interview feedback
  Future<InterviewReport> generateInterviewReport({
    required List<InterviewQuestion> questions,
    required String jobContext,
    String language = 'en',
  });

  /// Text-to-Speech conversion
  Future<File?> textToSpeech({
    required String text,
    String voiceName = 'Kore',
  });

  /// Speech-to-Text conversion
  Future<String> speechToText({
    required File audioFile,
  });

  /// Save interview session
  Future<void> saveInterview(InterviewEntity interview);

  /// Get interview history for user
  Future<List<InterviewEntity>> getInterviewHistory(String userId);

  /// Get specific interview by ID
  Future<InterviewEntity?> getInterviewById(String id);

  /// Delete interview
  Future<void> deleteInterview(String id);
}
