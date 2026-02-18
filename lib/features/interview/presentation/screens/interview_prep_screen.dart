import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';
import 'package:intl/intl.dart';

@RoutePage()
class InterviewPrepScreen extends StatelessWidget {
  const InterviewPrepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.interviewPrep),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSizes.sm,
            children: [
              AppSection(
                child: Column(
                  spacing: AppSizes.md,
                  children: [
                    Icon(
                      Iconsax.microphone,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Column(
                      spacing: AppSizes.xs,
                      children: [
                        Text(
                          l10n.aiInterviewPractice,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          l10n.practiceInterviewWithAi,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.router.push(const InterviewSetupStep1Route()),
                      icon: const Icon(Iconsax.play),
                      label: Text(l10n.startNewInterview),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                      ),
                    ),
                  ],
                ),
              ),
              AppSection(
                child: Column(
                  spacing: AppSizes.md,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.recentInterviews,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        TextButton(
                          onPressed: () =>
                              context.router.navigate(const HistoryRoute()),
                          child: Text(l10n.viewAll),
                        ),
                      ],
                    ),
                    Consumer<InterviewProvider>(
                      builder: (context, provider, _) {
                        if (provider.history.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSizes.md),
                              child: Text(
                                l10n.noInterviewHistory,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                          );
                        }

                        final recent = provider.history.take(3).toList();

                        return Column(
                          spacing: AppSizes.sm,
                          children: recent.map((interview) {
                            final score = interview.report?.overallScore ?? 0;
                            return Card(
                              margin: EdgeInsets.zero,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: _getScoreColor(context, score)
                                      .withValues(alpha: 0.1),
                                  child: Text(
                                    score.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _getScoreColor(context, score),
                                    ),
                                  ),
                                ),
                                title: Text(l10n.interviewResults),
                                subtitle: Text(
                                  DateFormat.yMMMd().format(interview.createdAt),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                trailing: const Icon(Iconsax.arrow_right_3, size: 16),
                                onTap: () {
                                  if (interview.report != null) {
                                    provider.setReport(interview.report!);
                                    context.router
                                        .push(const InterviewFeedbackOverviewRoute());
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(BuildContext context, int score) {
    if (score >= 80) return Theme.of(context).colorScheme.primary;
    if (score >= 60) return Colors.orange;
    return Theme.of(context).colorScheme.error;
  }
}
