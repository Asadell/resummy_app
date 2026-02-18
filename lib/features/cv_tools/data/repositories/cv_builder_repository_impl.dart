import 'package:resummy_app/features/cv_tools/data/data_sources/cv_local_data_source.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/cv_remote_data_source.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_builder_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Robust implementation of CV Builder Repository with offline-first and sync logic
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
      // 1. Try to get from local first (fast UI update)
      final localCVs = await _localDataSource.getAllCVs(_currentUserId);
      
      // 2. Fetch from remote in background and sync if online
      if (_currentUserId != 'anonymous') {
        _syncFromRemote();
      }
      
      return localCVs;
    } catch (e) {
      debugPrint('❌ Error in getAllCVs: $e');
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
      // Always save locally first with 'pending' status if we want better offline handling
      // but for now let's just save locally as 'synced' by default and try remote
      await _localDataSource.saveCV(cv, _currentUserId);
      
      if (_currentUserId != 'anonymous') {
        try {
          await _remoteDataSource.saveCV(cv, _currentUserId);
        } catch (e) {
          debugPrint('⚠️ Failed to save to remote, marked for sync: $e');
          // Update status to 'pending' locally for later sync
          await _localDataSource.saveCV(cv, _currentUserId, syncStatus: 'pending');
        }
      }
    } catch (e) {
      debugPrint('❌ Error in saveCV: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteCV(String id) async {
    try {
      // 1. Delete locally
      await _localDataSource.deleteCV(id);
      
      // 2. Delete remotely
      if (_currentUserId != 'anonymous') {
        try {
          await _remoteDataSource.deleteCV(id);
        } catch (e) {
          debugPrint('⚠️ Failed to delete from remote: $e');
          // Should add to a "delete_sync_queue" in local DB
        }
      }
    } catch (e) {
      debugPrint('❌ Error in deleteCV: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearAllCVs() async {
    await _localDataSource.clearAllCVs(_currentUserId);
  }

  /// Background sync from remote to local
  Future<void> _syncFromRemote() async {
    try {
      final remoteCVs = await _remoteDataSource.getAllCVs(_currentUserId);
      for (final cv in remoteCVs) {
        await _localDataSource.saveCV(cv, _currentUserId);
      }
      debugPrint('✅ Synced ${remoteCVs.length} CVs from remote');
    } catch (e) {
      debugPrint('⚠️ Background sync failed: $e');
    }
  }
}
