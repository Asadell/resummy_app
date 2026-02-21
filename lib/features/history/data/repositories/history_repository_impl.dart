import 'package:resummy_app/features/cv_tools/domain/repositories/cv_analysis_repository.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_builder_repository.dart';
import 'package:resummy_app/features/history/domain/entities/activity_item.dart';
import 'package:resummy_app/features/history/domain/repositories/history_repository.dart';
import 'package:resummy_app/features/interview/domain/repositories/interview_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final CVBuilderRepository _cvRepository;
  final InterviewRepository _interviewRepository;
  final CVAnalysisRepository _cvAnalysisRepository;

  HistoryRepositoryImpl(
    this._cvRepository,
    this._interviewRepository,
    this._cvAnalysisRepository,
  );

  @override
  Future<List<ActivityItem>> getActivities(String userId) async {
    final cvsFuture = _cvRepository.getAllCVs();
    final interviewsFuture = _interviewRepository.getInterviewHistory(userId);
    final analysisFuture = _cvAnalysisRepository.getAnalysisHistory(userId);

    final results = await Future.wait([
      cvsFuture,
      interviewsFuture,
      analysisFuture,
    ]);

    final cvs = results[0] as List<dynamic>;
    final interviews = results[1] as List<dynamic>;
    final analyses = results[2] as List<dynamic>;

    final activities = <ActivityItem>[];

    for (final cv in cvs) {
      activities.add(CvActivityItem(cv));
    }

    for (final interview in interviews) {
      activities.add(InterviewActivityItem(interview));
    }

    for (final analysis in analyses) {
      activities.add(AnalysisActivityItem(analysis));
    }

    activities.sort((a, b) => b.date.compareTo(a.date));

    return activities;
  }
}
