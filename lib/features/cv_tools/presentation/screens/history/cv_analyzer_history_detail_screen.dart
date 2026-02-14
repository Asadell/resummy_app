import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis_entity.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_history_entity.dart';

@RoutePage()
class CvAnalyzerHistoryDetailScreen extends StatelessWidget {
  final CvAnalysisHistory history;

  const CvAnalyzerHistoryDetailScreen({
    super.key,
    required this.history,
  });

  Color _getScoreColor(BuildContext context, int score) {
    if (score >= CvAnalysisGradeThresholds.excellent) {
      return Colors.green;
    } else if (score >= CvAnalysisGradeThresholds.good) {
      return Colors.blue;
    } else if (score >= CvAnalysisGradeThresholds.fair) {
      return Colors.orange;
    } else {
      return Theme.of(context).colorScheme.error;
    }
  }

  Map<String, dynamic>? get _analysisData => history.analysisData;

  int get _keywordMatch => _analysisData?['metrics']?['keywordMatch'] ?? 0;
  int get _quantifiableAchievements =>
      _analysisData?['metrics']?['quantifiableAchievements'] ?? 0;
  int get _structureCompleteness =>
      _analysisData?['metrics']?['structureCompleteness'] ?? 0;
  int get _languageProfessionalism =>
      _analysisData?['metrics']?['languageProfessionalism'] ?? 0;

  List<String> get _missingKeywords =>
      (_analysisData?['missingKeywords'] as List?)?.cast<String>() ?? [];

  List<Map<String, dynamic>> get _weakBulletPoints =>
      (_analysisData?['weakBulletPoints'] as List?)
          ?.cast<Map<String, dynamic>>() ??
      [];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.analysisResult),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Score card
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
                        '${history.score}/100',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(
                              color: _getScoreColor(context, history.score),
                              fontSize: 40,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        history.grade,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                                color: _getScoreColor(context, history.score),
                                fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Metrics detail card
              if (_analysisData != null) ...[
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
                          _keywordMatch,
                        ),
                        const SizedBox(height: 12),
                        _renderMetricItem(
                          context,
                          l10n,
                          l10n.quantifiableAchievements,
                          _quantifiableAchievements,
                        ),
                        const SizedBox(height: 12),
                        _renderMetricItem(
                          context,
                          l10n,
                          l10n.structureCompleteness,
                          _structureCompleteness,
                        ),
                        const SizedBox(height: 12),
                        _renderMetricItem(
                          context,
                          l10n,
                          l10n.languageProfessionalism,
                          _languageProfessionalism,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Missing Keywords
                if (_missingKeywords.isNotEmpty)
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
                            runSpacing: 8,
                            children: _missingKeywords
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
                                .toList(),
                          )
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                // Suggestion bullet points
                if (_weakBulletPoints.isNotEmpty) ...[
                  Text(
                    l10n.improvementSuggestions,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ..._weakBulletPoints.map(
                    (bp) => _renderWeakPointsCard(bp, context),
                  ),
                ],
              ],
              // Summary feedback
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
                        history.summary,
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
    );
  }

  Card _renderWeakPointsCard(
      Map<String, dynamic> bp, BuildContext context) {
    final chipColors = {
      'High': Colors.red,
      'Medium': Colors.orange,
      'Low': Colors.green,
    };

    final priority = bp['priority'] as String;
    final title = bp['title'] as String;
    final original = bp['original'] as String;
    final suggestion = bp['suggestion'] as String;

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
                    title,
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
                    priority,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: chipColors[priority],
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  backgroundColor: chipColors[priority]?.withAlpha(30),
                  side: BorderSide(
                    color: chipColors[priority]!,
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
                      original,
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
                      suggestion,
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
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
      ],
    );
  }
}
