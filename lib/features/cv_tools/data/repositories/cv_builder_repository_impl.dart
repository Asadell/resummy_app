import 'package:resummy_app/features/cv_tools/data/data_sources/cv_local_data_source.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/cv_remote_data_source.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_builder_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CVBuilderRepositoryImpl implements CVBuilderRepository {
  final CVLocalDataSource _localDataSource;
  final CVRemoteDataSource _remoteDataSource;
  final FirebaseAuth _auth;

  CVBuilderRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._auth,
  );

  String get _currentUserId => _auth.currentUser?.uid ?? 'anonymous';

  @override
  Future<List<CVData>> getAllCVs() async {
    try {
      final localCVs = await _localDataSource.getAllCVs(_currentUserId);

      if (_currentUserId != 'anonymous') {
        _syncFromRemote();
      }

      return localCVs;
    } catch (e) {
      return await _localDataSource.getAllCVs(_currentUserId);
    }
  }

  @override
  Future<CVData?> getCVById(String id) async {
    final localCV = await _localDataSource.getCVById(id);
    if (localCV != null) return localCV;

    return await _remoteDataSource.getCVById(id);
  }

  @override
  Future<void> saveCV(CVData cv) async {
    try {
      await _localDataSource.saveCV(cv, _currentUserId);

      if (_currentUserId != 'anonymous') {
        try {
          await _remoteDataSource.saveCV(cv, _currentUserId);
        } catch (e) {

          await _localDataSource.saveCV(cv, _currentUserId,
              syncStatus: 'pending');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteCV(String id) async {
    try {
      await _localDataSource.deleteCV(id);

      if (_currentUserId != 'anonymous') {
        try {
          await _remoteDataSource.deleteCV(id);
        } catch (e) {
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearAllCVs() async {
    await _localDataSource.clearAllCVs(_currentUserId);
  }

  Future<void> _syncFromRemote() async {
    try {
      final remoteCVs = await _remoteDataSource.getAllCVs(_currentUserId);
      for (final cv in remoteCVs) {
        await _localDataSource.saveCV(cv, _currentUserId);
      }
    } catch (e) {
    }
  }
}
