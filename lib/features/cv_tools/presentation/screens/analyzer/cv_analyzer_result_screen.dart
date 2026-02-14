import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/providers/auth_provider.dart';
import 'package:resummy_app/core/providers/locale_provider.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis_entity.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_history_entity.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_analyzer_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_history_provider.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class CvAnalyzerResultScreen extends StatelessWidget {
  const CvAnalyzerResultScreen({super.key});

  Future<void> _saveHistoryAndNavigateHome(BuildContext context) async {
    final analyzerProvider = context.read<CvAnalyzerProvider>();
    final historyProvider = context.read<CvHistoryProvider>();
    final userId = context.read<AuthProvider>().user?.uid;
    final language = context.read<LocaleProvider>().locale.languageCode;

    if (userId == null || analyzerProvider.analysisResult == null) {
      analyzerProvider.clearState();
      if (context.mounted) {
        context.router.popUntilRoot();
      }
      return;
    }

    final result = analyzerProvider.analysisResult!;
    final fileInfo = analyzerProvider.selectedFileInfo;

    final history = CvAnalysisHistory(
      id: const Uuid().v4(),
      userId: userId,
      cvFileName: fileInfo?.name ?? 'Unknown CV',
      score: result.overallScore,
      grade: result.grade,
      summary: result.summaryFeedback,
      analyzedAt: DateTime.now(),
      positionTarget: analyzerProvider.jobPosition.isNotEmpty
          ? analyzerProvider.jobPosition
          : null,
      language: language,
      analysisData: result.toJson(), // Save full analysis data
    );

    final saved = await historyProvider.saveCvAnalysisHistory(history);

    if (!saved && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(historyProvider.errorMessage.isNotEmpty
              ? historyProvider.errorMessage
              : 'Failed to save analysis history'),
        ),
      );
    }

    analyzerProvider.clearState();
    if (context.mounted) {
      context.router.popUntilRoot();
    }
  }

  Color _getScoreColor(BuildContext context, int score) {
    if (score >= CvAnalysisGradeThresholds.fair) {
      return Theme.of(context).colorScheme.primary;
    } else if (score >= CvAnalysisGradeThresholds.poor) {
      return Colors.orange;
    } else {
      return Theme.of(context).colorScheme.onErrorContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final result = context.watch<CvAnalyzerProvider>().analysisResult;
    final overallScore = result?.overallScore ?? 0;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<CvAnalyzerProvider>().clearAnalysisResult();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.analysisResult),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.router.maybePop();
              context.read<CvAnalyzerProvider>().clearAnalysisResult();
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await _saveHistoryAndNavigateHome(context);
                  },
                  child: Text(l10n.backToHome),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () {},
                child: Icon(
                  Iconsax.share,
                  size: 24,
                ),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // score card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          l10n.yourCvScore,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '$overallScore/100',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: _getScoreColor(context, overallScore),
                                fontSize: 40,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          result?.grade ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  color: _getScoreColor(context, overallScore),
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // metrics detail card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.detailScore,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _renderMetricItem(
                          context,
                          l10n,
                          l10n.keywordMatch,
                          result?.metrics.keywordMatch ?? 0,
                        ),
                        const SizedBox(height: 12),
                        _renderMetricItem(
                          context,
                          l10n,
                          l10n.quantifiableAchievements,
                          result?.metrics.quantifiableAchievements ?? 0,
                        ),
                        const SizedBox(height: 12),
                        _renderMetricItem(
                          context,
                          l10n,
                          l10n.structureCompleteness,
                          result?.metrics.structureCompleteness ?? 0,
                        ),
                        const SizedBox(height: 12),
                        _renderMetricItem(
                          context,
                          l10n,
                          l10n.languageProfessionalism,
                          result?.metrics.languageProfessionalism ?? 0,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Missing Keywords
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.missingKeywords,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          children: result?.missingKeywords
                                  .map((keyword) => Chip(
                                        padding: const EdgeInsets.all(4),
                                        label: Text(
                                          keyword,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .errorContainer,
                                        side: BorderSide.none,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                      ))
                                  .toList() ??
                              [],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // suggestion bullet points
                Text(
                  l10n.improvementSuggestions,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ...?result?.weakBulletPoints.map(
                  (bp) => _renderWeakPointsCard(bp, context),
                ),
                // summary feedback
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.summaryFeedback,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          result?.summaryFeedback ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card _renderWeakPointsCard(
      CvAnalysisWeakBulletPoint bp, BuildContext context) {
    final chipColors = {
      CvAnalysisWeakBulletPointPriority.high: Colors.red,
      CvAnalysisWeakBulletPointPriority.medium: Colors.orange,
      CvAnalysisWeakBulletPointPriority.low: Colors.green,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    bp.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 12),
                Chip(
                  padding: const EdgeInsets.all(4),
                  label: Text(
                    bp.priority.value,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: chipColors[bp.priority],
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  backgroundColor: chipColors[bp.priority]?.withAlpha(30),
                  side: BorderSide(
                    color: chipColors[bp.priority]!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Iconsax.close_circle,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      bp.original,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Iconsax.tick_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      bp.suggestion,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.green.shade900,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _renderMetricItem(
      BuildContext context, AppLocalizations l10n, String title, int score) {
    final color = _getScoreColor(context, score);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              '$score/100',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: score / 100,
          color: color,
          minHeight: 8,
          backgroundColor:
              Theme.of(context).colorScheme.onSurface.withAlpha(15),
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
      ],
    );
  }
}
