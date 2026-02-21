import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_entity.dart';

sealed class ActivityItem {
  final DateTime date;

  ActivityItem(this.date);
}

class CvActivityItem extends ActivityItem {
  final CVData cvData;

  CvActivityItem(this.cvData) : super(cvData.updatedAt);
}

class InterviewActivityItem extends ActivityItem {
  final InterviewEntity interview;

  InterviewActivityItem(this.interview) : super(interview.createdAt);
}

class AnalysisActivityItem extends ActivityItem {
  final CvAnalysisResult result;

  AnalysisActivityItem(this.result) : super(result.createdAt);
}
