import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';
import 'dart:math' as math;

@RoutePage()
class InterviewFeedbackOverviewScreen extends StatelessWidget {
  const InterviewFeedbackOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<InterviewProvider>(
      builder: (context, provider, child) {
        final report = provider.report;
        if (report == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_left_2),
              onPressed: () => context.router.push(const InterviewPrepRoute()),
            ),
            title: Row(
              children: [
                Icon(Iconsax.direct_up, color: Theme.of(context).colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(l10n.interviewResults),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Iconsax.share),
                onPressed: () {},
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Info
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: Theme.of(context).cardTheme.color,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Iconsax.tick_circle, color: Theme.of(context).colorScheme.secondary, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              l10n.interviewFinished,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${l10n.positionLabel} ${provider.role ?? "Software Engineer"}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.gray600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '29 Jan 2026 | ${l10n.durationLabel}: 14:32', // TODO: Add timing to provider
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Band Score Hero
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.bandScore,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Circular Gauge
                        CustomPaint(
                          size: const Size(180, 180),
                          painter: _CircularGaugePainter(
                            value: report.overallScore.toDouble(),
                            maxValue: 100, // Assuming API returns 0-100, wait, API returns 0-100? Entity says int.
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            progressColor: _getScoreColor(context, report.overallScore),
                          ),
                          child: SizedBox(
                            width: 180,
                            height: 180,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    report.overallScore.toString(),
                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '/100',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _getScoreLabel(l10n, report.overallScore),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: _getScoreColor(context, report.overallScore),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          report.overallFeedback,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.gray600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Breakdown Section
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
                            Icon(Iconsax.chart_21, color: Theme.of(context).colorScheme.primary, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              l10n.scoreDetails,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // We need a way to get breakdown scores. For now, let's average the question scores for "Structure" and "Content"
                        // Or we can just list the Strengths and Improvements here?
                        // The design showed breakdowns like "STAR Structure", "Content Quality", etc.
                        // Our current InterviewReport simple has overall score.
                        // Let's create derived metrics or placeholders if the API doesn't give them yet.
                        // Actually, the API prompt asks for "overallScore", "strengths", "improvements", "questionFeedbacks".
                        // Within each questionFeedback, we have "starScore", "fluencyScore".
                        
                        _buildScoreItem(
                          context,
                          l10n.starStructure,
                          _calculateAverageStarScore(report),
                          AppColors.secondary,
                          l10n.excellentStructure, // TODO: generate dynamic label
                        ),
                        const SizedBox(height: 16),
                        _buildScoreItem(
                          context,
                          l10n.fluency,
                          _calculateAverageFluencyScore(report),
                          AppColors.warning,
                          l10n.goodPaceTone, // TODO: generate dynamic label
                        ),
                         const SizedBox(height: 16),
                         Text(l10n.strengths, style: Theme.of(context).textTheme.titleMedium),
                         ...report.strengths.take(2).map((s) => Padding(
                           padding: const EdgeInsets.only(top: 4.0),
                           child: Row(children: [
                             Icon(Iconsax.tick_circle, size: 16, color: Colors.green),
                             const SizedBox(width: 8),
                             Expanded(child: Text(s, style: Theme.of(context).textTheme.bodySmall)),
                           ]),
                         )),
                         
                         const SizedBox(height: 16),
                         Text(l10n.improvements, style: Theme.of(context).textTheme.titleMedium),
                         ...report.improvements.take(2).map((s) => Padding(
                           padding: const EdgeInsets.only(top: 4.0),
                           child: Row(children: [
                             Icon(Iconsax.info_circle, size: 16, color: Colors.orange),
                             const SizedBox(width: 8),
                             Expanded(child: Text(s, style: Theme.of(context).textTheme.bodySmall)),
                           ]),
                         )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action Buttons
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => context.router.push(const InterviewFeedbackQuestionsRoute()),
                          icon: const Icon(Iconsax.document_text, size: 20),
                          label: Text(l10n.viewFullReport),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () => context.router.push(const InterviewFeedbackRecommendationsRoute()),
                          icon: const Icon(Iconsax.lamp_on, size: 20),
                          label: Text(l10n.recommendations),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            side: BorderSide(color: Theme.of(context).colorScheme.primary),
                            foregroundColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                             // Reset for new interview
                             provider.resetInterview();
                             context.router.push(const InterviewPrepRoute());
                          },
                          icon: const Icon(Iconsax.rotate_left, size: 20),
                          label: Text(l10n.startNewInterview), // "Start New Interview"
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
  
  double _calculateAverageStarScore(providerReport) {
    if (providerReport.questionFeedbacks.isEmpty) return 0.0;
    final total = providerReport.questionFeedbacks.fold(0, (sum, q) => sum + q.starAnalysis.score);
    // starScore is 1-10. Let's return as is.
    return total / providerReport.questionFeedbacks.length;
  }

  double _calculateAverageFluencyScore(providerReport) {
     if (providerReport.questionFeedbacks.isEmpty) return 0.0;
    final total = providerReport.questionFeedbacks.fold(0, (sum, q) => sum + q.fluencyAnalysis.score);
    return total / providerReport.questionFeedbacks.length;
  }

  Color _getScoreColor(BuildContext context, int score) {
    if (score >= 80) return Theme.of(context).colorScheme.primary;
    if (score >= 60) return Colors.orange;
    return Theme.of(context).colorScheme.error;
  }
  
  String _getScoreLabel(AppLocalizations l10n, int score) {
    if (score >= 80) return l10n.passGood; // "Excellent"
    if (score >= 60) return l10n.passFair; // "Good" - check l10n keys
    return l10n.fail; // "Needs Improvement"
  }

  Widget _buildScoreItem(BuildContext context, String label, double score, Color color, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${score.toStringAsFixed(1)}/10',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 10,
            minHeight: 8,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color == Theme.of(context).colorScheme.error ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _CircularGaugePainter extends CustomPainter {
  final double value;
  final double maxValue;
  final Color backgroundColor;
  final Color progressColor;

  _CircularGaugePainter({
    required this.value, 
    required this.maxValue,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    
    // Background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 10),
      -math.pi,
      2 * math.pi,
      false,
      backgroundPaint,
    );
    
    // Progress arc
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [progressColor, progressColor.withValues(alpha: 0.6)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;
    
    final sweepAngle = (value / maxValue) * 2 * math.pi;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 10),
      -math.pi,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}