import 'package:resummy_app/features/cv_tools/data/data_sources/cv_local_data_source.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_builder_repository.dart';

/// Implementation of CV Builder Repository using local data source
class CVBuilderRepositoryImpl implements CVBuilderRepository {
  final CVLocalDataSource _localDataSource;

  CVBuilderRepositoryImpl(this._localDataSource);

  @override
  Future<List<CVData>> getAllCVs() async {
    return await _localDataSource.getAllCVs();
  }

  @override
  Future<CVData?> getCVById(String id) async {
    return await _localDataSource.getCVById(id);
  }

  @override
  Future<void> saveCV(CVData cv) async {
    await _localDataSource.saveCV(cv);
  }

  @override
  Future<void> deleteCV(String id) async {
    await _localDataSource.deleteCV(id);
  }

  @override
  Future<void> clearAllCVs() async {
    await _localDataSource.clearAllCVs();
  }
}
