import 'package:resummy_app/features/cv_tools/data/data_sources/cv_analysis_local_data_source.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/cv_analysis_remote_data_source.dart';
import 'package:resummy_app/features/cv_tools/data/services/cv_ats_converter_service.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_analysis_repository.dart';

class CVAnalysisRepositoryImpl implements CVAnalysisRepository {
  final CVAnalysisRemoteDataSource _remoteDataSource;
  final CVAnalysisLocalDataSource _localDataSource;
  final CvAtsConverterService _converterService;

  CVAnalysisRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._converterService,
  );

  @override
  Future<CvAnalysisResult> analyzeCV({
    required String cvText,
    required String jobPosition,
    String jobDescription = '',
    String language = 'id',
  }) async {
    try {
      final result = await _remoteDataSource.analyzeCV(
        cvText: cvText,
        jobPosition: jobPosition,
        jobDescription: jobDescription,
        language: language,
      );

      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CVData> applyAnalysisSuggestions({
    required String originalCvText,
    required List<CvSuggestion> appliedSuggestions,
    required String jobPosition,
  }) async {
    try {
      final cvJson = await _remoteDataSource.convertAppliedSuggestionsToCvJson(
        originalCvText: originalCvText,
        appliedSuggestions: appliedSuggestions,
        jobPosition: jobPosition,
      );

      final cvData = _converterService.parseCvJson(
        cvJson,
        source: 'analyzer',
      );

      return cvData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveAnalysisResult(
      CvAnalysisResult result, String userId) async {
    await _localDataSource.saveAnalysisResult(result, userId);
  }

  @override
  Future<List<CvAnalysisResult>> getAnalysisHistory(String userId) async {
    return await _localDataSource.getAnalysisHistory(userId);
  }

  @override
  Future<CvAnalysisResult?> getAnalysisById(String id) async {
    return await _localDataSource.getAnalysisById(id);
  }

  @override
  Future<void> deleteAnalysis(String id) async {
    await _localDataSource.deleteAnalysis(id);
  }
}
