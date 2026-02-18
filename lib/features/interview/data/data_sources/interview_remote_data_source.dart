import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:resummy_app/core/services/gemini_pool_manager.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_question.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_report.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_feedback_entity.dart';
import 'package:flutter/foundation.dart';

/// Remote data source for Interview operations using Gemini AI
class InterviewRemoteDataSource {
  final GeminiPoolManager _geminiPool;

  InterviewRemoteDataSource(this._geminiPool);

  /// Generate interview questions based on CV and JD
  Future<List<InterviewQuestion>> generateQuestions({
    required String cvText,
    required String jdText,
    required String role,
    String language = 'en',
  }) async {
    final langPrompt = language == 'id' ? 'Bahasa Indonesia' : 'English';
    final prompt = '''
    Role: $role
    CV: $cvText
    JD: $jdText
    
    Task: Generate 5 behavioral interview questions using the STAR method tailored to this candidate and job.
    Also provide a brief "STAR Hint" for each question to guide the candidate (e.g., "Situation: Describe the context... Task: ...").
    
    Language: Respond in $langPrompt.
    
    Format: JSON list containing objects with 'id' (string), 'text' (string), 'difficulty' (string: Easy/Medium/Hard), 'starHint' (string).
    Example: [{"id": "1", "text": "Tell me about a time...", "difficulty": "Medium", "starHint": "S: Focus on..."}]
    ''';

    try {
      final response = await _geminiPool.executeWithRetry(
        task: (model) async {
          final content = [Content.text(prompt)];
          final result = await model.generateContent(
            content,
            generationConfig: GenerationConfig(
              responseMimeType: 'application/json',
            ),
          );
          return result;
        },
        fallback: _getFallbackQuestions(),
      );

      final responseText = (response as GenerateContentResponse).text;
      if (responseText == null) {
        debugPrint('⚠️ Empty response, using fallback questions');
        return _getFallbackQuestions();
      }

      final List<dynamic> jsonList = jsonDecode(responseText);
      return jsonList.map((json) {
        return InterviewQuestion(
          id: json['id'].toString(),
          text: json['text'],
          difficulty: json['difficulty'],
          starHint: json['starHint'],
        );
      }).toList();
    } catch (e) {
      debugPrint('❌ Error generating questions: $e');
      return _getFallbackQuestions();
    }
  }

  /// Analyze STAR structure of answer
  Future<STARAnalysis> analyzeSTARStructure({
    required String question,
    required String transcript,
    required String jobContext,
    String language = 'en',
  }) async {
    final langPrompt = language == 'id' ? 'Bahasa Indonesia' : 'English';
    final prompt = '''
You are an expert HR interviewer evaluating candidates using the STAR method.

Question: $question
Candidate's Answer: $transcript
Job Context: $jobContext

Analyze this answer and identify which STAR components are present:
- Situation: Did they describe the context/background?
- Task: Did they explain their responsibility/goal?
- Action: Did they detail the steps they took?
- Result: Did they share the outcome/impact?

Language: Respond in $langPrompt.

Return JSON:
{
  "hasSituation": true/false,
  "hasTask": true/false,
  "hasAction": true/false,
  "hasResult": true/false,
  "missingComponents": ["component1", "component2"],
  "overallCompleteness": 0-100
}
''';

    try {
      final response = await _geminiPool.executeWithRetry(
        task: (model) async {
          final content = [Content.text(prompt)];
          final result = await model.generateContent(
            content,
            generationConfig: GenerationConfig(
              responseMimeType: 'application/json',
            ),
          );
          return result;
        },
      );

      final responseText = response.text ?? '{}';
      final data = jsonDecode(responseText);
      return STARAnalysis.fromJson(data);
    } catch (e) {
      debugPrint('❌ Error analyzing STAR structure: $e');
      rethrow;
    }
  }

  /// Generate comprehensive interview feedback
  Future<InterviewFeedback> generateFeedback({
    required List<InterviewQuestion> questions,
    required String jobContext,
    String language = 'en',
  }) async {
    final langPrompt = language == 'id' ? 'Bahasa Indonesia' : 'English';
    
    final questionsText = questions.asMap().entries.map((e) {
      final i = e.key + 1;
      final q = e.value;
      return '''
Q$i: ${q.text}
Answer: ${q.userAnswerTranscript ?? '(No answer)'}
Duration: ${q.audioDurationSeconds ?? 0}s
''';
    }).join('\n');

    final prompt = '''
You are an expert interview coach providing comprehensive feedback.

Job Context: $jobContext
Language: Respond in $langPrompt.

Interview Questions and Answers:
$questionsText

Provide detailed feedback including:
1. Overall performance score (0-100)
2. Strengths (list of 3-5 points)
3. Areas for improvement (list of 3-5 points)
4. Specific recommendations for each answer
5. Communication quality assessment

Return JSON:
{
  "overallScore": 0-100,
  "strengths": ["strength1", "strength2"],
  "improvements": ["improvement1", "improvement2"],
  "questionFeedback": [
    {
      "questionId": "1",
      "score": 0-100,
      "feedback": "detailed feedback",
      "starCompleteness": 0-100
    }
  ],
  "communicationScore": 0-100,
  "summary": "overall summary"
}
''';

    try {
      final response = await _geminiPool.executeWithRetry(
        task: (model) async {
          final content = [Content.text(prompt)];
          final result = await model.generateContent(
            content,
            generationConfig: GenerationConfig(
              responseMimeType: 'application/json',
              maxOutputTokens: 8192,
            ),
          );
          return result;
        },
      );

      final responseText = response.text ?? '{}';
      final data = jsonDecode(responseText);
      return InterviewFeedback.fromJson(data);
    } catch (e) {
      debugPrint('❌ Error generating feedback: $e');
      rethrow;
    }
  }

  List<InterviewQuestion> _getFallbackQuestions() {
    return const [
      InterviewQuestion(
        id: '1',
        text: 'Tell me about a time you faced a challenge.',
        difficulty: 'Medium',
        starHint: 'S: Describe the challenge. T: What was your responsibility? A: What steps did you take? R: What was the outcome?',
      ),
      InterviewQuestion(
        id: '2',
        text: 'Describe a project where you demonstrated leadership.',
        difficulty: 'Medium',
        starHint: 'S: Context of the project. T: Your leadership role. A: How you led the team. R: Project success metrics.',
      ),
      InterviewQuestion(
        id: '3',
        text: 'How do you prioritize tasks under pressure?',
        difficulty: 'Medium',
        starHint: 'S: A busy situation. T: Competing deadlines. A: Prioritization method used. R: All tasks completed on time.',
      ),
      InterviewQuestion(
        id: '4',
        text: 'Give an example of a conflict you resolved at work.',
        difficulty: 'Medium',
        starHint: 'S: The conflict details. T: Goal to resolve it. A: Your communication strategy. R: Positive relationship restored.',
      ),
      InterviewQuestion(
        id: '5',
        text: 'What is your greatest professional achievement?',
        difficulty: 'Medium',
        starHint: 'S: The opportunity/challenge. T: The goal you set. A: Your key actions. R: The quantifiable impact.',
      ),
    ];
  }
}
