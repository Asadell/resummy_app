import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';

@RoutePage()
class InterviewSessionClosingScreen extends StatefulWidget {
  const InterviewSessionClosingScreen({super.key});

  @override
  State<InterviewSessionClosingScreen> createState() =>
      _InterviewSessionClosingScreenState();
}

class _InterviewSessionClosingScreenState
    extends State<InterviewSessionClosingScreen> {
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

    _simulateProgress();
  }

  void _simulateProgress() async {
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
    if (!_analysisComplete) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final provider = context.read<InterviewProvider>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showExitConfirmation(context, l10n);
        if (shouldExit && context.mounted) {
          provider.cancelAnalysis();
          context.router.popUntil(
              (route) => route.settings.name == InterviewPrepRoute.name);
        }
      },
      child: Consumer<InterviewProvider>(
        builder: (context, provider, child) {
          if (provider.status == InterviewStatus.completed &&
              !_analysisComplete) {
            _analysisComplete = true;
            _progress = 1.0;

            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                context.router.replace(const InterviewFeedbackOverviewRoute());
              }
            });
          }

          if (provider.status == InterviewStatus.error) {
            return Scaffold(
              appBar: AppBar(title: Text(l10n.errorTitle)),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.warning_2,
                        size: 48, color: Theme.of(context).colorScheme.error),
                    const SizedBox(height: 16),
                    Text(provider.errorMessage ?? l10n.unknownError),
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
                  const SizedBox(width: AppSizes.sm),
                  Icon(Iconsax.award,
                      color: Theme.of(context).colorScheme.secondary, size: 24),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Iconsax.close_circle),
                  onPressed: () async {
                    final shouldExit =
                        await _showExitConfirmation(context, l10n);
                    if (shouldExit && context.mounted) {
                      provider.cancelAnalysis();
                      context.router.popUntil((route) =>
                          route.settings.name == InterviewPrepRoute.name);
                    }
                  },
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
                        spacing: AppSizes.md,
                        children: [
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0.8, end: 1.2),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.elasticOut,
                            builder: (context, double scale, child) {
                              return Transform.scale(
                                scale: scale,
                                child: Icon(Iconsax.award,
                                    size: 100,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              );
                            },
                          ),
                          Column(
                            spacing: AppSizes.xs,
                            children: [
                              Text(
                                l10n.interviewCompleted,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                l10n.goodJobUser(''),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AppSection(
                      child: Row(
                        spacing: AppSizes.md,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Iconsax.profile_circle,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              l10n.aiClosingMessage(''),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSection(
                      child: Column(
                        spacing: AppSizes.md,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: AppSizes.sm,
                            children: [
                              Text(
                                l10n.generatingFeedbackProgress,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Icon(Iconsax.timer_1,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20),
                            ],
                          ),
                          Column(
                            spacing: AppSizes.xs,
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(AppSizes.xs),
                                child: LinearProgressIndicator(
                                  value: _progress,
                                  minHeight: 12,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.primary),
                                ),
                              ),
                              Text(
                                '${(_progress * 100).toInt()}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AppSection(
                      child: Column(
                        spacing: AppSizes.xs,
                        children: List.generate(_steps(l10n).length, (index) {
                          final currentStepIndex = (_progress * 4).floor();

                          final isDone =
                              _analysisComplete || index < currentStepIndex;
                          final isInProgress =
                              !_analysisComplete && index == currentStepIndex;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              spacing: AppSizes.md,
                              children: [
                                if (isDone)
                                  Icon(Iconsax.tick_circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 20)
                                else if (isInProgress)
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  )
                                else
                                  Icon(Icons.circle_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withValues(alpha: 0.3),
                                      size: 20),
                                Text(
                                  _steps(l10n)[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: isDone
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : isInProgress
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant
                                                    .withValues(alpha: 0.5),
                                        fontWeight: isDone || isInProgress
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    AppSection(
                      child: Center(
                        child: Text(
                          l10n.estimateTime,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                          textAlign: TextAlign.center,
                        ),
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

  Future<bool> _showExitConfirmation(
      BuildContext context, AppLocalizations l10n) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(AppSizes.md)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSizes.md,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(AppSizes.xs),
                ),
              ),
            ),
            Icon(
              Iconsax.warning_2,
              color: Theme.of(context).colorScheme.error,
              size: 48,
            ),
            Column(
              spacing: AppSizes.xs,
              children: [
                Text(
                  l10n.stopInterviewTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  l10n.stopInterviewDesc,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              spacing: AppSizes.sm,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(l10n.cancel,
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color)),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    child: Text(l10n.exit),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xs),
          ],
        ),
      ),
    );
    return result ?? false;
  }
}
