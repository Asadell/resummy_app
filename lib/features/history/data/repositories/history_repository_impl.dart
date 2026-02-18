import 'package:resummy_app/features/cv_tools/domain/repositories/cv_builder_repository.dart';
import 'package:resummy_app/features/history/domain/entities/activity_item.dart';
import 'package:resummy_app/features/history/domain/repositories/history_repository.dart';
import 'package:resummy_app/features/interview/domain/repositories/interview_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final CVBuilderRepository _cvRepository;
  final InterviewRepository _interviewRepository;

  HistoryRepositoryImpl(this._cvRepository, this._interviewRepository);

  @override
  Future<List<ActivityItem>> getActivities(String userId) async {
    final cvsFuture = _cvRepository.getAllCVs();
    final interviewsFuture = _interviewRepository.getInterviewHistory(userId);

    final results = await Future.wait([cvsFuture, interviewsFuture]);

    final cvs = results[0] as List<dynamic>;
    final interviews = results[1] as List<dynamic>;

    final activities = <ActivityItem>[];

    for (final cv in cvs) {
      activities.add(CvActivityItem(cv));
    }

    for (final interview in interviews) {
      activities.add(InterviewActivityItem(interview));
    }

    activities.sort((a, b) => b.date.compareTo(a.date));

    return activities;
  }
}
