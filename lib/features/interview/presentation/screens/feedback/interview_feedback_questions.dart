import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';

@RoutePage()
class InterviewFeedbackQuestionsScreen extends StatefulWidget {
  const InterviewFeedbackQuestionsScreen({super.key});

  @override
  State<InterviewFeedbackQuestionsScreen> createState() =>
      _InterviewFeedbackQuestionsScreenState();
}

class _InterviewFeedbackQuestionsScreenState
    extends State<InterviewFeedbackQuestionsScreen> {
  int _expandedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<InterviewProvider>(builder: (context, provider, child) {
      final report = provider.report;
      if (report == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final feedbacks = report.questionFeedbacks;

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(l10n.fullReport),
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left),
            onPressed: () =>
                context.router.push(const InterviewFeedbackOverviewRoute()),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              AppSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSizes.xs,
                  children: [
                    Row(
                      children: [
                        Icon(Iconsax.clipboard_text,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: AppSizes.sm),
                        Text(
                          l10n.fullReportTitle,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Text(
                      '${feedbacks.length} ${l10n.questions} | ${l10n.overallScore}: ${report.overallScore}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Expanded(
                child: AppSection(
                  child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: AppSizes.lg),
                  itemCount: feedbacks.length,
                  itemBuilder: (context, index) {
                    final feedback = feedbacks[index];

                    final question = provider.questions.isNotEmpty &&
                            index < provider.questions.length
                        ? provider.questions[index]
                        : null;
                    final questionTitle =
                        question?.text ?? '${l10n.question} ${index + 1}';

                    final isExpanded = _expandedIndex == index;
                    final scoreColor =
                        _getScoreColor(context, feedback.starAnalysis.score * 10);

                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSizes.md),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).dividerColor.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _expandedIndex = isExpanded ? -1 : index;
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(AppSizes.md),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: AppSizes.sm,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              questionTitle,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.3,
                                                  ),
                                              maxLines: isExpanded ? null : 2,
                                              overflow: isExpanded
                                                  ? null
                                                  : TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: AppSizes.sm),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: scoreColor.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              '${feedback.starAnalysis.score}/10',
                                              style: TextStyle(
                                                color: scoreColor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          spacing: AppSizes.xs,
                                          children: [
                                            _buildScoreChip(context, 'STAR',
                                                feedback.starAnalysis.score.toDouble()),
                                            _buildScoreChip(
                                                context,
                                                l10n.fluency,
                                                feedback.fluencyAnalysis.score
                                                    .toDouble()),
                                          ],
                                        ),
                                      ),
                                      if (isExpanded) ...[
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.all(AppSizes.md),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.surfaceContainerLow,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Theme.of(context).dividerColor.withValues(alpha: 0.15),
                                            ),
                                          ),
                                          child: Text(
                                            feedback.starAnalysis.overallFeedback,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                  height: 1.5,
                                                ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton.icon(
                                            onPressed: () => context.router.push(
                                                InterviewFeedbackDetailRoute(
                                                    feedbackIndex: index)),
                                            icon: const Icon(Iconsax.arrow_right_3,
                                                size: 14),
                                            label: Text(l10n.viewDetail, 
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              )
                                            ),
                                            iconAlignment: IconAlignment.end,
                                          ),
                                        ),
                                      ] else ...[
                                        Text(
                                          feedback.starAnalysis.overallFeedback,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 4,
                                  width: double.infinity,
                                  color: scoreColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                  },
                ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Color _getScoreColor(BuildContext context, int score) {
    if (score >= 80) return Theme.of(context).colorScheme.primary;
    if (score >= 60) return Colors.orange;
    return Theme.of(context).colorScheme.error;
  }

  Widget _buildScoreChip(BuildContext context, String label, double score) {
    Color chipColor = Theme.of(context).colorScheme.primary;
    if (score >= 8.0) {
      chipColor = Theme.of(context).colorScheme.primary;
    } else if (score < 6.0) {
      chipColor = AppColors.error;
    } else {
      chipColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.xs),
        border: Border.all(color: chipColor.withValues(alpha: 0.2)),
      ),
      child: Text(
        '$label: ${score.toStringAsFixed(1)}',
        style: TextStyle(
          color: chipColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
