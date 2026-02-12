import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis_entity.dart';

abstract class CvRepository {
  /// Analyze CV content against job position
  /// 
  /// Returns [CvAnalysisEntity] if successful
  /// Throws [ServerException] if API fails
  /// Throws [ConnectionException] if no internet
  /// Throws [ParsingException] if response parsing fails
  Future<CvAnalysisEntity> analyzeCv(
      String cvContent, String jobDescription, String language);
}
