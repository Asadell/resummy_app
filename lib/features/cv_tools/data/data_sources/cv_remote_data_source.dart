import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:flutter/foundation.dart';

class CVRemoteDataSource {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'cvs';

  CVRemoteDataSource(this._firestore);

  Future<List<CVData>> getAllCVs(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return CVData.fromJson(_convertTimestamps(data));
      }).toList();
    } catch (e) {
      debugPrint('❌ Error getting CVs from Firestore: $e');
      throw Exception('Failed to load CVs from cloud storage');
    }
  }

  Future<CVData?> getCVById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collectionPath).doc(id).get();

      if (!docSnapshot.exists) return null;

      return CVData.fromJson(_convertTimestamps(docSnapshot.data()!));
    } catch (e) {
      debugPrint('❌ Error getting CV by ID from Firestore: $e');
      return null;
    }
  }

  Future<void> saveCV(CVData cv, String userId) async {
    try {
      final data = cv.toJson();
      data['userId'] = userId;
      
      // Convert string timestamps to Firestore Timestamps to satisfy security rules
      if (data['createdAt'] is String) {
        data['createdAt'] = Timestamp.fromDate(DateTime.parse(data['createdAt']));
      }
      data['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection(_collectionPath)
          .doc(cv.id)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('❌ Error saving CV to Firestore: $e');
      throw Exception('Failed to save CV to cloud storage');
    }
  }

  Future<void> deleteCV(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).delete();
    } catch (e) {
      debugPrint('❌ Error deleting CV from Firestore: $e');
      throw Exception('Failed to delete CV from cloud storage');
    }
  }


  Map<String, dynamic> _convertTimestamps(Map<String, dynamic> data) {
    final newData = Map<String, dynamic>.from(data);
    if (newData['createdAt'] is Timestamp) {
      newData['createdAt'] =
          (newData['createdAt'] as Timestamp).toDate().toIso8601String();
    }
    if (newData['updatedAt'] is Timestamp) {
      newData['updatedAt'] =
          (newData['updatedAt'] as Timestamp).toDate().toIso8601String();
    }
    return newData;
  }
}
