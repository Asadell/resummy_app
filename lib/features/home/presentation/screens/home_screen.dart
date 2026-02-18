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
import 'package:resummy_app/shared/widgets/app_section.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, l10n),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSizes.md),
                  _buildSectionHeader(
                    context,
                    title: l10n.quickActions,
                  ),
                  const SizedBox(height: AppSizes.md),
                ],
              ),
            ),
          ),
          _buildQuickActionsGrid(context, l10n),
          SliverPadding(
            padding: const EdgeInsets.all(AppSizes.md),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildSectionHeader(
                    context,
                    title: l10n.recentActivity,
                    onViewAll: () => context.router.navigate(const HistoryRoute()),
                  ),
                  const SizedBox(height: AppSizes.md),
                  _buildRecentActivity(context, l10n),
                ],
              ),
            ),
          ),
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSizes.xl),
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
              context.watch<ProfileProvider>().profile?.fullName ?? 'User',
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
              icon: const Icon(Iconsax.notification, color: Colors.white, size: 20),
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

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    VoidCallback? onViewAll,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.viewAll),
                const SizedBox(width: 4),
                const Icon(Iconsax.arrow_right_1, size: 14),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final actions = [
      _QuickActionData(
        icon: Iconsax.document_text,
        title: l10n.buildCv,
        color: theme.colorScheme.primary,
        onTap: () => context.router.push(const CvBuilderWelcomeRoute()),
      ),
      _QuickActionData(
        icon: Iconsax.chart_2,
        title: l10n.analyzeCv,
        color: theme.colorScheme.secondary,
        onTap: () => context.router.push(const CvAnalyzerUploadRoute()),
      ),
      _QuickActionData(
        icon: Iconsax.microphone,
        title: l10n.interviewPrep,
        color: theme.colorScheme.tertiary,
        onTap: () => context.router.push(const InterviewSetupStep1Route()),
      ),
      _QuickActionData(
        icon: Iconsax.magic_star,
        title: l10n.convertToCvAts,
        color: Colors.purple,
        onTap: () => context.router.push(const CvAtsConverterRoute()),
      ),
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSizes.md,
          crossAxisSpacing: AppSizes.md,
          childAspectRatio: 1.1,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final action = actions[index];
            return _QuickActionCard(
              icon: action.icon,
              title: action.title,
              color: action.color,
              onTap: action.onTap,
            );
          },
          childCount: actions.length,
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, AppLocalizations l10n) {
    return Consumer<HistoryProvider>(
      builder: (context, provider, child) {
        final activities = provider.activities.take(3).toList();

        if (activities.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
              child: Column(
                children: [
                  Icon(
                    Iconsax.document_filter,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    l10n.noInterviewHistory,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
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
    );
  }
}

class _QuickActionData {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  _QuickActionData({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });
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
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: color.withValues(alpha: 0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

