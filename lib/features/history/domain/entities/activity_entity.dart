import 'package:equatable/equatable.dart';

enum ActivityType {
  cvCreated,
  cvUpdated,
  cvAnalyzed,
  cvTranslated,
  interviewPrep,
  unknown,
}

class ActivityEntity extends Equatable {
  final String id;
  final String userId;
  final ActivityType type;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  final String? relatedId;

  const ActivityEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.metadata,
    this.relatedId,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        title,
        subtitle,
        timestamp,
        metadata,
        relatedId,
      ];
}
