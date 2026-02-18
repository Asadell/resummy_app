import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resummy_app/features/auth/domain/user_profile_model.dart';

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'users';

  UserProfileRepository([FirebaseFirestore? firestore]) 
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection(_collection).doc(uid).get();
      if (!doc.exists) return null;
      return UserProfile.fromFirestore(doc);
    } catch (e) {
      return null;
    }
  }

  Future<bool> createUserProfile(UserProfile profile) async {
    try {
      await _firestore.collection(_collection).doc(profile.uid).set({
        ...profile.toFirestore(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> completeOnboarding(String uid, {
    required String fullName,
    String? workStatus,
    String? targetRole,
    String? careerGoal,
  }) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'fullName': fullName,
        'workStatus': workStatus,
        'targetRole': targetRole,
        'careerGoal': careerGoal,
        'onboardingDone': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
