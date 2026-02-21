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
import 'package:resummy_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_analyzer_provider.dart';
import 'package:resummy_app/features/history/presentation/widgets/analysis_history_card.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, l10n),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _QuickActionCard(
                                icon: Iconsax.document_text,
                                title: l10n.buildCv,
                                color: Theme.of(context).colorScheme.primary,
                                onTap: () {
                                  context.read<CVBuilderProvider>().startNewCV();
                                  context.router.push(const CvBuilderStep1Route());
                                },
                              ),
                            ),
                            const SizedBox(width: AppSizes.md),
                            Expanded(
                              child: _QuickActionCard(
                                icon: Iconsax.chart_2,
                                title: l10n.analyzeCv,
                                color: Theme.of(context).colorScheme.secondary,
                                onTap: () {
                                  context
                                      .read<CvAnalyzerProvider>()
                                      .prepareForNewAnalysis();
                                  context.router
                                      .push(const CvAnalyzerUploadRoute());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                onTap: () => context.router
                                    .push(const CvAtsConverterRoute()),
                              ),
                            ),
                          ],
                        ),
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
                          final activities =
                              provider.activities.take(3).toList();

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
                              } else if (activity is AnalysisActivityItem) {
                                return AnalysisHistoryCard(
                                  result: activity.result,
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
                const SizedBox(height: AppSizes.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 180,
      collapsedHeight: kToolbarHeight + 20,
      pinned: true,
      stretch: true,
      automaticallyImplyLeading: false,
      backgroundColor: theme.colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: AppSizes.md, bottom: 16),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.welcomeBack,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              context.watch<ProfileProvider>().profile?.fullName ?? l10n.unknown,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.8),
                    theme.colorScheme.secondary.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 100,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, top: 4.0),
          child: CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: IconButton(
              icon: const Icon(Iconsax.notification,
                  color: Colors.white, size: 20),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.notificationsComingSoon)),
                );
              },
            ),
          ),
        ),
      ],
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
