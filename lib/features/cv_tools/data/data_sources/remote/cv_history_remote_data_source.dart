import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resummy_app/core/errors/exceptions.dart';
import 'package:resummy_app/features/cv_tools/data/models/cv_history_model.dart';

abstract class CvHistoryRemoteDataSource {
  Future<void> saveCvAnalysisHistory(CvHistoryModel history);
  Future<List<CvHistoryModel>> getCvAnalysisHistoryList(String userId);
  Future<void> deleteCvAnalysisHistory(String id);
}

class CvHistoryRemoteDataSourceImpl implements CvHistoryRemoteDataSource {
  final FirebaseFirestore _firestore;

  CvHistoryRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collectionName = 'cv_analysis_history';

  @override
  Future<void> saveCvAnalysisHistory(CvHistoryModel history) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(history.id)
          .set(history.toFirestore());
    } on FirebaseException catch (e) {
      throw ServerException('Failed to save CV analysis history: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error while saving history: $e');
    }
  }

  @override
  Future<List<CvHistoryModel>> getCvAnalysisHistoryList(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('analyzedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CvHistoryModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException('Failed to fetch CV analysis history: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error while fetching history: $e');
    }
  }

  @override
  Future<void> deleteCvAnalysisHistory(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();
    } on FirebaseException catch (e) {
      throw ServerException('Failed to delete CV analysis history: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error while deleting history: $e');
    }
  }
}
