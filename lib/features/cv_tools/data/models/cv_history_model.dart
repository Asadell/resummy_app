import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_history_entity.dart';

class CvHistoryModel extends CvAnalysisHistory {
  const CvHistoryModel({
    required super.id,
    required super.userId,
    required super.cvFileName,
    required super.score,
    required super.grade,
    required super.summary,
    required super.analyzedAt,
    super.positionTarget,
    required super.language,
    super.analysisData,
  });

  factory CvHistoryModel.fromEntity(CvAnalysisHistory entity) {
    return CvHistoryModel(
      id: entity.id,
      userId: entity.userId,
      cvFileName: entity.cvFileName,
      score: entity.score,
      grade: entity.grade,
      summary: entity.summary,
      analyzedAt: entity.analyzedAt,
      positionTarget: entity.positionTarget,
      language: entity.language,
      analysisData: entity.analysisData,
    );
  }

  factory CvHistoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CvHistoryModel(
      id: doc.id,
      userId: data['userId'] as String,
      cvFileName: data['cvFileName'] as String,
      score: data['score'] as int,
      grade: data['grade'] as String,
      summary: data['summary'] as String,
      analyzedAt: (data['analyzedAt'] as Timestamp).toDate(),
      positionTarget: data['positionTarget'] as String?,
      language: data['language'] as String,
      analysisData: data['analysisData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'cvFileName': cvFileName,
      'score': score,
      'grade': grade,
      'summary': summary,
      'analyzedAt': Timestamp.fromDate(analyzedAt),
      'positionTarget': positionTarget,
      'language': language,
      'analysisData': analysisData,
    };
  }
}
