import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:resummy_app/features/history/domain/entities/activity_item.dart';
import 'package:resummy_app/features/history/presentation/providers/history_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_history_card.dart';
import 'package:resummy_app/features/interview/presentation/widgets/interview_history_card.dart';
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
                            if (activity is CvActivityItem) {
                              return CvHistoryCard(
                                cv: activity.cvData,
                                index: activities.indexOf(activity),
                              );
                            } else if (activity is InterviewActivityItem) {
                              return InterviewHistoryCard(
                                interview: activity.interview,
                              );
                            }
                            return const SizedBox.shrink();
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
