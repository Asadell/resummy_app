import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';

/// Repository interface for CV Analysis operations
abstract class CVAnalysisRepository {
  /// Analyze a CV against a job position
  Future<CvAnalysisResult> analyzeCV({
    required String cvText,
    required String jobPosition,
    String jobDescription = '',
    String language = 'id',
  });

  /// Convert applied suggestions to updated CVData
  Future<CVData> applyAnalysisSuggestions({
    required String originalCvText,
    required List<CvSuggestion> appliedSuggestions,
    required String jobPosition,
  });

  /// Save analysis result to local storage
  Future<void> saveAnalysisResult(CvAnalysisResult result, String userId);

  /// Get all analysis history for a user
  Future<List<CvAnalysisResult>> getAnalysisHistory(String userId);

  /// Get a specific analysis result by ID
  Future<CvAnalysisResult?> getAnalysisById(String id);

  /// Delete an analysis result
  Future<void> deleteAnalysis(String id);
}
