import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:resummy_app/core/constants/app_constants.dart';

enum GeminiPoolType {
  cvAnalyzer,
  cvConverter,
  interview,
}

class GeminiPoolManager {
  final Map<GeminiPoolType, List<GenerativeModel>> _pools = {};
  final Map<GeminiPoolType, int> _indices = {};

  GeminiPoolManager() {
    _initialize();
    if (_pools.values.every((pool) => pool.isEmpty)) {
      throw Exception(
          'No Gemini API keys configured. Please check your .env file.');
    }
    debugPrint('✅ GeminiPoolManager initialized with 3 partitioned pools');
  }

  void _initialize() {
    final allKeys = [
      AppConstants.geminiApiKey, AppConstants.geminiApiKey2, AppConstants.geminiApiKey3,
      AppConstants.geminiApiKey4, AppConstants.geminiApiKey5, AppConstants.geminiApiKey6,
      AppConstants.geminiApiKey7, AppConstants.geminiApiKey8, AppConstants.geminiApiKey9,
      AppConstants.geminiApiKey10, AppConstants.geminiApiKey11, AppConstants.geminiApiKey12,
      AppConstants.geminiApiKey13, AppConstants.geminiApiKey14, AppConstants.geminiApiKey15,
      AppConstants.geminiApiKey16, AppConstants.geminiApiKey17, AppConstants.geminiApiKey18,
      AppConstants.geminiApiKey19, AppConstants.geminiApiKey20, AppConstants.geminiApiKey21,
      AppConstants.geminiApiKey22, AppConstants.geminiApiKey23, AppConstants.geminiApiKey24,
      AppConstants.geminiApiKey25, AppConstants.geminiApiKey26, AppConstants.geminiApiKey27,
      AppConstants.geminiApiKey28, AppConstants.geminiApiKey29, AppConstants.geminiApiKey30,
      AppConstants.geminiApiKey31, AppConstants.geminiApiKey32, AppConstants.geminiApiKey33,
      AppConstants.geminiApiKey34, AppConstants.geminiApiKey35, AppConstants.geminiApiKey36,
      AppConstants.geminiApiKey37, AppConstants.geminiApiKey38, AppConstants.geminiApiKey39,
      AppConstants.geminiApiKey40, AppConstants.geminiApiKey41, AppConstants.geminiApiKey42,
      AppConstants.geminiApiKey43, AppConstants.geminiApiKey44, AppConstants.geminiApiKey45,
      AppConstants.geminiApiKey46, AppConstants.geminiApiKey47, AppConstants.geminiApiKey48,
      AppConstants.geminiApiKey49, AppConstants.geminiApiKey50, AppConstants.geminiApiKey51,
    ];

    _fillPool(GeminiPoolType.cvAnalyzer, allKeys.sublist(0, 21));
    _fillPool(GeminiPoolType.cvConverter, allKeys.sublist(21, 36));
    _fillPool(GeminiPoolType.interview, allKeys.sublist(36, 51));
  }

  void _fillPool(GeminiPoolType type, List<String> keys) {
    _pools[type] = [];
    _indices[type] = 0;
    for (final key in keys) {
      if (key.isNotEmpty) {
        _pools[type]!.add(
          GenerativeModel(
            model: 'gemini-3-flash-preview',
            apiKey: key,
          ),
        );
      }
    }
    debugPrint('📦 Pool $type initialized with ${_pools[type]!.length} keys');
  }

  GenerativeModel _getModel(GeminiPoolType type) {
    final pool = _pools[type]!;
    if (pool.isEmpty) throw Exception('Pool $type is empty');
    
    final model = pool[_indices[type]!];
    _indices[type] = (_indices[type]! + 1) % pool.length;
    return model;
  }

  String getNextApiKey([GeminiPoolType type = GeminiPoolType.interview]) {
    final pool = _pools[type]!;
    if (pool.isEmpty) return '';
    final index = _indices[type]!;
    // Note: getModel already increments the index, but SpeechDataSource uses getNextApiKey 
    // and then calls its own logic. We'll just return the current key and increment.
    final key = [
      AppConstants.geminiApiKey, AppConstants.geminiApiKey2, AppConstants.geminiApiKey3,
      AppConstants.geminiApiKey4, AppConstants.geminiApiKey5, AppConstants.geminiApiKey6,
      AppConstants.geminiApiKey7, AppConstants.geminiApiKey8, AppConstants.geminiApiKey9,
      AppConstants.geminiApiKey10, AppConstants.geminiApiKey11, AppConstants.geminiApiKey12,
      AppConstants.geminiApiKey13, AppConstants.geminiApiKey14, AppConstants.geminiApiKey15,
      AppConstants.geminiApiKey16, AppConstants.geminiApiKey17, AppConstants.geminiApiKey18,
      AppConstants.geminiApiKey19, AppConstants.geminiApiKey20, AppConstants.geminiApiKey21,
      AppConstants.geminiApiKey22, AppConstants.geminiApiKey23, AppConstants.geminiApiKey24,
      AppConstants.geminiApiKey25, AppConstants.geminiApiKey26, AppConstants.geminiApiKey27,
      AppConstants.geminiApiKey28, AppConstants.geminiApiKey29, AppConstants.geminiApiKey30,
      AppConstants.geminiApiKey31, AppConstants.geminiApiKey32, AppConstants.geminiApiKey33,
      AppConstants.geminiApiKey34, AppConstants.geminiApiKey35, AppConstants.geminiApiKey36,
      AppConstants.geminiApiKey37, AppConstants.geminiApiKey38, AppConstants.geminiApiKey39,
      AppConstants.geminiApiKey40, AppConstants.geminiApiKey41, AppConstants.geminiApiKey42,
      AppConstants.geminiApiKey43, AppConstants.geminiApiKey44, AppConstants.geminiApiKey45,
      AppConstants.geminiApiKey46, AppConstants.geminiApiKey47, AppConstants.geminiApiKey48,
      AppConstants.geminiApiKey49, AppConstants.geminiApiKey50, AppConstants.geminiApiKey51,
    ];
    
    // We need to know the offset for the pool
    int offset = 0;
    if (type == GeminiPoolType.cvConverter) offset = 21;
    if (type == GeminiPoolType.interview) offset = 36;
    
    final selectedKey = key[offset + index];
    _indices[type] = (_indices[type]! + 1) % pool.length;
    return selectedKey;
  }

  Future<T> executeWithRetry<T>({
    required GeminiPoolType poolType,
    required Future<T> Function(GenerativeModel) task,
    GenerationConfig? generationConfig,
    List<SafetySetting>? safetySettings,
    T? fallback,
  }) async {
    final pool = _pools[poolType] ?? [];
    if (pool.isEmpty) {
      if (fallback != null) return fallback;
      throw Exception('Gemini Pool $poolType has no available keys');
    }

    int attempts = 0;
    final int maxAttempts = pool.length;

    while (attempts < maxAttempts) {
      final int index = _indices[poolType]!;
      final model = _getModel(poolType);
      attempts++;

      try {
        debugPrint('🚀 Requesting Gemini via $poolType pool (index $index, attempt $attempts/$maxAttempts)');
        
        return await task(model).timeout(
          const Duration(seconds: 120),
          onTimeout: () => throw TimeoutException('Request timed out'),
        );
      } catch (e) {
        final err = e.toString().toLowerCase();
        final isQuota = err.contains('quota') || 
                        err.contains('429') || 
                        err.contains('resource_exhausted') ||
                        err.contains('limit');

        if (isQuota && attempts < maxAttempts) {
          debugPrint('⚠️ Pool $poolType key $index quota exceeded. Failing over...');
          continue;
        }
        
        if (attempts >= maxAttempts && isQuota) {
          throw QuotaExceededException(
            'All $maxAttempts keys in $poolType pool have exceeded their quota.'
          );
        }

        if (attempts < maxAttempts) {
          debugPrint('❌ Pool $poolType error with key $index: $e. trying next...');
          continue;
        }

        if (fallback != null) return fallback;
        rethrow;
      }
    }

    if (fallback != null) return fallback;
    throw Exception('Unexpected end of retry loop for $poolType');
  }
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
