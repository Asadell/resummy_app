import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:resummy_app/core/constants/app_constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_question.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_report.dart';

class GeminiInterviewService {
  final List<String> _apiKeys;
  int _currentKeyIndex = 0;
  
  GeminiInterviewService() : _apiKeys = [
    AppConstants.geminiApiKey,
    if (AppConstants.geminiApiKey2.isNotEmpty) AppConstants.geminiApiKey2,
    if (AppConstants.geminiApiKey3.isNotEmpty) AppConstants.geminiApiKey3,
  ];

  GenerativeModel _getModel() {
    final model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: _apiKeys[_currentKeyIndex],
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
      ),
    );
    _rotateKey();
    return model;
  }

  void _rotateKey() {
    if (_apiKeys.length > 1) {
      _currentKeyIndex = (_currentKeyIndex + 1) % _apiKeys.length;
      debugPrint('Rotating to API Key index: $_currentKeyIndex');
    }
  }

  Future<List<InterviewQuestion>> generateQuestions(
      String cvText, String jdText, String role, {String language = 'en'}) async {
    final langPrompt = language == 'id' ? 'Bahasa Indonesia' : 'English';
    final prompt = '''
    Role: $role
    CV: $cvText
    JD: $jdText
    
    Task: Generate 5 behavioral interview questions using the STAR method tailored to this candidate and job.
    Language: Respond in $langPrompt.
    
    Format: JSON list containing objects with 'id' (string), 'text' (string), 'difficulty' (string: Easy/Medium/Hard).
    Example: [{"id": "1", "text": "Tell me about a time...", "difficulty": "Medium"}]
    ''';

    return _retryWithKeyRotation(() async {
      final model = _getModel();
      final response = await model.generateContent([Content.text(prompt)]);
      
      if (response.text == null) throw Exception('Empty response from Gemini');
      
      final List<dynamic> jsonList = jsonDecode(response.text!);
      return jsonList.map((json) {
        return InterviewQuestion(
          id: json['id'].toString(),
          text: json['text'],
          difficulty: json['difficulty'],
        );
      }).toList();
    }, fallback: [
        const InterviewQuestion(id: '1', text: 'Tell me about a time you faced a challenge.', difficulty: 'Medium'),
        const InterviewQuestion(id: '2', text: 'Describe a project where you demonstrated leadership.', difficulty: 'Medium'),
        const InterviewQuestion(id: '3', text: 'How do you prioritize tasks under pressure?', difficulty: 'Medium'),
        const InterviewQuestion(id: '4', text: 'Give an example of a conflict you resolved at work.', difficulty: 'Medium'),
        const InterviewQuestion(id: '5', text: 'What is your greatest professional achievement?', difficulty: 'Medium'),
    ]);
  }

  // ========================================================================
  // API Call #1: STAR Structure Analysis
  // ========================================================================
  Future<STARAnalysis> analyzeSTARStructure({
    required String question,
    required String transcript,
    required String jobContext,
    String language = 'en',
  }) async {
    final langPrompt = language == 'id' ? 'Bahasa Indonesia' : 'English';
    final prompt = '''
You are an expert HR interviewer evaluating candidates using the STAR method.

Analyze this interview answer and detect each STAR component:

**Question:** $question
**Answer:** $transcript
**Job Context:** $jobContext

For each component (Situation, Task, Action, Result):
1. Determine if it's present (true/false)
2. Extract the relevant excerpt (exact quote from the answer)
3. Rate its quality: "weak", "good", or "excellent"
4. Provide specific suggestions if missing or weak

Calculate:
- Overall STAR score (0-10)
- Structural flow quality

Language: Respond entirely in $langPrompt.

Return JSON format:
{
  "score": 8,
  "situation": {"present": true, "excerpt": "...", "quality": "good"},
  "task": {"present": true, "excerpt": "...", "quality": "excellent"},
  "action": {"present": true, "excerpt": "...", "quality": "good"},
  "result": {"present": true, "excerpt": "...", "quality": "weak"},
  "overallFeedback": "...",
  "suggestions": ["...", "..."]
}
''';

    return _retryWithKeyRotation(() async {
      final model = _getModel();
      final response = await model.generateContent([Content.text(prompt)]);
      
      if (response.text == null) throw Exception('Empty STAR analysis response');
      final json = jsonDecode(response.text!);
      
      return STARAnalysis(
        score: json['score'] ?? 0,
        situation: ComponentDetection(
          present: json['situation']?['present'] ?? false,
          excerpt: json['situation']?['excerpt'] ?? '',
          quality: json['situation']?['quality'] ?? 'weak',
        ),
        task: ComponentDetection(
          present: json['task']?['present'] ?? false,
          excerpt: json['task']?['excerpt'] ?? '',
          quality: json['task']?['quality'] ?? 'weak',
        ),
        action: ComponentDetection(
          present: json['action']?['present'] ?? false,
          excerpt: json['action']?['excerpt'] ?? '',
          quality: json['action']?['quality'] ?? 'weak',
        ),
        result: ComponentDetection(
          present: json['result']?['present'] ?? false,
          excerpt: json['result']?['excerpt'] ?? '',
          quality: json['result']?['quality'] ?? 'weak',
        ),
        overallFeedback: json['overallFeedback'] ?? '',
        suggestions: List<String>.from(json['suggestions'] ?? []),
      );
    }, fallback: const STARAnalysis(
      score: 0,
      situation: ComponentDetection(present: false, excerpt: '', quality: 'weak'),
      task: ComponentDetection(present: false, excerpt: '', quality: 'weak'),
      action: ComponentDetection(present: false, excerpt: '', quality: 'weak'),
      result: ComponentDetection(present: false, excerpt: '', quality: 'weak'),
      overallFeedback: 'Analysis failed',
      suggestions: [],
    ));
  }

  // ========================================================================
  // API Call #2: Content Quality Analysis
  // ========================================================================
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

    return _retryWithKeyRotation(() async {
      final model = _getModel();
      final response = await model.generateContent([Content.text(prompt)]);
      
      if (response.text == null) throw Exception('Empty content quality response');
      final json = jsonDecode(response.text!);
      
      return ContentQualityAnalysis(
        score: json['score'] ?? 0,
        relevanceScore: json['relevanceScore'] ?? 0,
        depthScore: json['depthScore'] ?? 0,
        professionalImpact: json['professionalImpact'] ?? 0,
        strengths: List<String>.from(json['strengths'] ?? []),
        weaknesses: List<String>.from(json['weaknesses'] ?? []),
        suggestions: List<String>.from(json['suggestions'] ?? []),
      );
    }, fallback: const ContentQualityAnalysis(
      score: 0,
      relevanceScore: 0,
      depthScore: 0,
      professionalImpact: 0,
      strengths: [],
      weaknesses: [],
      suggestions: [],
    ));
  }

  // ========================================================================
  // API Call #3: Fluency Analysis (Estimated from Transcript)
  // ========================================================================
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
3. Detect filler words in ${language == 'id' ? 'Indonesian/English mix' : 'English'}: um, uh, eh, jadi, seperti, ya, soalnya, gitu, kayak, like, you know
4. Calculate filler percentage = (filler count / total words) × 100
5. Assess pace (ideal: 130-150 WPM): "too slow" if <120, "good pace" if 120-160, "too fast" if >160

Consider:
- Natural pauses vs awkward hesitations
- Consistency indicators

Calculate fluency score (0-10) based on:
- WPM in ideal range (+3 points)
- Low filler percentage <5% (+3 points)
- Good pace consistency (+4 points)

Language: Respond entirely in $langPrompt.

Return JSON:
{
  "score": 8,
  "wordCount": 150,
  "wpm": 142.5,
  "fillerWords": [
    {"word": "um", "count": 3, "percentage": 2.0},
    {"word": "like", "count": 2, "percentage": 1.33}
  ],
  "fillerPercentage": 3.33,
  "paceAssessment": "good pace",
  "suggestions": ["...", "..."]
}
''';

    return _retryWithKeyRotation(() async {
      final model = _getModel();
      final response = await model.generateContent([Content.text(prompt)]);
      
      if (response.text == null) throw Exception('Empty fluency analysis response');
      final json = jsonDecode(response.text!);
      
      return FluencyAnalysis(
        score: json['score'] ?? 0,
        wordCount: json['wordCount'] ?? 0,
        wpm: (json['wpm'] ?? 0).toDouble(),
        fillerWords: (json['fillerWords'] as List? ?? []).map((fw) {
          return FillerWord(
            word: fw['word'] ?? '',
            count: fw['count'] ?? 0,
            percentage: (fw['percentage'] ?? 0).toDouble(),
          );
        }).toList(),
        fillerPercentage: (json['fillerPercentage'] ?? 0).toDouble(),
        paceAssessment: json['paceAssessment'] ?? 'unknown',
        suggestions: List<String>.from(json['suggestions'] ?? []),
      );
    }, fallback: const FluencyAnalysis(
      score: 0,
      wordCount: 0,
      wpm: 0,
      fillerWords: [],
      fillerPercentage: 0,
      paceAssessment: 'unknown',
      suggestions: [],
    ));
  }

  // ========================================================================
  // API Call #4: Confidence Assessment
  // ========================================================================
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
1. **Tone & Energy**: positive, neutral, hesitant, or defensive?
2. **Conviction**: Do they sound confident in their achievements?
3. **Language strength**: Active vs passive voice usage
4. **Certainty**: Hedge words (maybe, probably, I think, kind of, mungkin, sepertinya)

Look for:
- Strong action verbs (led, implemented, achieved)
- First-person ownership ("I led" vs "we kind of")
- Definitive statements vs uncertain language
- Enthusiasm indicators

Calculate confidence score (0-10) based on:
- Strong tone and energy (+3 points)
- High conviction (+4 points)
- Minimal hedge words (+3 points)

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

    return _retryWithKeyRotation(() async {
      final model = _getModel();
      final response = await model.generateContent([Content.text(prompt)]);
      
      if (response.text == null) throw Exception('Empty confidence analysis response');
      final json = jsonDecode(response.text!);
      
      return ConfidenceAnalysis(
        score: json['score'] ?? 0,
        toneAssessment: json['toneAssessment'] ?? 'neutral',
        energyLevel: json['energyLevel'] ?? 'low',
        convictionLevel: json['convictionLevel'] ?? 'weak',
        strengthIndicators: List<String>.from(json['strengthIndicators'] ?? []),
        weaknessIndicators: List<String>.from(json['weaknessIndicators'] ?? []),
        tips: List<String>.from(json['tips'] ?? []),
      );
    }, fallback: const ConfidenceAnalysis(
      score: 0,
      toneAssessment: 'neutral',
      energyLevel: 'low',
      convictionLevel: 'weak',
      strengthIndicators: [],
      weaknessIndicators: [],
      tips: [],
    ));
  }

  // ========================================================================
  // API Call #5: Generate Improved Speech
  // ========================================================================
  Future<ImprovedSpeechData> generateImprovedSpeech({
    required String transcript,
    required List<FillerWord> detectedFillers,
    required double originalWpm,
    String language = 'en',
  }) async {
    final langPrompt = language == 'id' ? 'Bahasa Indonesia' : 'English';
    final fillersList = detectedFillers.map((f) => f.word).join(', ');
    
    final prompt = '''
Rewrite this interview answer by removing filler words and improving clarity while maintaining the original meaning and natural conversational tone.

**Original:** $transcript
**Detected Fillers:** $fillersList
**Original WPM:** $originalWpm

Guidelines:
- Remove ALL filler words (um, uh, jadi, seperti, ya, like, you know, etc.)
- Keep the same STAR structure if present
- Maintain natural flow and personality
- Don't add new information
- Keep the same examples and stories
- Ensure it sounds like spoken language (not too formal)

After improving, calculate the new WPM and count how many filler words were removed.

Language: Keep the answer in $langPrompt.

Return JSON:
{
  "originalText": "...",
  "improvedText": "...",
  "fillerWordsRemoved": 5,
  "keyChanges": ["Removed 'um' and 'uh'", "..."],
  "wpmBefore": 142.5,
  "wpmAfter": 155.0
}
''';

    return _retryWithKeyRotation(() async {
      final model = _getModel();
      final response = await model.generateContent([Content.text(prompt)]);
      
      if (response.text == null) throw Exception('Empty improved speech response');
      final json = jsonDecode(response.text!);
      
      return ImprovedSpeechData(
        originalText: json['originalText'] ?? transcript,
        improvedText: json['improvedText'] ?? transcript,
        fillerWordsRemoved: json['fillerWordsRemoved'] ?? 0,
        keyChanges: List<String>.from(json['keyChanges'] ?? []),
        wpmBefore: (json['wpmBefore'] ?? originalWpm).toDouble(),
        wpmAfter: (json['wpmAfter'] ?? originalWpm).toDouble(),
      );
    }, fallback: ImprovedSpeechData(
      originalText: transcript,
      improvedText: transcript,
      fillerWordsRemoved: 0,
      keyChanges: [],
      wpmBefore: originalWpm,
      wpmAfter: originalWpm,
    ));
  }

  // ========================================================================
  // Orchestrator: Analyze Complete Session
  // ========================================================================
  Future<InterviewReport> analyzeSession(
    List<InterviewQuestion> questions, 
    {String language = 'en'}
  ) async {
    final questionFeedbacks = <QuestionFeedback>[];
    
    // Process each question with 5 API calls
    for (final question in questions) {
      final transcript = question.userAnswerTranscript ?? '';
      final duration = question.audioDurationSeconds ?? 60;
      
      if (transcript.isEmpty) {
        // Skip questions without answers
        continue;
      }

      try {
        // API Call #1: STAR Analysis
        final starAnalysis = await analyzeSTARStructure(
          question: question.text,
          transcript: transcript,
          jobContext: 'Interview candidate assessment',
          language: language,
        );

        // API Call #2: Content Quality
        final contentAnalysis = await analyzeContentQuality(
          question: question.text,
          transcript: transcript,
          jobContext: 'Interview candidate assessment',
          language: language,
        );

        // API Call #3: Fluency Analysis
        final fluencyAnalysis = await analyzeFluency(
          transcript: transcript,
          audioDurationSeconds: duration,
          language: language,
        );

        // API Call #4: Confidence Assessment
        final confidenceAnalysis = await analyzeConfidence(
          transcript: transcript,
          questionContext: question.text,
          language: language,
        );

        // API Call #5: Generate Improved Speech
        final improvedSpeech = await generateImprovedSpeech(
          transcript: transcript,
          detectedFillers: fluencyAnalysis.fillerWords,
          originalWpm: fluencyAnalysis.wpm,
          language: language,
        );

        questionFeedbacks.add(QuestionFeedback(
          questionId: question.id,
          starAnalysis: starAnalysis,
          contentAnalysis: contentAnalysis,
          fluencyAnalysis: fluencyAnalysis,
          confidenceAnalysis: confidenceAnalysis,
          improvedSpeech: improvedSpeech,
        ));
      } catch (e) {
        debugPrint('Error analyzing question ${question.id}: $e');
        // Continue with other questions even if one fails
      }
    }

    // Calculate category averages
    if (questionFeedbacks.isEmpty) {
      return const InterviewReport(
        overallScore: 0,
        starAverageScore: 0,
        contentQualityAverageScore: 0,
        fluencyAverageScore: 0,
        confidenceAverageScore: 0,
        overallFeedback: 'No valid answers to analyze',
        strengths: [],
        improvements: [],
        questionFeedbacks: [],
      );
    }

    final starAvg = questionFeedbacks
        .map((q) => q.starAnalysis.score)
        .reduce((a, b) => a + b) / questionFeedbacks.length;
    
    final contentAvg = questionFeedbacks
        .map((q) => q.contentAnalysis.score)
        .reduce((a, b) => a + b) / questionFeedbacks.length;
    
    final fluencyAvg = questionFeedbacks
        .map((q) => q.fluencyAnalysis.score)
        .reduce((a, b) => a + b) / questionFeedbacks.length;
    
    final confidenceAvg = questionFeedbacks
        .map((q) => q.confidenceAnalysis.score)
        .reduce((a, b) => a + b) / questionFeedbacks.length;

    final overall = ((starAvg + contentAvg + fluencyAvg + confidenceAvg) / 4).round();

    // Aggregate strengths and improvements
    final allStrengths = <String>{};
    final allImprovements = <String>{};
    
    for (final qf in questionFeedbacks) {
      allStrengths.addAll(qf.contentAnalysis.strengths);
      allImprovements.addAll(qf.starAnalysis.suggestions);
      allImprovements.addAll(qf.contentAnalysis.suggestions);
      allImprovements.addAll(qf.fluencyAnalysis.suggestions);
      allImprovements.addAll(qf.confidenceAnalysis.tips);
    }

    return InterviewReport(
      overallScore: overall,
      starAverageScore: starAvg,
      contentQualityAverageScore: contentAvg,
      fluencyAverageScore: fluencyAvg,
      confidenceAverageScore: confidenceAvg,
      overallFeedback: 'Interview analysis complete with ${questionFeedbacks.length} questions analyzed.',
      strengths: allStrengths.take(5).toList(),
      improvements: allImprovements.take(5).toList(),
      questionFeedbacks: questionFeedbacks,
    );
  }

  Future<T> _retryWithKeyRotation<T>(Future<T> Function() action, {required T fallback}) async {
    int attempts = 0;
    while (attempts < _apiKeys.length) {
      try {
        return await action();
      } catch (e) {
        attempts++;
        debugPrint('Error with API Key $_currentKeyIndex: $e');
        if (attempts < _apiKeys.length) {
          _rotateKey();
        } else {
          debugPrint('All API keys failed. Using fallback.');
          return fallback;
        }
      }
    }
    return fallback;
  }
}

