import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:resummy_app/features/history/domain/entities/activity_entity.dart';
import 'package:resummy_app/features/history/presentation/providers/history_provider.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.home),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.notification),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.notificationsComingSoon)),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.welcomeBack,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      l10n.letsBuildYourPerfectCareer,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              AppSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.quickActions,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSizes.md),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            icon: Iconsax.document_text,
                            title: l10n.buildCv,
                            color: Theme.of(context).colorScheme.primary,
                            onTap: () => context.router
                                .push(const CvBuilderWelcomeRoute()),
                          ),
                        ),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Iconsax.chart_2,
                            title: l10n.analyzeCv,
                            color: Theme.of(context).colorScheme.secondary,
                            onTap: () => context.router
                                .push(const CvAnalyzerUploadRoute()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.md),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            icon: Iconsax.microphone,
                            title: l10n.interviewPrep,
                            color: Theme.of(context).colorScheme.tertiary,
                            onTap: () => context.router
                                .push(const InterviewSetupStep1Route()),
                          ),
                        ),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Iconsax.magic_star,
                            title: l10n.convertToCvAts,
                            color: Colors.purple,
                            onTap: () =>
                                context.router.push(const CvAtsConverterRoute()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              AppSection(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.recentActivity,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextButton(
                          onPressed: () {
                            context.router.navigate(const HistoryRoute());
                          },
                          child: Text(l10n.viewAll),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Consumer<HistoryProvider>(
                      builder: (context, provider, child) {
                        final activities = provider.activities.take(3).toList();

                        if (activities.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppSizes.lg),
                              child: Text(
                                l10n.noInterviewHistory,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ),
                          );
                        }

                        return Column(
                          spacing: AppSizes.sm,
                          children: activities.map((activity) {
                            return _ActivityCard(
                              icon: _getActivityIcon(activity.type),
                              title: activity.title,
                              subtitle: activity.subtitle,
                              time: _formatTimeAgo(context, activity.timestamp),
                              onTap: () {
                                if (activity.type ==
                                    ActivityType.interviewPrep) {
                                  context.router.navigate(const HistoryRoute());
                                } else if (activity.type ==
                                    ActivityType.cvCreated) {
                                  context.router
                                      .navigate(const CvBuilderWelcomeRoute());
                                } else if (activity.type ==
                                    ActivityType.cvAnalyzed) {
                                  context.router
                                      .navigate(const CvAnalyzerUploadRoute());
                                } else if (activity.type ==
                                    ActivityType.cvTranslated) {
                                  context.router
                                      .navigate(const CvAtsConverterRoute());
                                }
                              },
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

  String _formatTimeAgo(BuildContext context, DateTime dateTime) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}${l10n.timeDaysSuffix}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}${l10n.timeHoursSuffix}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}${l10n.timeMinutesSuffix}';
    } else {
      return l10n.timeJustNow;
    }
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: AppSizes.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.xs),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon,  size: 20, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Text(
              time,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
