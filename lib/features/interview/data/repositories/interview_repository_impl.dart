import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resummy_app/features/interview/data/data_sources/interview_local_data_source.dart';
import 'package:resummy_app/features/interview/data/data_sources/interview_remote_data_source.dart';
import 'package:resummy_app/features/interview/data/data_sources/speech_data_source.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_entity.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_question.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_report.dart';
import 'package:resummy_app/features/interview/domain/repositories/interview_repository.dart';

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
      final questionFeedbacks = <QuestionFeedback>[];
      int totalScore = 0;
      double totalStar = 0;
      double totalContent = 0;
      double totalFluency = 0;
      double totalConfidence = 0;

      final futures = questions
          .where((q) =>
              q.userAnswerTranscript != null &&
              q.userAnswerTranscript!.isNotEmpty)
          .map((question) async {
        try {
          final transcript = question.userAnswerTranscript!;
          final duration = question.audioDurationSeconds ?? 60;

          // Single combined request replaces 4 separate STAR/Content/Fluency/Confidence calls
          final comprehensive = await _remoteDataSource.analyzeComprehensivePerformance(
            question: question.text,
            transcript: transcript,
            jobContext: jobContext,
            audioDurationSeconds: duration,
            language: language,
          );

          final improvedSpeech = await _remoteDataSource.generateImprovedSpeech(
            transcript: transcript,
            detectedFillers: comprehensive.fluencyAnalysis.fillerWords,
            originalWpm: comprehensive.fluencyAnalysis.wpm,
            language: language,
          );

            return QuestionFeedback(
              questionId: question.id,
              userTranscript: transcript,
              starAnalysis: comprehensive.starAnalysis,
              contentAnalysis: comprehensive.contentAnalysis,
              fluencyAnalysis: comprehensive.fluencyAnalysis,
              confidenceAnalysis: comprehensive.confidenceAnalysis,
              improvedSpeech: improvedSpeech,
            );
          } catch (e) {
            debugPrint('Error analyzing question ${question.id}: $e');
            return null;
          }
        });

      final results = await Future.wait(futures);
      questionFeedbacks.addAll(results.whereType<QuestionFeedback>());

      if (questionFeedbacks.isNotEmpty) {
        totalStar = questionFeedbacks
                .map((q) => q.starAnalysis.score)
                .reduce((a, b) => a + b) /
            questionFeedbacks.length;
        totalContent = questionFeedbacks
                .map((q) => q.contentAnalysis.score)
                .reduce((a, b) => a + b) /
            questionFeedbacks.length;
        totalFluency = questionFeedbacks
                .map((q) => q.fluencyAnalysis.score)
                .reduce((a, b) => a + b) /
            questionFeedbacks.length;
        totalConfidence = questionFeedbacks
                .map((q) => q.confidenceAnalysis.score)
                .reduce((a, b) => a + b) /
            questionFeedbacks.length;

        totalScore =
            (((totalStar + totalContent + totalFluency + totalConfidence) / 4) *
                    10)
                .round();
      }

      final strengths = <String>{};
      final improvements = <String>{};
      for (final qf in questionFeedbacks) {
        strengths.addAll(qf.contentAnalysis.strengths);
        improvements.addAll(qf.starAnalysis.suggestions);
        improvements.addAll(qf.contentAnalysis.suggestions);
        improvements.addAll(qf.fluencyAnalysis.suggestions);
        improvements.addAll(qf.confidenceAnalysis.tips);
      }

      final finalReport = InterviewReport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        overallScore: totalScore,
        starAverageScore: totalStar,
        contentQualityAverageScore: totalContent,
        fluencyAverageScore: totalFluency,
        confidenceAverageScore: totalConfidence,
        overallFeedback:
            'Interview analysis complete for ${questionFeedbacks.length} questions.',
        strengths: strengths.take(5).toList(),
        improvements: improvements.take(5).toList(),
        questionFeedbacks: questionFeedbacks,
      );

      debugPrint('Generated Interview Report:');
      debugPrint('Overall Score: ${finalReport.overallScore}');
      debugPrint('Questions analyzed: ${questionFeedbacks.length}');
      debugPrint('Scores - Star: $totalStar, Content: $totalContent, Fluency: $totalFluency, Confidence: $totalConfidence');

      return finalReport;
    } catch (e) {
      debugPrint('Error in generateInterviewReport: $e');
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
    // Save locally first
    await _localDataSource.saveInterview(interview);

    // Also save to Firestore for cross-device access
    try {
      final firestore = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      
      // Basic validation
      if (interview.userId.isEmpty || interview.userId == 'anonymous') {
        debugPrint('Firestore save skipped: Invalid or anonymous userId (${interview.userId})');
        return;
      }

      if (currentUser == null) {
        debugPrint('Firestore save failed: No authenticated user found in FirebaseAuth.');
        return;
      }

      if (currentUser.uid != interview.userId) {
        debugPrint('Firestore save WARNING: Provided userId (${interview.userId}) does not match authenticated UID (${currentUser.uid})');
        // We will still try to save, but this is a likely cause of PERMISSION_DENIED if rules are strict.
      }

      debugPrint('Attempting to save interview to Firestore:');
      debugPrint('Path: users/${interview.userId}/interviews/${interview.id}');
      
      // Add a timeout to avoid hangs
      await firestore
          .collection('users')
          .doc(interview.userId)
          .collection('interviews')
          .doc(interview.id)
          .set(interview.toJson())
          .timeout(const Duration(seconds: 10));
      
      debugPrint('Successfully saved interview to Firestore.');
    } catch (e) {
      debugPrint('Firestore save failed for interview ${interview.id}: $e');
      if (e.toString().contains('permission-denied')) {
        final auth = FirebaseAuth.instance;
        debugPrint('Recommendation: Check Firestore Rules. Current Auth UID: ${auth.currentUser?.uid}');
        debugPrint('Ensure the rule allows writing to: users/${interview.userId}/interviews/${interview.id}');
      }
    }
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
    // Delete local
    await _localDataSource.deleteInterview(id);

    // Delete remote
    try {
      final auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('interviews')
            .doc(id)
            .delete();
      }
    } catch (e) {
      debugPrint('Error deleting remote interview: $e');
      // We don't rethrow here so local delete is considered "success" for UI
    }
  }
}
