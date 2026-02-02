import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String fullName;
  final String email;
  final String? photoUrl;
  final String? workStatus;
  final String? targetRole;
  final String? careerGoal;
  final bool onboardingDone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.uid,
    required this.fullName,
    required this.email,
    this.photoUrl,
    this.workStatus,
    this.targetRole,
    this.careerGoal,
    this.onboardingDone = false,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      workStatus: data['workStatus'],
      targetRole: data['targetRole'],
      careerGoal: data['careerGoal'],
      onboardingDone: data['onboardingDone'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullName': fullName,
      'email': email,
      'photoUrl': photoUrl,
      'workStatus': workStatus,
      'targetRole': targetRole,
      'careerGoal': careerGoal,
      'onboardingDone': onboardingDone,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? photoUrl,
    String? workStatus,
    String? targetRole,
    String? careerGoal,
    bool? onboardingDone,
  }) {
    return UserProfile(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      workStatus: workStatus ?? this.workStatus,
      targetRole: targetRole ?? this.targetRole,
      careerGoal: careerGoal ?? this.careerGoal,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
