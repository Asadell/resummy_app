import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:resummy_app/core/services/gemini_pool_manager.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_question.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_report.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_feedback_entity.dart';
import 'package:flutter/foundation.dart';

class InterviewRemoteDataSource {
  final GeminiPoolManager _geminiPool;

  InterviewRemoteDataSource(this._geminiPool);

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

  Future<ContentQualityAnalysis> analyzeContentQuality({
    required String question,
    required String transcript,
    required String jobContext,
    String language = 'en',
  }) async {
    final langPrompt = language == 'id' ? 'Bahasa Indonesia' : 'English';
    final prompt = '''
Evaluate the quality and relevance of this interview answer.

**Question:** $question
**Answer:** $transcript
**Job Context:** $jobContext

Assess:
1. **Relevance** (0-10): Does it answer the question directly?
2. **Depth** (0-10): Level of detail and specificity
3. **Professional Impact** (0-10): Would this impress an interviewer?

Analyze:
- Key strengths mentioned
- Missing elements
- Specificity of examples
- Use of metrics/numbers
- Demonstration of skills

Calculate overall content quality score (0-10) as average of the 3 sub-scores.

Language: Respond entirely in $langPrompt.

Return JSON:
{
  "score": 8,
  "relevanceScore": 9,
  "depthScore": 7,
  "professionalImpact": 8,
  "strengths": ["...", "..."],
  "weaknesses": ["...", "..."],
  "suggestions": ["...", "..."]
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
      final json = jsonDecode(responseText);

      return ContentQualityAnalysis(
        score: (json['score'] is int)
            ? json['score']
            : (json['score'] ?? 0).toInt(),
        relevanceScore: (json['relevanceScore'] is int)
            ? json['relevanceScore']
            : (json['relevanceScore'] ?? 0).toInt(),
        depthScore: (json['depthScore'] is int)
            ? json['depthScore']
            : (json['depthScore'] ?? 0).toInt(),
        professionalImpact: (json['professionalImpact'] is int)
            ? json['professionalImpact']
            : (json['professionalImpact'] ?? 0).toInt(),
        strengths: List<String>.from(json['strengths'] ?? []),
        weaknesses: List<String>.from(json['weaknesses'] ?? []),
        suggestions: List<String>.from(json['suggestions'] ?? []),
      );
    } catch (e) {
      debugPrint('❌ Error analyzing content quality: $e');
      return const ContentQualityAnalysis(
        score: 0,
        relevanceScore: 0,
        depthScore: 0,
        professionalImpact: 0,
        strengths: [],
        weaknesses: [],
        suggestions: [],
      );
    }
  }

  Future<FluencyAnalysis> analyzeFluency({
    required String transcript,
    required int audioDurationSeconds,
    String language = 'en',
  }) async {
    final langPrompt = language == 'id' ? 'Bahasa Indonesia' : 'English';
    final prompt = '''
Analyze speech fluency from this transcript.

**Transcript:** $transcript
**Duration:** $audioDurationSeconds seconds

Perform:
1. Count total words
2. Calculate WPM = (words / seconds) × 60
3. Detect filler words: um, uh, eh, jadi, seperti, ya, soalnya, gitu, kayak, like, you know
4. Calculate filler percentage = (filler count / total words) × 100
5. Assess pace (ideal: 130-150 WPM)

Calculate fluency score (0-10) based on WPM, low filler %, and pace.

Language: Respond entirely in $langPrompt.

Return JSON:
{
  "score": 8,
  "wordCount": 150,
  "wpm": 142.5,
  "fillerWords": [
    {"word": "um", "count": 3, "percentage": 2.0}
  ],
  "fillerPercentage": 3.33,
  "paceAssessment": "good pace",
  "suggestions": ["...", "..."]
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
      final json = jsonDecode(responseText);

      return FluencyAnalysis(
        score: (json['score'] is int)
            ? json['score']
            : (json['score'] ?? 0).toInt(),
        wordCount: (json['wordCount'] is int)
            ? json['wordCount']
            : (json['wordCount'] ?? 0).toInt(),
        wpm: (json['wpm'] ?? 0).toDouble(),
        fillerWords: (json['fillerWords'] as List? ?? []).map((fw) {
          return FillerWord(
            word: fw['word'] ?? '',
            count:
                (fw['count'] is int) ? fw['count'] : (fw['count'] ?? 0).toInt(),
            percentage: (fw['percentage'] ?? 0).toDouble(),
          );
        }).toList(),
        fillerPercentage: (json['fillerPercentage'] ?? 0).toDouble(),
        paceAssessment: json['paceAssessment'] ?? 'unknown',
        suggestions: List<String>.from(json['suggestions'] ?? []),
      );
    } catch (e) {
      debugPrint('❌ Error analyzing fluency: $e');
      return const FluencyAnalysis(
        score: 0,
        wordCount: 0,
        wpm: 0,
        fillerWords: [],
        fillerPercentage: 0,
        paceAssessment: 'unknown',
        suggestions: [],
      );
    }
  }

  Future<ConfidenceAnalysis> analyzeConfidence({
    required String transcript,
    required String questionContext,
    String language = 'en',
  }) async {
    final langPrompt = language == 'id' ? 'Bahasa Indonesia' : 'English';
    final prompt = '''
Evaluate the confidence and presence in this interview answer.

**Question Context:** $questionContext
**Transcript:** $transcript

Analyze:
1. **Tone & Energy**
2. **Conviction**
3. **Language strength**
4. **Certainty** (Hedge words)

Calculate confidence score (0-10).

Language: Respond entirely in $langPrompt.

Return JSON:
{
  "score": 7,
  "toneAssessment": "positive",
  "energyLevel": "medium",
  "convictionLevel": "strong",
  "strengthIndicators": ["...", "..."],
  "weaknessIndicators": ["...", "..."],
  "tips": ["...", "..."]
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
      final json = jsonDecode(responseText);

      return ConfidenceAnalysis(
        score: (json['score'] is int)
            ? json['score']
            : (json['score'] ?? 0).toInt(),
        toneAssessment: json['toneAssessment'] ?? 'neutral',
        energyLevel: json['energyLevel'] ?? 'low',
        convictionLevel: json['convictionLevel'] ?? 'weak',
        strengthIndicators: List<String>.from(json['strengthIndicators'] ?? []),
        weaknessIndicators: List<String>.from(json['weaknessIndicators'] ?? []),
        tips: List<String>.from(json['tips'] ?? []),
      );
    } catch (e) {
      debugPrint('❌ Error analyzing confidence: $e');
      return const ConfidenceAnalysis(
        score: 0,
        toneAssessment: 'neutral',
        energyLevel: 'low',
        convictionLevel: 'weak',
        strengthIndicators: [],
        weaknessIndicators: [],
        tips: [],
      );
    }
  }

  Future<ImprovedSpeechData> generateImprovedSpeech({
    required String transcript,
    required List<FillerWord> detectedFillers,
    required double originalWpm,
    String language = 'en',
  }) async {
    final langPrompt = language == 'id' ? 'Bahasa Indonesia' : 'English';
    final fillersList = detectedFillers.map((f) => f.word).join(', ');

    final prompt = '''
Rewrite this interview answer by removing filler words and improving clarity.

**Original:** $transcript
**Detected Fillers:** $fillersList
**Original WPM:** $originalWpm

Guidelines:
- Remove ALL filler words
- Maintain natural flow
- Don't add new information

Language: Keep the answer in $langPrompt.

Return JSON:
{
  "originalText": "...",
  "improvedText": "...",
  "fillerWordsRemoved": 5,
  "keyChanges": ["...", "..."],
  "wpmBefore": 142.5,
  "wpmAfter": 155.0
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
      final json = jsonDecode(responseText);

      return ImprovedSpeechData(
        originalText: json['originalText'] ?? transcript,
        improvedText: json['improvedText'] ?? transcript,
        fillerWordsRemoved: (json['fillerWordsRemoved'] is int)
            ? json['fillerWordsRemoved']
            : (json['fillerWordsRemoved'] ?? 0).toInt(),
        keyChanges: List<String>.from(json['keyChanges'] ?? []),
        wpmBefore: (json['wpmBefore'] ?? originalWpm).toDouble(),
        wpmAfter: (json['wpmAfter'] ?? originalWpm).toDouble(),
      );
    } catch (e) {
      debugPrint('❌ Error generating improved speech: $e');
      return ImprovedSpeechData(
        originalText: transcript,
        improvedText: transcript,
        fillerWordsRemoved: 0,
        keyChanges: [],
        wpmBefore: originalWpm,
        wpmAfter: originalWpm,
      );
    }
  }

  List<InterviewQuestion> _getFallbackQuestions() {
    return const [
      InterviewQuestion(
        id: '1',
        text: 'Tell me about a time you faced a challenge.',
        difficulty: 'Medium',
        starHint:
            'S: Describe the challenge. T: What was your responsibility? A: What steps did you take? R: What was the outcome?',
      ),
      InterviewQuestion(
        id: '2',
        text: 'Describe a project where you demonstrated leadership.',
        difficulty: 'Medium',
        starHint:
            'S: Context of the project. T: Your leadership role. A: How you led the team. R: Project success metrics.',
      ),
      InterviewQuestion(
        id: '3',
        text: 'How do you prioritize tasks under pressure?',
        difficulty: 'Medium',
        starHint:
            'S: A busy situation. T: Competing deadlines. A: Prioritization method used. R: All tasks completed on time.',
      ),
      InterviewQuestion(
        id: '4',
        text: 'Give an example of a conflict you resolved at work.',
        difficulty: 'Medium',
        starHint:
            'S: The conflict details. T: Goal to resolve it. A: Your communication strategy. R: Positive relationship restored.',
      ),
      InterviewQuestion(
        id: '5',
        text: 'What is your greatest professional achievement?',
        difficulty: 'Medium',
        starHint:
            'S: The opportunity/challenge. T: The goal you set. A: Your key actions. R: The quantifiable impact.',
      ),
    ];
  }
}
