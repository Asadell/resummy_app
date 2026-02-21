import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';

@RoutePage()
class InterviewFeedbackDetailScreen extends StatefulWidget {
  final int feedbackIndex;

  const InterviewFeedbackDetailScreen({
    super.key,
    this.feedbackIndex = 0,
  });

  @override
  State<InterviewFeedbackDetailScreen> createState() =>
      _InterviewFeedbackDetailScreenState();
}

class _InterviewFeedbackDetailScreenState
    extends State<InterviewFeedbackDetailScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.feedbackIndex;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<InterviewProvider>(
      builder: (context, provider, child) {
        final report = provider.report;
        if (report == null || report.questionFeedbacks.isEmpty) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.noFeedbackData)),
          );
        }

        if (_currentIndex >= report.questionFeedbacks.length) {
          _currentIndex = 0;
        }

        final feedback = report.questionFeedbacks[_currentIndex];
        final totalQuestions = report.questionFeedbacks.length;

        String questionText = l10n.question;
        if (_currentIndex < provider.questions.length) {
          questionText = provider.questions[_currentIndex].text;
        }

        String userTranscript = feedback.userTranscript;

        if (userTranscript.isEmpty &&
            _currentIndex < provider.questions.length) {
          userTranscript =
              provider.questions[_currentIndex].userAnswerTranscript ?? '';
        }

        if (userTranscript.isEmpty) {
          userTranscript = l10n.noAnswerRecorded;
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
                '${l10n.question} ${_currentIndex + 1} ${l10n.totalOf} $totalQuestions'),
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_left),
              onPressed: () =>
                  context.router.push(const InterviewFeedbackQuestionsRoute()),
            ),
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
                      spacing: AppSizes.sm,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSizes.lg),
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            '${l10n.question} ${_currentIndex + 1}/$totalQuestions',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Iconsax.message_text,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: AppSizes.sm),
                            Expanded(
                              child: Text(
                                questionText,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
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
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSizes.sm,
                        children: [
                          Row(
                            children: [
                              Icon(Iconsax.info_circle,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20),
                              const SizedBox(width: AppSizes.sm),
                              Text(
                                l10n.feedback,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                          Text(
                            feedback.starAnalysis.overallFeedback,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  height: 1.5,
                                ),
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
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSizes.md,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Iconsax.chart_2,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 20),
                                  const SizedBox(width: AppSizes.sm),
                                  Text(
                                    l10n.starAnalysis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              Text(
                                '${feedback.starAnalysis.score}/10',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: _getScoreColor(context,
                                          feedback.starAnalysis.score * 10),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          Divider(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withValues(alpha: 0.5)),
                          Column(
                            spacing: AppSizes.sm,
                            children: [
                              _buildPresenceRow(context, l10n, l10n.situationLabel,
                                  feedback.starAnalysis.situation.present),
                              _buildPresenceRow(context, l10n, l10n.taskLabel,
                                  feedback.starAnalysis.task.present),
                              _buildPresenceRow(context, l10n, l10n.actionLabel,
                                  feedback.starAnalysis.action.present),
                              _buildPresenceRow(context, l10n, l10n.resultLabel,
                                  feedback.starAnalysis.result.present),
                            ],
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
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Iconsax.microphone_2,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20),
                              const SizedBox(width: AppSizes.sm),
                              Text(
                                l10n.fluencyAnalysis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          Text(
                            '${feedback.fluencyAnalysis.score}/10',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: _getScoreColor(context,
                                      feedback.fluencyAnalysis.score * 10),
                                  fontWeight: FontWeight.bold,
                                ),
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
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSizes.md,
                        children: [
                          Row(
                            children: [
                              Icon(Iconsax.magic_star,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20),
                              const SizedBox(width: AppSizes.sm),
                              Expanded(
                                child: Text(
                                  l10n.improvedSpeechTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            spacing: AppSizes.sm,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(AppSizes.md),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.error.withValues(alpha: 0.05),
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.sm),
                                  border: Border.all(
                                      color: AppColors.error
                                          .withValues(alpha: 0.1)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 4,
                                  children: [
                                    Text(
                                      l10n.originalSpeechLabel,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.error,
                                          ),
                                    ),
                                    Text(
                                      userTranscript.isNotEmpty
                                          ? userTranscript
                                          : l10n.noAnswerRecorded,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.error
                                                .withValues(alpha: 0.8),
                                            height: 1.5,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              if (feedback
                                  .improvedSpeech.improvedText.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.all(AppSizes.md),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.05),
                                    borderRadius:
                                        BorderRadius.circular(AppSizes.sm),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.1)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 4,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Iconsax.magic_star,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            l10n.improvedSpeechLabel,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        feedback.improvedSpeech.improvedText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.8),
                                              height: 1.5,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
              child: Row(
                spacing: AppSizes.sm,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _currentIndex > 0
                          ? () {
                              setState(() => _currentIndex--);
                            }
                          : null,
                      icon: const Icon(Iconsax.arrow_left, size: 20),
                      label: Text(l10n.previous),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _currentIndex < totalQuestions - 1
                          ? () {
                              setState(() => _currentIndex++);
                            }
                          : null,
                      icon: const Icon(Iconsax.arrow_right_3, size: 20),
                      label: Text(l10n.next),
                      iconAlignment: IconAlignment.end,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
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

  Color _getScoreColor(BuildContext context, int score) {
    if (score >= 80) return Theme.of(context).colorScheme.primary;
    if (score >= 60) return Colors.orange;
    return Theme.of(context).colorScheme.error;
  }

  Widget _buildPresenceRow(
      BuildContext context, AppLocalizations l10n, String label, bool isPresent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        Row(
          children: [
            Icon(
              isPresent ? Iconsax.tick_circle : Iconsax.close_circle,
              color: isPresent ? AppColors.secondary : AppColors.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              isPresent ? l10n.presentLabel : l10n.missingLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isPresent ? AppColors.secondary : AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
            )
          ],
        )
      ],
    );
  }
}
