import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:resummy_app/core/constants/app_constants.dart';

class GeminiPoolManager {
  late final List<GenerativeModel> _models;
  late final List<String> _apiKeys;
  int _currentIndex = 0;

  GeminiPoolManager() {
    _initialize();
    if (_models.isEmpty) {
      throw Exception(
          'No Gemini API keys configured. Please check your .env file.');
    }
    debugPrint('✅ GeminiPoolManager initialized with ${_models.length} models');
  }

  void _initialize() {
    final keys = [
      AppConstants.geminiApiKey,
      AppConstants.geminiApiKey2,
      AppConstants.geminiApiKey3,
      AppConstants.geminiApiKey4,
      AppConstants.geminiApiKey5,
      AppConstants.geminiApiKey6,
      AppConstants.geminiApiKey7,
      AppConstants.geminiApiKey8,
      AppConstants.geminiApiKey9,
      AppConstants.geminiApiKey10,
      AppConstants.geminiApiKey11,
      AppConstants.geminiApiKey12,
      AppConstants.geminiApiKey13,
      AppConstants.geminiApiKey14,
      AppConstants.geminiApiKey15,
      AppConstants.geminiApiKey16,
      AppConstants.geminiApiKey17,
      AppConstants.geminiApiKey18,
      AppConstants.geminiApiKey19,
      AppConstants.geminiApiKey20,
      AppConstants.geminiApiKey21,
      AppConstants.geminiApiKey22,
      AppConstants.geminiApiKey23,
      AppConstants.geminiApiKey24,
      AppConstants.geminiApiKey25,
      AppConstants.geminiApiKey26,
      AppConstants.geminiApiKey27,
      AppConstants.geminiApiKey28,
      AppConstants.geminiApiKey29,
      AppConstants.geminiApiKey30,
      AppConstants.geminiApiKey31,
      AppConstants.geminiApiKey32,
      AppConstants.geminiApiKey33,
      AppConstants.geminiApiKey34,
      AppConstants.geminiApiKey35,
      AppConstants.geminiApiKey36,
      AppConstants.geminiApiKey37,
      AppConstants.geminiApiKey38,
      AppConstants.geminiApiKey39,
      AppConstants.geminiApiKey40,
      AppConstants.geminiApiKey41,
      AppConstants.geminiApiKey42,
      AppConstants.geminiApiKey43,
      AppConstants.geminiApiKey44,
      AppConstants.geminiApiKey45,
      AppConstants.geminiApiKey46,
      AppConstants.geminiApiKey47,
      AppConstants.geminiApiKey48,
      AppConstants.geminiApiKey49,
      AppConstants.geminiApiKey50,
      AppConstants.geminiApiKey51,
    ];

    _models = [];
    _apiKeys = [];

    for (final key in keys) {
      if (key.isNotEmpty) {
        _apiKeys.add(key);
        _models.add(
          GenerativeModel(
            model: 'gemini-3-flash-preview',
            apiKey: key,
            generationConfig: GenerationConfig(
              responseMimeType: 'application/json',
            ),
          ),
        );
      }
    }
  }

  String getNextApiKey() {
    final key = _apiKeys[_currentIndex];
    _rotateModel();
    return key;
  }

  GenerativeModel getModel() {
    final model = _models[_currentIndex];
    _rotateModel();
    return model;
  }

  void _rotateModel() {
    if (_models.length > 1) {
      _currentIndex = (_currentIndex + 1) % _models.length;
      debugPrint('🔄 Rotated to model index: $_currentIndex');
    }
  }

  Future<T> executeWithRetry<T>({
    required Future<T> Function(GenerativeModel) task,
    T? fallback,
  }) async {
    int attempts = 0;

    final maxAttempts = _models.length * 2;
    final failedKeys = <int>[];

    while (attempts < maxAttempts) {
      try {
        final model = getModel();

        return await task(model).timeout(
          const Duration(seconds: 180),
          onTimeout: () => throw TimeoutException(
            'Gemini API request timed out after 3 minutes',
          ),
        );
      } catch (e) {
        attempts++;
        final errorMessage = e.toString().toLowerCase();

        if (errorMessage.contains('quota') ||
            errorMessage.contains('429') ||
            errorMessage.contains('resource_exhausted')) {
          failedKeys.add(_currentIndex);
          debugPrint(
              '⚠️ Model $_currentIndex quota exceeded. Trying next key...');
        } else {
          debugPrint('❌ Error with Model $_currentIndex: $e');
        }

        if (attempts >= maxAttempts) {
          if (failedKeys.length >= _models.length) {
            throw QuotaExceededException(
              'All ${_models.length} Gemini API keys have exceeded their quota. '
              'Please try again later.',
            );
          } else if (fallback != null) {
            debugPrint('⚠️ All retry attempts failed. Using fallback value.');
            return fallback;
          } else {
            rethrow;
          }
        }

        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    if (fallback != null) {
      return fallback;
    }
    throw Exception('Unexpected error in executeWithRetry');
  }

  int get modelCount => _models.length;

  int get currentIndex => _currentIndex;
}

class QuotaExceededException implements Exception {
  final String message;
  QuotaExceededException(this.message);

  @override
  String toString() => 'QuotaExceededException: $message';
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => 'TimeoutException: $message';
}
