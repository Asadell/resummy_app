import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';
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
              Container(
                padding: const EdgeInsets.all(20),
                color: Theme.of(context).cardTheme.color,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Iconsax.clipboard_text,
                            color: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.color),
                        const SizedBox(width: 8),
                        Text(
                          l10n.fullReportTitle,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
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

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(12),
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
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      questionTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                      maxLines: isExpanded ? null : 1,
                                      overflow: isExpanded
                                          ? null
                                          : TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: scoreColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${feedback.starAnalysis.score}/10',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildScoreChip(context, 'STAR',
                                        feedback.starAnalysis.score.toDouble()),
                                    const SizedBox(width: 8),
                                    _buildScoreChip(
                                        context,
                                        l10n.fluency,
                                        feedback.fluencyAnalysis.score
                                            .toDouble()),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (isExpanded) ...[
                                Row(
                                  children: [
                                    Icon(Iconsax.info_circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.feedback,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  feedback.starAnalysis.overallFeedback,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: () => context.router.push(
                                        InterviewFeedbackDetailRoute(
                                            feedbackIndex: index)),
                                    icon: const Icon(Iconsax.arrow_right_3,
                                        size: 16),
                                    label: Text(l10n.viewDetail),
                                    iconAlignment: IconAlignment.end,
                                  ),
                                ),
                              ] else ...[
                                const SizedBox(height: 8),
                                Text(
                                  feedback.starAnalysis.overallFeedback,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withValues(alpha: 0.05)
                    : Colors.transparent,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
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
    if (score >= 80) return AppColors.secondary;
    if (score >= 60) return AppColors.primary;
    return AppColors.warning;
  }

  Widget _buildScoreChip(BuildContext context, String label, double score) {
    Color chipColor = AppColors.primary;
    if (score >= 8.0) {
      chipColor = AppColors.secondary;
    } else if (score < 6.0) {
      chipColor = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$label: ${score.toStringAsFixed(1)}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
