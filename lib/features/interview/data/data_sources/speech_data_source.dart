import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:resummy_app/core/services/gemini_pool_manager.dart';

class SpeechDataSource {
  final GeminiPoolManager _geminiPool;

  SpeechDataSource(this._geminiPool);

  Future<File?> textToSpeech({
    required String text,
    String voiceName = 'Kore',
  }) async {
    try {
      const baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
      const model = 'gemini-2.5-flash-preview-tts';
      final url = Uri.parse('$baseUrl/models/$model:generateContent');

      final apiKey = _geminiPool.getNextApiKey();

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
        final base64Audio = responseData['candidates'][0]['content']['parts'][0]
            ['inlineData']['data'];

        final pcmBytes = base64Decode(base64Audio);

        final tempDir = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final wavFile = File('${tempDir.path}/tts_$timestamp.wav');

        final wavBytes = _pcmToWav(pcmBytes, 24000, 1, 16);
        await wavFile.writeAsBytes(wavBytes);

        return wavFile;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> speechToText({
    required File audioFile,
  }) async {
    try {
      if (!await audioFile.exists()) {
        return '';
      }

      const baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
      const model = 'gemini-3-flash-preview';
      final url = Uri.parse('$baseUrl/models/$model:generateContent');

      final apiKey = _geminiPool.getNextApiKey();

      final audioBytes = await audioFile.readAsBytes();
      final base64Audio = base64Encode(audioBytes);

      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text':
                    'Transcribe this audio exactly as spoken. Do not add any other text.'
              },
              {
                'inlineData': {'mimeType': 'audio/wav', 'data': base64Audio}
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
          final text =
              responseData['candidates'][0]['content']['parts'][0]['text'];
          return text ?? '';
        }
        return '';
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

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

    header.add('RIFF'.codeUnits);
    header.add(_intToBytes(fileSize, 4));
    header.add('WAVE'.codeUnits);

    header.add('fmt '.codeUnits);
    header.add(_intToBytes(16, 4));
    header.add(_intToBytes(1, 2));
    header.add(_intToBytes(numChannels, 2));
    header.add(_intToBytes(sampleRate, 4));
    header.add(_intToBytes(byteRate, 4));
    header.add(_intToBytes(blockAlign, 2));
    header.add(_intToBytes(bitsPerSample, 2));

    header.add('data'.codeUnits);
    header.add(_intToBytes(dataSize, 4));
    header.add(pcmData);

    return header.toBytes();
  }

  Uint8List _intToBytes(int value, int bytes) {
    final result = Uint8List(bytes);
    for (int i = 0; i < bytes; i++) {
      result[i] = (value >> (i * 8)) & 0xFF;
    }
    return result;
  }
}
