import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:resummy_app/core/constants/app_constants.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_question.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart'; // Add this for InterviewFocus

/// Gemini Speech Service untuk Text-to-Speech dan Speech-to-Text
/// Menggunakan Gemini API dengan dedicated API keys per question
class GeminiSpeechService {
  // API Keys untuk setiap pertanyaan (index 0-4)
  static final List<String> _ttsKeys = [
    AppConstants.geminiApiKey4,  // Q1 TTS
    AppConstants.geminiApiKey6,  // Q2 TTS
    AppConstants.geminiApiKey8,  // Q3 TTS
    AppConstants.geminiApiKey10, // Q4 TTS
    AppConstants.geminiApiKey12, // Q5 TTS
  ];

  static final List<String> _sttKeys = [
    AppConstants.geminiApiKey5,  // Q1 STT
    AppConstants.geminiApiKey7,  // Q2 STT
    AppConstants.geminiApiKey9,  // Q3 STT
    AppConstants.geminiApiKey11, // Q4 STT
    AppConstants.geminiApiKey13, // Q5 STT
  ];

  /// Get TTS API key for specific question index (0-4)
  String getTtsApiKey(int questionIndex) {
    if (questionIndex < 0 || questionIndex >= _ttsKeys.length) {
      debugPrint('Invalid TTS index: $questionIndex, using first');
      return _ttsKeys[0];
    }
    return _ttsKeys[questionIndex];
  }

  /// Get STT API key for specific question index (0-4)
  String getSttApiKey(int questionIndex) {
    if (questionIndex < 0 || questionIndex >= _sttKeys.length) {
      debugPrint('Invalid STT index: $questionIndex, using first');
      return _sttKeys[0];
    }
    return _sttKeys[questionIndex];
  }

  /// Text-to-Speech: Convert text to audio file
  /// Returns File path to the generated .wav audio
  Future<File?> textToSpeech({
    required String text,
    required String apiKey,
    String voiceName = 'Kore',
  }) async {
    try {
      const baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
      const model = 'gemini-2.5-flash-preview-tts';
      final url = Uri.parse('$baseUrl/models/$model:generateContent');

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': text}
            ]
          }
        ],
        'generationConfig': {
          'responseModalities': ['AUDIO'],
          'speechConfig': {
            'voiceConfig': {
              'prebuiltVoiceConfig': {'voiceName': voiceName}
            }
          }
        },
        'model': model,
      };

      final response = await http.post(
        url,
        headers: {
          'x-goog-api-key': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final base64Audio =
            responseData['candidates'][0]['content']['parts'][0]['inlineData']
                ['data'];

        // Decode base64 to PCM bytes
        final pcmBytes = base64Decode(base64Audio);

        // Save to temporary file as WAV
        final tempDir = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final wavFile = File('${tempDir.path}/tts_$timestamp.wav');

        // Convert PCM to WAV format (24kHz, mono, 16-bit)
        final wavBytes = _pcmToWav(pcmBytes, 24000, 1, 16);
        await wavFile.writeAsBytes(wavBytes);

        debugPrint('TTS generated: ${wavFile.path}');
        return wavFile;
      } else {
        debugPrint('TTS API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('TTS Error: $e');
      return null;
    }
  }

  /// Generate Interview Questions based on CV and JD
  Future<List<InterviewQuestion>> generateQuestions(
    String cvText,
    String jdText,
    String role, {
    InterviewFocus focus = InterviewFocus.mixed,
    String language = 'id-ID',
  }) async {
    try {
      String focusInstructions = "";
      switch(focus) {
        case InterviewFocus.behavioral:
          focusInstructions = "Focus HEAVILY on behavioral questions using the STAR method (Situation, Task, Action, Result). Ask about past experiences, challenges, and leadership.";
          break;
        case InterviewFocus.technical:
          focusInstructions = "Focus HEAVILY on technical topics, coding standards, architecture, and technology-specific questions related to $role. Avoid generic behavioral questions.";
          break;
        case InterviewFocus.mixed:
          focusInstructions = "Provide a balanced mix of behavioral (STAR method) and technical topics.";
          break;
      }

      const baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
      const model = 'gemini-3-flash-preview';
      final url = Uri.parse('$baseUrl/models/$model:generateContent');
      final apiKey = AppConstants.geminiApiKey; // Use main key for text generation

      final prompt = '''
      You are an expert technical interviewer. 
      Generate 5 interview questions for a $role position.
      
      Focus: $focusInstructions
      
      Context:
      CV: $cvText
      Job Description: $jdText
      
      IMPORTANT: You MUST generate the questions in $language.
      
      Requirements:
      1. Questions should be highly relevant to the provided context and focus.
      2. Return exactly 5 questions.
      3. Use a professional and encouraging tone.
      ''';

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'response_mime_type': 'application/json',
          'response_schema': {
            'type': 'ARRAY',
            'items': {
              'type': 'OBJECT',
              'properties': {
                'id': {'type': 'STRING'},
                'text': {'type': 'STRING'},
                'difficulty': {'type': 'STRING'},
              },
              'required': ['id', 'text', 'difficulty'],
            }
          }
        },
      };

      debugPrint('Generating questions with model: $model');
      
      final response = await http.post(
        url,
        headers: {
          'x-goog-api-key': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('Gemini API Status: ${response.statusCode}');
      if (response.statusCode != 200) {
        debugPrint('Gemini API Error Body: ${response.body}');
        throw Exception('Gemini API Error: ${response.statusCode} - ${response.body}');
      }

      final responseData = jsonDecode(response.body);
      final candidates = responseData['candidates'] as List?;
      
      if (candidates != null && candidates.isNotEmpty) {
         final contentText = candidates[0]['content']['parts'][0]['text'] as String;
         debugPrint('Gemini Raw Content: $contentText');
         
         final List<dynamic> jsonList = jsonDecode(contentText);
         return jsonList.map((e) => InterviewQuestion(
           id: e['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
           text: e['text'] ?? '',
           difficulty: e['difficulty'] ?? 'Medium',
         )).toList();
      } else {
         final feedback = responseData['promptFeedback'];
         throw Exception('Gemini blocked response or no candidates: $feedback');
      }
    } catch (e) {
      debugPrint('Error generating questions: $e');
      rethrow;
    }
  }

  /// Speech-to-Text: Convert audio file to text
  /// Uses Gemini 3 Flash Preview with base64 encoded audio
  Future<String> speechToText({
    required File audioFile,
    required String apiKey,
  }) async {
    try {
      if (!await audioFile.exists()) {
        debugPrint('STT Error: File not found at ${audioFile.path}');
        return '';
      }

      const baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
      const model = 'gemini-3-flash-preview';
      final url = Uri.parse('$baseUrl/models/$model:generateContent');

      // Read audio file and encode to base64
      final audioBytes = await audioFile.readAsBytes();
      final base64Audio = base64Encode(audioBytes);

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': 'Transcribe this audio exactly as spoken. Do not add any other text.'},
              {
                'inlineData': {
                  'mimeType': 'audio/wav', // Assuming WAV format from recorder
                  'data': base64Audio
                }
              }
            ]
          }
        ],
      };

      final response = await http.post(
        url,
        headers: {
          'x-goog-api-key': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['candidates'] != null &&
            responseData['candidates'].isNotEmpty &&
            responseData['candidates'][0]['content'] != null &&
            responseData['candidates'][0]['content']['parts'] != null) {
          final text = responseData['candidates'][0]['content']['parts'][0]['text'];
          debugPrint('STT Result: $text');
          return text ?? '';
        }
        return '';
      } else {
        debugPrint('STT API Error: ${response.statusCode} - ${response.body}');
        return '';
      }
    } catch (e) {
      debugPrint('STT Error: $e');
      return '';
    }
  }

  /// Helper: Convert PCM bytes to WAV format
  /// Based on Context7 docs: PCM is 24kHz, mono, 16-bit
  Uint8List _pcmToWav(
    Uint8List pcmData,
    int sampleRate,
    int numChannels,
    int bitsPerSample,
  ) {
    final int byteRate = sampleRate * numChannels * (bitsPerSample ~/ 8);
    final int blockAlign = numChannels * (bitsPerSample ~/ 8);
    final int dataSize = pcmData.length;
    final int fileSize = 36 + dataSize;

    final header = BytesBuilder();

    // RIFF header
    header.add('RIFF'.codeUnits);
    header.add(_intToBytes(fileSize, 4));
    header.add('WAVE'.codeUnits);

    // fmt chunk
    header.add('fmt '.codeUnits);
    header.add(_intToBytes(16, 4)); // fmt chunk size
    header.add(_intToBytes(1, 2)); // PCM format
    header.add(_intToBytes(numChannels, 2));
    header.add(_intToBytes(sampleRate, 4));
    header.add(_intToBytes(byteRate, 4));
    header.add(_intToBytes(blockAlign, 2));
    header.add(_intToBytes(bitsPerSample, 2));

    // data chunk
    header.add('data'.codeUnits);
    header.add(_intToBytes(dataSize, 4));
    header.add(pcmData);

    return header.toBytes();
  }

  /// Helper: Convert int to little-endian bytes
  Uint8List _intToBytes(int value, int bytes) {
    final result = Uint8List(bytes);
    for (int i = 0; i < bytes; i++) {
      result[i] = (value >> (i * 8)) & 0xFF;
    }
    return result;
  }
}
