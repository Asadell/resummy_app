import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:flutter/foundation.dart';

/// Remote data source for CV storage using Firebase Firestore
class CVRemoteDataSource {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'cvs';

  CVRemoteDataSource(this._firestore);

  /// Get all CVs for a specific user from Firestore
  Future<List<CVData>> getAllCVs(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return CVData.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('❌ Error getting CVs from Firestore: $e');
      throw Exception('Failed to load CVs from cloud storage');
    }
  }

  /// Get a specific CV by ID from Firestore
  Future<CVData?> getCVById(String id) async {
    try {
      final docSnapshot = await _firestore
          .collection(_collectionPath)
          .doc(id)
          .get();

      if (!docSnapshot.exists) return null;

      return CVData.fromJson(docSnapshot.data()!);
    } catch (e) {
      debugPrint('❌ Error getting CV by ID from Firestore: $e');
      return null;
    }
  }

  /// Save or update a CV in Firestore
  Future<void> saveCV(CVData cv, String userId) async {
    try {
      final data = cv.toJson();
      data['userId'] = userId;
      
      await _firestore
          .collection(_collectionPath)
          .doc(cv.id)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('❌ Error saving CV to Firestore: $e');
      throw Exception('Failed to save CV to cloud storage');
    }
  }

  /// Delete a CV from Firestore
  Future<void> deleteCV(String id) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(id)
          .delete();
    } catch (e) {
      debugPrint('❌ Error deleting CV from Firestore: $e');
      throw Exception('Failed to delete CV from cloud storage');
    }
  }
}
