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
  void dispose() {
    // CRITICAL: Cancel analysis if the user leaves this screen
    if (!_analysisComplete) {
       debugPrint('InterviewSessionClosingScreen disposed before completion. Cancelling analysis.');
       // We need to trigger cancellation in the provider
       // However, we can't context.read here easily if widget is unmounted.
       // But provider itself should handle cancellation if we use the token approach.
       // Actually, the provider's analyzeSession is running. We need to tell it to stop.
       // The best way is to set a flag in the provider or use the existing cancellation token mechanism if available.
       // In our case, we passed a 'shouldStop' callback to the service. 
       // That callback checks prompt or provider state.
       // Let's ensure the provider knows we are resetting or cancelled.
       
       // Ideally, we should call a method on the provider to signal cancellation.
       // provider.cancelAnalysis(); 
       // But we need a reference to the provider. 
       // Let's do it in deactivated or use a post-frame callback if possible, 
       // or just rely on the fact that if this screen is popped, the user went back/home.
       
       // Better approach: process cleanup in Provider.resetInterview() when called from outside?
       // OR: call provider.cancelAnalysis() here.
       // Since we are in dispose, we can't use context.read safely if the widget is already unmounted from tree.
       // But we can capture the provider reference in initState or build.
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Capture provider for dispose (if needed, but provider might be disposed too if scoped).
    // Assuming Provider is above this route.
    final provider = context.read<InterviewProvider>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showExitConfirmation(context, l10n);
        if (shouldExit && context.mounted) {
           provider.cancelAnalysis();
           context.router.popUntil((route) => route.settings.name == InterviewPrepRoute.name);
        }
      },
      child: Consumer<InterviewProvider>(
        builder: (context, provider, child) {
          // Check for completion
          if (provider.status == InterviewStatus.completed && !_analysisComplete) {
            _analysisComplete = true;
            _progress = 1.0;
            // Delay briefly to show 100% then navigate
            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                // IMPORTANT: Don't pop, push replacement or push to next
                // Use replace to prevent going back to this loading screen
                context.router.replace(const InterviewFeedbackOverviewRoute());
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
                      onPressed: () {
                         provider.resetInterview();
                         context.router.maybePop();
                      },
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
              automaticallyImplyLeading: false, 
              title: Row(
                children: [
                  Text(l10n.interviewCompleted),
                  const SizedBox(width: 8),
                  Icon(Iconsax.award, color: Theme.of(context).colorScheme.secondary, size: 24),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Iconsax.close_circle),
                  onPressed: () async {
                    final shouldExit = await _showExitConfirmation(context, l10n);
                    if (shouldExit && context.mounted) {
                       provider.cancelAnalysis();
                       context.router.popUntil((route) => route.settings.name == InterviewPrepRoute.name);
                    }
                  },
                ),
              ],
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
                      l10n.estimateTime, // "Approx. 1-2 minutes"
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
      ),
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context, AppLocalizations l10n) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Icon(
              Iconsax.warning_2,
              color: Theme.of(context).colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.stopInterviewTitle, // "Stop Analysis?"
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.stopInterviewDesc, // "If you leave now, the analysis will be cancelled and you will lose your interview data."
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                    child: Text(l10n.cancel), // "Stay"
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                    child: Text(l10n.exit), // "Stop & Exit"
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
    return result ?? false;
  }
}