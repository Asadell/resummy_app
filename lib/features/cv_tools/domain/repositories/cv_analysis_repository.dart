import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';

abstract class CVAnalysisRepository {
  Future<CvAnalysisResult> analyzeCV({
    required String cvText,
    required String jobPosition,
    String jobDescription = '',
    String language = 'id',
  });

  Future<CVData> applyAnalysisSuggestions({
    required String originalCvText,
    required List<CvSuggestion> appliedSuggestions,
    required String jobPosition,
  });

  Future<void> saveAnalysisResult(CvAnalysisResult result, String userId);

  Future<List<CvAnalysisResult>> getAnalysisHistory(String userId);

  Future<CvAnalysisResult?> getAnalysisById(String id);

  Future<void> deleteAnalysis(String id);
}
