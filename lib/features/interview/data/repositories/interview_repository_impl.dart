import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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

          final results = await Future.wait([
            _remoteDataSource.analyzeSTARStructure(
              question: question.text,
              transcript: transcript,
              jobContext: jobContext,
              language: language,
            ),
            _remoteDataSource.analyzeContentQuality(
              question: question.text,
              transcript: transcript,
              jobContext: jobContext,
              language: language,
            ),
            _remoteDataSource.analyzeFluency(
              transcript: transcript,
              audioDurationSeconds: duration,
              language: language,
            ),
            _remoteDataSource.analyzeConfidence(
              transcript: transcript,
              questionContext: question.text,
              language: language,
            ),
          ]);

          final starAnalysis = results[0] as STARAnalysis;
          final contentAnalysis = results[1] as ContentQualityAnalysis;
          final fluencyAnalysis = results[2] as FluencyAnalysis;
          final confidenceAnalysis = results[3] as ConfidenceAnalysis;

          final improvedSpeech = await _remoteDataSource.generateImprovedSpeech(
            transcript: transcript,
            detectedFillers: fluencyAnalysis.fillerWords,
            originalWpm: fluencyAnalysis.wpm,
            language: language,
          );

          return QuestionFeedback(
            questionId: question.id,
            starAnalysis: starAnalysis,
            contentAnalysis: contentAnalysis,
            fluencyAnalysis: fluencyAnalysis,
            confidenceAnalysis: confidenceAnalysis,
            improvedSpeech: improvedSpeech,
          );
        } catch (e) {
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
            ((totalStar + totalContent + totalFluency + totalConfidence) / 4)
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

      return InterviewReport(
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
    } catch (e) {
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
      await firestore
          .collection('users')
          .doc(interview.userId)
          .collection('interviews')
          .doc(interview.id)
          .set(interview.toJson());
    } catch (e) {
      // Firestore save failed silently - local data is still available
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
    await _localDataSource.deleteInterview(id);
  }
}
