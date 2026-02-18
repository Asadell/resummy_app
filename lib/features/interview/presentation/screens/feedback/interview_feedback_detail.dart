import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';

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
            body: const Center(child: Text('No feedback data available.')),
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

        String userTranscript = '';
        if (_currentIndex < provider.questions.length) {
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
              icon: const Icon(Iconsax.arrow_left_1),
              onPressed: () =>
                  context.router.push(const InterviewFeedbackQuestionsRoute()),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: Theme.of(context).cardTheme.color,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${l10n.question} ${_currentIndex + 1}/$totalQuestions',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Iconsax.message_text,
                                size: 20,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.color),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                questionText,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Iconsax.info_circle,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.color),
                            const SizedBox(width: 8),
                            Text(
                              l10n.feedback,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          feedback.starAnalysis.overallFeedback,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Iconsax.chart_2,
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.color),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.starAnalysis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
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
                                    color: _getScoreColor(
                                        feedback.starAnalysis.score * 10),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const Divider(height: 32),
                        _buildPresenceRow(context, 'Situation',
                            feedback.starAnalysis.situation.present),
                        const SizedBox(height: 8),
                        _buildPresenceRow(context, 'Task',
                            feedback.starAnalysis.task.present),
                        const SizedBox(height: 8),
                        _buildPresenceRow(context, 'Action',
                            feedback.starAnalysis.action.present),
                        const SizedBox(height: 8),
                        _buildPresenceRow(context, 'Result',
                            feedback.starAnalysis.result.present),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Iconsax.microphone_2,
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.color),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.fluencyAnalysis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
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
                                    color: _getScoreColor(
                                        feedback.fluencyAnalysis.score * 10),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Iconsax.magic_star,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.color),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.improvedSpeechTitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? const Color(0xFFFEE2E2)
                                    : AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.originalSpeechLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? const Color(0xFF991B1B)
                                      : AppColors.error,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                userTranscript.isNotEmpty
                                    ? userTranscript
                                    : 'No answer recorded.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? const Color(0xFF7F1D1D)
                                      : AppColors.error.withValues(alpha: 0.8),
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (feedback.improvedSpeech.improvedText.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? const Color(0xFFD1FAE5)
                                  : AppColors.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Iconsax.magic_star,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? const Color(0xFF065F46)
                                            : AppColors.secondary,
                                        size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.improvedSpeechLabel,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? const Color(0xFF065F46)
                                            : AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  feedback.improvedSpeech.improvedText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? const Color(0xFF065F46)
                                        : AppColors.secondary
                                            .withValues(alpha: 0.9),
                                    height: 1.6,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
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
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _currentIndex > 0
                          ? () {
                              setState(() => _currentIndex--);
                            }
                          : null,
                      icon: const Icon(Iconsax.arrow_left_2, size: 18),
                      label: Text(l10n.previous),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _currentIndex < totalQuestions - 1
                          ? () {
                              setState(() => _currentIndex++);
                            }
                          : null,
                      icon: const Icon(Iconsax.arrow_right_3, size: 18),
                      label: Text(l10n.next),
                      iconAlignment: IconAlignment.end,
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

  Color _getScoreColor(int score) {
    if (score >= 80) return AppColors.secondary;
    if (score >= 60) return AppColors.primary;
    return AppColors.warning;
  }

  Widget _buildPresenceRow(BuildContext context, String label, bool isPresent) {
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
              isPresent ? 'Present' : 'Missing',
              style: TextStyle(
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
