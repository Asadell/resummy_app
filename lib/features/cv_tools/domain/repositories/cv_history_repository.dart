import 'package:resummy_app/features/cv_tools/domain/entities/cv_history_entity.dart';

abstract class CvHistoryRepository {
  /// Save CV analysis history to cloud storage
  /// 
  /// Returns void if successful
  /// Throws [ServerException] if save fails
  /// Throws [ConnectionException] if no internet
  Future<void> saveCvAnalysisHistory(CvAnalysisHistory history);

  /// Get list of CV analysis history for a user
  /// 
  /// Returns [List<CvAnalysisHistory>] if successful
  /// Throws [ServerException] if fetch fails
  /// Throws [ConnectionException] if no internet
  Future<List<CvAnalysisHistory>> getCvAnalysisHistoryList(String userId);

  /// Delete a specific CV analysis history
  /// 
  /// Returns void if successful
  /// Throws [ServerException] if delete fails
  /// Throws [ConnectionException] if no internet
  Future<void> deleteCvAnalysisHistory(String id);
}
