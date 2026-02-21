import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';

@RoutePage()
class InterviewFeedbackRecommendationsScreen extends StatelessWidget {
  const InterviewFeedbackRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<InterviewProvider>(
      builder: (context, provider, child) {
        final report = provider.report;
        if (report == null) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_left),
              onPressed: () =>
                  context.router.push(const InterviewFeedbackOverviewRoute()),
            ),
            title: Row(
              children: [
                Icon(Iconsax.lamp_on,
                    color: Theme.of(context).colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(l10n.recommendations),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Iconsax.document_download),
                onPressed: () {},
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSizes.sm,
                children: [
                  AppSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSizes.xs,
                      children: [
                        Row(
                          children: [
                            Icon(Iconsax.lamp_on,
                                color: Theme.of(context).colorScheme.primary,
                                size: 32),
                            const SizedBox(width: AppSizes.sm),
                            Text(
                              l10n.recommendations,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        Text(
                          l10n.basedOnPerformance,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  AppSection(
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.md),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(AppSizes.sm),
                        border: Border(
                          left: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSizes.sm,
                        children: [
                          Row(
                            children: [
                              Icon(Iconsax.weight,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24),
                              const SizedBox(width: AppSizes.sm),
                              Text(
                                l10n.yourStrengths,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          if (report.strengths.isEmpty)
                            Text(l10n.noStrengthsIdentified,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant))
                          else
                            Column(
                              spacing: 8,
                              children: report.strengths
                                  .map((s) => _buildListItem(
                                      context,
                                      s,
                                      Theme.of(context).colorScheme.onSurface,
                                      Iconsax.tick_circle))
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                  ),
                  AppSection(
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.md),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(AppSizes.sm),
                        border: Border(
                          left: BorderSide(color: AppColors.error, width: 4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSizes.sm,
                        children: [
                          Row(
                            children: [
                              Icon(Iconsax.direct_up,
                                  color: Theme.of(context).colorScheme.error,
                                  size: 24),
                              const SizedBox(width: AppSizes.sm),
                              Text(
                                l10n.areasForImprovement,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          if (report.improvements.isEmpty)
                            Text(l10n.noImprovementsIdentified,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant))
                          else
                            Column(
                              spacing: 8,
                              children: report.improvements
                                  .map((s) => _buildListItem(
                                      context,
                                      s,
                                      Theme.of(context).colorScheme.onSurface,
                                      Iconsax.info_circle))
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                  ),
                  AppSection(
                    child:
                        _buildReadinessCard(context, report.overallScore, l10n),
                  ),
                  const SizedBox(height: AppSizes.lg),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                  top: BorderSide(
                      color: Theme.of(context)
                          .dividerColor
                          .withValues(alpha: 0.1))),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSizes.sm,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      provider.resetInterview();
                      context.router.push(const InterviewPrepRoute());
                    },
                    icon: const Icon(Iconsax.refresh),
                    label: Text(l10n.practiceAgain),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        context.router.push(const InterviewPrepRoute()),
                    icon: const Icon(Iconsax.home),
                    label: Text(l10n.dashboard),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListItem(
      BuildContext context, String text, Color color, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: 16,
            color: icon == Iconsax.tick_circle
                ? Theme.of(context).colorScheme.primary
                : AppColors.error),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  height: 1.5,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadinessCard(
      BuildContext context, int score, AppLocalizations l10n) {
    Color bgColor;
    String title;
    String message;
    IconData icon;

    if (score >= 80) {
      bgColor = Theme.of(context).colorScheme.primaryContainer;
      title = l10n.readinessStatusExcellent;
      message = l10n.readinessDescExcellent;
      icon = Iconsax.tick_circle;
    } else if (score >= 60) {
      bgColor = Colors.orange.withValues(alpha: 0.1);
      title = l10n.readinessStatusGood;
      message = l10n.readinessDescGood;
      icon = Iconsax.timer_1;
    } else {
      bgColor = AppColors.error.withValues(alpha: 0.1);
      title = l10n.readinessStatusNeedsWork;
      message = l10n.readinessDescNeedsWork;
      icon = Iconsax.close_circle;
    }

    final textColor = score >= 80
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : score >= 60
            ? Colors.orange[800]!
            : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.sm),
        border: Border.all(color: textColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSizes.sm,
        children: [
          Icon(icon, size: 40, color: textColor),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
              ),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textColor.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
