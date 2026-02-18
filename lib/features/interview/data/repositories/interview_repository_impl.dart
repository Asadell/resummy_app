import 'dart:io';
import 'package:resummy_app/features/interview/data/data_sources/interview_local_data_source.dart';
import 'package:resummy_app/features/interview/data/data_sources/interview_remote_data_source.dart';
import 'package:resummy_app/features/interview/data/data_sources/speech_data_source.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_entity.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_question.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_report.dart';
import 'package:resummy_app/features/interview/domain/repositories/interview_repository.dart';
import 'package:flutter/foundation.dart';

/// Implementation of Interview Repository
class InterviewRepositoryImpl implements InterviewRepository {
  final InterviewRemoteDataSource _remoteDataSource;
  final InterviewLocalDataSource _localDataSource;
  final SpeechDataSource _speechDataSource;

  InterviewRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._speechDataSource,
  );

  @override
  Future<List<InterviewQuestion>> generateQuestions({
    required String cvText,
    required String jdText,
    required String role,
    String language = 'en',
  }) async {
    return await _remoteDataSource.generateQuestions(
      cvText: cvText,
      jdText: jdText,
      role: role,
      language: language,
    );
  }

  @override
  Future<STARAnalysis> analyzeSTARStructure({
    required String question,
    required String transcript,
    required String jobContext,
    String language = 'en',
  }) async {
    return await _remoteDataSource.analyzeSTARStructure(
      question: question,
      transcript: transcript,
      jobContext: jobContext,
      language: language,
    );
  }

  @override
  Future<InterviewReport> generateInterviewReport({
    required List<InterviewQuestion> questions,
    required String jobContext,
    String language = 'en',
  }) async {
    try {
      // For now, create a simplified report
      // The full report generation with all 5 API calls per question
      // would be implemented in the presentation layer or use case
      
      final questionFeedbacks = <QuestionFeedback>[];
      int totalScore = 0;

      for (final question in questions) {
        if (question.userAnswerTranscript != null) {
          final starAnalysis = await _remoteDataSource.analyzeSTARStructure(
            question: question.text,
            transcript: question.userAnswerTranscript!,
            jobContext: jobContext,
            language: language,
          );

          // Create simplified feedback with just STAR analysis
          // Other analyses (content, fluency, confidence, improved speech)
          // would be added here in full implementation
          final feedback = QuestionFeedback(
            questionId: question.id,
            starAnalysis: starAnalysis,
            contentAnalysis: const ContentQualityAnalysis(
              score: 0,
              relevanceScore: 0,
              depthScore: 0,
              professionalImpact: 0,
              strengths: [],
              weaknesses: [],
              suggestions: [],
            ),
            fluencyAnalysis: const FluencyAnalysis(
              score: 0,
              wordCount: 0,
              wpm: 0,
              fillerWords: [],
              fillerPercentage: 0,
              paceAssessment: '',
              suggestions: [],
            ),
            confidenceAnalysis: const ConfidenceAnalysis(
              score: 0,
              toneAssessment: '',
              energyLevel: '',
              convictionLevel: '',
              strengthIndicators: [],
              weaknessIndicators: [],
              tips: [],
            ),
            improvedSpeech: const ImprovedSpeechData(
              originalText: '',
              improvedText: '',
              fillerWordsRemoved: 0,
              keyChanges: [],
              wpmBefore: 0,
              wpmAfter: 0,
            ),
          );

          questionFeedbacks.add(feedback);
          totalScore += starAnalysis.score;
        }
      }

      final avgScore = questionFeedbacks.isNotEmpty
          ? (totalScore / questionFeedbacks.length).round()
          : 0;

      return InterviewReport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        overallScore: avgScore,
        starAverageScore: avgScore.toDouble(),
        contentQualityAverageScore: 0,
        fluencyAverageScore: 0,
        confidenceAverageScore: 0,
        overallFeedback: 'Interview completed successfully',
        strengths: [],
        improvements: [],
        questionFeedbacks: questionFeedbacks,
      );
    } catch (e) {
      debugPrint('❌ Error generating interview report: $e');
      rethrow;
    }
  }

  @override
  Future<File?> textToSpeech({
    required String text,
    String voiceName = 'Kore',
  }) async {
    return await _speechDataSource.textToSpeech(
      text: text,
      voiceName: voiceName,
    );
  }

  @override
  Future<String> speechToText({
    required File audioFile,
  }) async {
    return await _speechDataSource.speechToText(
      audioFile: audioFile,
    );
  }

  @override
  Future<void> saveInterview(InterviewEntity interview) async {
    await _localDataSource.saveInterview(interview);
  }

  @override
  Future<List<InterviewEntity>> getInterviewHistory(String userId) async {
    return await _localDataSource.getInterviewHistory(userId);
  }

  @override
  Future<InterviewEntity?> getInterviewById(String id) async {
    return await _localDataSource.getInterviewById(id);
  }

  @override
  Future<void> deleteInterview(String id) async {
    await _localDataSource.deleteInterview(id);
  }
}
