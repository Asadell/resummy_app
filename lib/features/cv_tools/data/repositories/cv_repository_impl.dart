import 'package:dio/dio.dart';
import 'package:resummy_app/core/errors/exceptions.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/remote/cv_analysis_remote_data_source.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis_entity.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_repository.dart';

class CvRepositoryImpl implements CvRepository {
  final CvAnalysisRemoteDataSource _remoteDataSource;

  CvRepositoryImpl(this._remoteDataSource);

  @override
  Future<CvAnalysisEntity> analyzeCv(
    String cvContent,
    String positionTarget,
    String language,
  ) async {
    try {
      final result = await _remoteDataSource.analyze(
        cvText: cvContent,
        positionTarget: positionTarget,
        language: language,
      );

      return result;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw ConnectionException(
            "Connection timeout. Please check your internet connection.");
      } else if (e.type == DioExceptionType.badResponse) {
        throw ServerException(
            "Server error: ${e.response?.statusCode} ${e.response?.statusMessage}");
      }
      throw ServerException("Unexpected error occurred: ${e.message}");
    } on FormatException catch (e) {
      throw ParsingException("Failed to parse response: $e");
    } catch (e) {
      throw ServerException("Analyzing error: $e");
    }
  }
}
