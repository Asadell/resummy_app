import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';

@RoutePage()
class InterviewSessionClosingScreen extends StatefulWidget {
  const InterviewSessionClosingScreen({super.key});

  @override
  State<InterviewSessionClosingScreen> createState() => _InterviewSessionClosingScreenState();
}

class _InterviewSessionClosingScreenState extends State<InterviewSessionClosingScreen> {
  // Use a simpler progress simulation that finishes when the actual analysis is done
  double _progress = 0.0;
  bool _analysisComplete = false;

  List<String> _steps(AppLocalizations l10n) => [
    l10n.analyzingAnswers,
    l10n.evaluatingStar,
    l10n.calculatingFluency,
    l10n.generatingRecommendations,
  ];

  @override
  void initState() {
    super.initState();
    // Start a slow progress simulation to keep the UI alive while we wait for the API
    _simulateProgress();
  }

  void _simulateProgress() async {
    // Slowly increment progress up to 90%
    while (mounted && !_analysisComplete && _progress < 0.9) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted && !_analysisComplete) {
        setState(() {
          _progress += 0.05;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<InterviewProvider>(
      builder: (context, provider, child) {
        // Check for completion
        if (provider.status == InterviewStatus.completed && !_analysisComplete) {
          _analysisComplete = true;
          _progress = 1.0;
          // Delay briefly to show 100% then navigate
          Future.delayed(const Duration(seconds: 1), () {
            if (context.mounted) {
              context.router.push(const InterviewFeedbackOverviewRoute());
            }
          });
        }

        // Check for error
        if (provider.status == InterviewStatus.error) {
           return Scaffold(
            appBar: AppBar(title: Text(l10n.errorTitle)),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.warning_2, size: 48, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text(provider.errorMessage ?? 'Unknown error'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.router.maybePop(),
                    child: Text(l10n.goBack),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false, // Prevent back navigation while analyzing
            title: Row(
              children: [
                Text(l10n.interviewCompleted),
                const SizedBox(width: 8),
                Icon(Iconsax.award, color: Theme.of(context).colorScheme.secondary, size: 24),
              ],
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Trophy Icon
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.8, end: 1.2),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.elasticOut,
                    builder: (context, double scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Icon(Iconsax.award, size: 100, color: Theme.of(context).colorScheme.secondary),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    l10n.interviewCompleted,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.goodJobUser('John'), // You might want to get the user name from AuthProvider ideally
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Stats Card
                  Container(
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
                            Icon(Iconsax.chart_2, color: Theme.of(context).colorScheme.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              l10n.interviewSummary,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                           Expanded(
                              child: _buildStatItem(
                                Iconsax.message_question, 
                                l10n.questionsLabel, 
                                l10n.questionsAnswered(provider.questions.length),
                              ),
                            ),
                            Expanded(
                              child: _buildStatItem(
                                Iconsax.message_text_1, 
                                l10n.wordsSpoken, 
                                // Simple word count estimate from transcript
                                '~${provider.questions.fold(0, (sum, q) => sum + (q.userAnswerTranscript?.split(' ').length ?? 0))}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // AI Closing Message
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withAlpha(200)],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Iconsax.profile_circle,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.aiClosingMessage('John'),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Generating Feedback
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.generatingFeedbackProgress,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Iconsax.timer_1, color: Theme.of(context).colorScheme.primary, size: 24),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 8,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${(_progress * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Loading Steps
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: List.generate(_steps(l10n).length, (index) {
                        // determine step status based on progress
                        // Roughly map progress 0-1 to steps 0-3
                        final currentStepIndex = (_progress * 4).floor();
                        
                        // If analysis is complete, all steps are done
                        final isDone = _analysisComplete || index < currentStepIndex;
                        final isInProgress = !_analysisComplete && index == currentStepIndex;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              if (isDone)
                                Icon(Iconsax.tick_circle, color: Theme.of(context).colorScheme.secondary, size: 20)
                              else if (isInProgress)
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                                  ),
                                )
                              else
                                Icon(Icons.circle_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3), size: 20),
                              const SizedBox(width: 12),
                              Text(
                                _steps(l10n)[index],
                                style: TextStyle(
                                  color: isDone
                                      ? Theme.of(context).colorScheme.secondary
                                      : isInProgress
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                  fontWeight: isDone || isInProgress ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Estimate
                  Text(
                    l10n.estimateTime,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}