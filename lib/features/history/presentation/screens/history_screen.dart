import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/features/history/presentation/providers/history_provider.dart';
import 'package:resummy_app/features/history/domain/entities/activity_entity.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';
import 'package:intl/intl.dart';

@RoutePage()
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.history),
      ),
      body: SafeArea(
        child: Consumer<HistoryProvider>(
          builder: (context, provider, child) {
            final history = provider.activities;

            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (history.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.clock, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noInterviewHistory,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final activity = history[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getActivityColor(context, activity.type)
                          .withValues(alpha: 0.1),
                      child: Icon(_getActivityIcon(activity.type),
                          color: _getActivityColor(context, activity.type)),
                    ),
                    title: Text(activity.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity.subtitle),
                        Text(
                          DateFormat('MMM d, y • HH:mm')
                              .format(activity.timestamp),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    trailing: const Icon(Iconsax.arrow_right_3, size: 16),
                    onTap: () => _handleActivityTap(context, activity),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _handleActivityTap(BuildContext context, ActivityEntity activity) {
    switch (activity.type) {
      case ActivityType.interviewPrep:
        _navigateToInterview(context, activity);
        break;
      case ActivityType.cvCreated:
        context.router.navigate(const CvBuilderWelcomeRoute());
        break;
      case ActivityType.cvAnalyzed:
        context.router.navigate(const CvAnalyzerUploadRoute());
        break;
      case ActivityType.cvTranslated:
        context.router.navigate(const CvAtsConverterRoute());
        break;
      default:
        break;
    }
  }

  void _navigateToInterview(BuildContext context, ActivityEntity activity) {
    final interviewProvider = context.read<InterviewProvider>();
    final interviewId = activity.relatedId;

    if (interviewId != null) {
      try {
        final interview = interviewProvider.history.firstWhere(
          (i) => i.id == interviewId,
          orElse: () => throw Exception('Not found'),
        );

        if (interview.report != null) {
          interviewProvider.setReport(interview.report!);
          context.router.push(const InterviewFeedbackOverviewRoute());
          return;
        }
      } catch (_) {}
    }
    context.router.navigate(const InterviewPrepRoute());
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.cvCreated:
        return Iconsax.document_text;
      case ActivityType.cvAnalyzed:
        return Iconsax.chart_2;
      case ActivityType.interviewPrep:
        return Iconsax.microphone;
      case ActivityType.cvTranslated:
        return Iconsax.translate;
      default:
        return Iconsax.activity;
    }
  }

  Color _getActivityColor(BuildContext context, ActivityType type) {
    switch (type) {
      case ActivityType.cvCreated:
        return Theme.of(context).colorScheme.primary;
      case ActivityType.cvAnalyzed:
        return Theme.of(context).colorScheme.secondary;
      case ActivityType.interviewPrep:
        return Theme.of(context).colorScheme.tertiary;
      default:
        return Colors.grey;
    }
  }
}
