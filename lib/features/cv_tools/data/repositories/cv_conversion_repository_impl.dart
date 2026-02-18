import 'dart:io';
import 'package:resummy_app/features/cv_tools/data/data_sources/cv_conversion_remote_data_source.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/cv_local_data_source.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_conversion_repository.dart';

class CVConversionRepositoryImpl implements CVConversionRepository {
  final CVConversionRemoteDataSource _remoteDataSource;
  final CVLocalDataSource _localDataSource;

  CVConversionRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<CVData> convertFromFile(File file, {String? targetLanguage}) async {
    try {
      final cvData = await _remoteDataSource.convertFromFile(
        file,
        targetLanguage: targetLanguage,
      );

      return cvData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveConvertedCV(CVData cv, String userId) async {
    try {
      await _localDataSource.saveCV(cv, userId);
    } catch (e) {
      rethrow;
    }
  }
}
