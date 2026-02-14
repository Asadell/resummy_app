import 'package:resummy_app/core/errors/exceptions.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/remote/cv_history_remote_data_source.dart';
import 'package:resummy_app/features/cv_tools/data/models/cv_history_model.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_history_entity.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_history_repository.dart';

class CvHistoryRepositoryImpl implements CvHistoryRepository {
  final CvHistoryRemoteDataSource _remoteDataSource;

  CvHistoryRepositoryImpl({
    required CvHistoryRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<void> saveCvAnalysisHistory(CvAnalysisHistory history) async {
    try {
      final model = CvHistoryModel.fromEntity(history);
      await _remoteDataSource.saveCvAnalysisHistory(model);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to save CV analysis history: $e');
    }
  }

  @override
  Future<List<CvAnalysisHistory>> getCvAnalysisHistoryList(String userId) async {
    try {
      final models = await _remoteDataSource.getCvAnalysisHistoryList(userId);
      return models;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch CV analysis history: $e');
    }
  }

  @override
  Future<void> deleteCvAnalysisHistory(String id) async {
    try {
      await _remoteDataSource.deleteCvAnalysisHistory(id);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete CV analysis history: $e');
    }
  }
}
