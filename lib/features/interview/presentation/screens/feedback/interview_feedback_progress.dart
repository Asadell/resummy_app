import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';

@RoutePage()
class InterviewFeedbackProgressScreen extends StatelessWidget {
  const InterviewFeedbackProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () => context.router.push(const InterviewFeedbackOverviewRoute()),
        ),
        title: Row(
          children: [
            Icon(Iconsax.chart_21, color: Theme.of(context).colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(l10n.yourProgress),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.filter),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Row(
                children: [
                  Icon(Iconsax.chart_21, color: Theme.of(context).colorScheme.primary, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    l10n.yourProgress,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.trackingLast5Sessions,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              // Overall Score Chart
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.scoreHistory,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomPaint(
                      size: const Size(double.infinity, 200),
                      painter: _ProgressChartPainter(
                        lineColor: Theme.of(context).colorScheme.primary,
                        gridColor: Theme.of(context).dividerTheme.color ?? AppColors.gray200,
                        textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Metrics Table
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.metricComparison,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMetricRow(context, l10n.overallScore, '+0.5', true, false),
                    const Divider(height: 24),
                    _buildMetricRow(context, l10n.starStructure, '+1.0', true, true),
                    const Divider(height: 24),
                    _buildMetricRow(context, l10n.fluency, '-0.5', false, false),
                    const Divider(height: 24),
                    _buildMetricRow(context, '${l10n.fillerWordsLabel} %', '+2.1%', false, true),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Insights Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).colorScheme.primaryContainer, Theme.of(context).cardTheme.color!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Iconsax.direct_up, color: Theme.of(context).colorScheme.primary, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      l10n.focusThisWeekFiller,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Filler words Anda meningkat dari 11.5% menjadi 13.6%. Prioritas latihan pengurangan "um/uh" untuk minggu ini.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary800,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(44),
                      ),
                      child: Text('${l10n.viewPracticeTips} →'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Milestone Badges
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
                        Icon(Iconsax.award, color: Theme.of(context).colorScheme.secondary, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          l10n.milestonesReached,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _buildBadge(context, Iconsax.award, l10n.fiveInterviewsCompleted, true, Theme.of(context).colorScheme.secondaryContainer),
                        _buildBadge(context, Iconsax.ranking, l10n.score75FirstTime, true, const Color(0xFFFEF3C7)),
                        _buildBadge(context, Iconsax.lock, l10n.score80, false, Theme.of(context).colorScheme.surfaceContainerHighest),
                        _buildBadge(context, Iconsax.lock, l10n.tenInterviewsCompleted, false, Theme.of(context).colorScheme.surfaceContainerHighest),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Compare Sessions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.compareSessions,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: l10n.session(4),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            items: [l10n.session(1), l10n.session(2), l10n.session(3), l10n.session(4)]
                                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                .toList(),
                            onChanged: (_) {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(l10n.vs, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5))),
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: l10n.session(5),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            items: [l10n.session(5)]
                                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                .toList(),
                            onChanged: (_) {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: Text('${l10n.compare} →'),
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
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Iconsax.chart_1),
            label: Text(l10n.exportReport),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricRow(BuildContext context, String label, String change, bool isPositive, bool isBig) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Row(
          children: [
            Text(
              change,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isPositive
                  ? (isBig ? Iconsax.trend_up : Iconsax.arrow_up_3)
                  : (isBig ? Iconsax.trend_down : Iconsax.arrow_down_1),
              color: isPositive ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.error,
              size: isBig ? 24 : 20,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(BuildContext context, IconData icon, String title, bool unlocked, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          unlocked 
            ? Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary)
            : Icon(Iconsax.lock, size: 24, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: unlocked ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProgressChartPainter extends CustomPainter {
  final Color lineColor;
  final Color gridColor;
  final Color textColor;

  _ProgressChartPainter({
    required this.lineColor,
    required this.gridColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    // Draw grid
    for (int i = 0; i <= 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Data points (scores: 6.0, 6.5, 7.0, 7.3, 7.5)
    final scores = [6.0, 6.5, 7.0, 7.3, 7.5];
    final points = <Offset>[];
    
    for (int i = 0; i < scores.length; i++) {
      final x = size.width * i / (scores.length - 1);
      final y = size.height - (size.height * (scores[i] - 4) / 6); // Scale from 4-10
      points.add(Offset(x, y));
    }

    // Draw line
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      // Highlight last point
      if (i == points.length - 1) {
        canvas.drawCircle(points[i], 8, Paint()..color = Colors.white);
        canvas.drawCircle(points[i], 8, Paint()..color = lineColor..style = PaintingStyle.stroke..strokeWidth = 3);
      } else {
        canvas.drawCircle(points[i], 5, pointPaint);
      }
    }

    // Draw labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    
    // Y-axis labels
    for (int i = 0; i <= 5; i++) {
      final score = 10 - i * 1.2;
      textPainter.text = TextSpan(
        text: score.toStringAsFixed(1),
        style: TextStyle(fontSize: 10, color: textColor),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-35, size.height * i / 5 - 5));
    }

    // X-axis labels
    final sessions = ['#1', '#2', '#3', '#4', '#5\n(hari ini)'];
    for (int i = 0; i < sessions.length; i++) {
      textPainter.text = TextSpan(
        text: sessions[i],
        style: TextStyle(
          fontSize: 10,
          color: i == sessions.length - 1 ? lineColor : textColor,
          fontWeight: i == sessions.length - 1 ? FontWeight.bold : FontWeight.normal,
        ),
      );
      textPainter.layout();
      final x = size.width * i / (sessions.length - 1);
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height + 10));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}