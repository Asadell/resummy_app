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
              Expanded(
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
                        _getScoreColor(feedback.starAnalysis.score * 10);

                    return AppSection(
                      verticalPadding: AppSizes.xs,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(AppSizes.sm),
                          border: Border(
                            left: BorderSide(
                              color: scoreColor,
                              width: 4,
                            ),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _expandedIndex = isExpanded ? -1 : index;
                            });
                          },
                          borderRadius: BorderRadius.circular(AppSizes.sm),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: AppSizes.sm,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isExpanded
                                          ? Iconsax.arrow_up_2
                                          : Iconsax.arrow_down_2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      size: 18,
                                    ),
                                    const SizedBox(width: AppSizes.xs),
                                    Expanded(
                                      child: Text(
                                        questionTitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                        maxLines: isExpanded ? null : 1,
                                        overflow: isExpanded
                                            ? null
                                            : TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: AppSizes.sm),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: scoreColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(AppSizes.lg),
                                        border: Border.all(color: scoreColor.withValues(alpha: 0.2)),
                                      ),
                                      child: Text(
                                        '${feedback.starAnalysis.score}/10',
                                        style: TextStyle(
                                          color: scoreColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
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
                                  Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 4,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Iconsax.info_circle,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            l10n.feedback,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        feedback.starAnalysis.overallFeedback,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              height: 1.5,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () => context.router.push(
                                          InterviewFeedbackDetailRoute(
                                              feedbackIndex: index)),
                                      icon: const Icon(Iconsax.arrow_right_3,
                                          size: 14),
                                      label: Text(l10n.viewDetail, style: const TextStyle(fontSize: 12)),
                                      iconAlignment: IconAlignment.end,
                                      style: TextButton.styleFrom(
                                        visualDensity: VisualDensity.compact,
                                      ),
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
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(top: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1))),
          ),
          child: SafeArea(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.downloadPdfUnavailable),
                  ),
                );
              },
              icon: const Icon(Iconsax.document_download),
              label: Text(l10n.downloadPdf),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ),
        ),
      );
    });
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppColors.primary;
    if (score >= 60) return Colors.orange;
    return AppColors.error;
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
