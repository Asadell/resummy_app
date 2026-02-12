import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';
import 'dart:math' as math;

@RoutePage()
class InterviewFeedbackDetailScreen extends StatefulWidget {
  const InterviewFeedbackDetailScreen({super.key});

  @override
  State<InterviewFeedbackDetailScreen> createState() => _InterviewFeedbackDetailScreenState();
}

class _InterviewFeedbackDetailScreenState extends State<InterviewFeedbackDetailScreen> {
  int _currentQuestion = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      appBar: AppBar(
        title: Text('Pertanyaan $_currentQuestion dari 5'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.push(const InterviewFeedbackQuestionsRoute()),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.headphones),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Question Header
              Container(
                padding: const EdgeInsets.all(20),
                color: Theme.of(context).cardTheme.color,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Question $_currentQuestion/5',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '💬 Ceritakan pengalaman Anda saat memimpin sebuah project yang challenging dan bagaimana Anda mengatasinya.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '⏱ Jawaban Anda: 2m 15s',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // STAR Analysis
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
                        Text(
                          '📊 Analisis Struktur STAR',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '8.5/10',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // Situation - Excellent
                    _buildStarComponent(
                      context,
                      '✅ Situation - Excellent',
                      AppColors.secondary,
                      const Color(0xFFF0FDF4),
                      'Saya bekerja di project mobile app dengan deadline yang sangat ketat. Tim kami hanya 3 orang dan harus deliver frontend dan backend dalam 6 minggu.',
                      null,
                    ),

                    const SizedBox(height: 16),

                    // Task - Baik
                    _buildStarComponent(
                      context,
                      '✅ Task - Baik',
                      AppColors.primary,
                      AppColors.primary100,
                      'Saya harus deliver backend API dan coordinate dengan frontend developer sambil ensure quality tetap terjaga.',
                      null,
                    ),

                    const SizedBox(height: 16),

                    // Action - Excellent
                    _buildStarComponent(
                      context,
                      '✅ Action - Excellent',
                      AppColors.secondary,
                      const Color(0xFFF0FDF4),
                      'Saya reorganisasi sprint planning, implement daily standups yang lebih fokus, dan create shared documentation untuk reduce miscommunication.',
                      null,
                    ),

                    const SizedBox(height: 16),

                    // Result - Lemah
                    _buildStarComponent(
                      context,
                      '⚠️ Result - Lemah (Perlu ditingkatkan)',
                      AppColors.warning,
                      const Color(0xFFFEF3C7),
                      'Kami selesaikan project tepat waktu.',
                      '💡 Saran: Tambahkan hasil spesifik dengan metrik: "Kami launching 2 minggu lebih cepat, kurangi bug 40%, klien perpanjang kontrak untuk Phase 2."',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Fluency Analysis
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
                        Text(
                          '🎤 Analisis Kelancaran',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '6.0/10',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.warning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // Speed Metrics
                    Text(
                      'Kecepatan Bicara',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Kata per menit: 145 WPM ✓ Baik',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Suku kata/menit: 218 SPM',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Speaking Pace Chart
                    Text(
                      'Kecepatan Bicara Seiring Waktu:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomPaint(
                      size: const Size(double.infinity, 120),
                      painter: _SpeakingPaceChartPainter(
                        lineColor: Theme.of(context).colorScheme.primary,
                        gridColor: Theme.of(context).dividerTheme.color ?? AppColors.gray200,
                        textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Filler Words
                    Text(
                      'Filler Words (⚠️ Terlalu banyak!)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFillerWordBar('um/uh', 12, 5.3),
                    const SizedBox(height: 8),
                    _buildFillerWordBar('jadi', 8, 3.5),
                    const SizedBox(height: 8),
                    _buildFillerWordBar('seperti', 6, 2.6),
                    const SizedBox(height: 8),
                    _buildFillerWordBar('ya', 5, 2.2),
                    const SizedBox(height: 12),
                    Text(
                      'Total filler → 13.6% (Target: <5%) ❌',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Pause Analysis
                    Text(
                      'Jeda & Keraguan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Jeda panjang (>2s): 4 kali',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rata-rata jeda: 1.2s ✓',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Pause timeline
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Text('0s ', style: TextStyle(fontSize: 11)),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text('━━━', style: TextStyle(color: AppColors.primary)),
                                const Text('⏸(2.1s)', style: TextStyle(fontSize: 10, color: AppColors.error)),
                                const Text('━━━━', style: TextStyle(color: AppColors.primary)),
                                const Text('⏸(2.5s)', style: TextStyle(fontSize: 10, color: AppColors.error)),
                                const Text('━━', style: TextStyle(color: AppColors.primary)),
                                const Text('⏸(3.2s)', style: TextStyle(fontSize: 10, color: AppColors.error)),
                              ],
                            ),
                          ),
                          const Text(' 2m15s', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Before/After Comparison
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
                    Text(
                      '✨ Ucapan Anda vs Ucapan Ditingkatkan',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Original
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Ucapan Asli Anda',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF991B1B),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '→',
                                style: TextStyle(color: Color(0xFF991B1B)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF7F1D1D),
                                height: 1.6,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Um',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFFEF4444),
                                    decorationThickness: 2,
                                  ),
                                ),
                                const TextSpan(text: ', jadi saya waktu itu, '),
                                const TextSpan(
                                  text: 'jadi',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFFEF4444),
                                    decorationThickness: 2,
                                  ),
                                ),
                                const TextSpan(text: ', kerja di project mobile app ini, '),
                                const TextSpan(
                                  text: 'uh',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFFEF4444),
                                    decorationThickness: 2,
                                  ),
                                ),
                                const TextSpan(text: ', dan kami punya deadline yang '),
                                const TextSpan(
                                  text: 'kayak',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFFEF4444),
                                    decorationThickness: 2,
                                  ),
                                ),
                                const TextSpan(text: ' sangat ketat...'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Filler: 13.6% | WPM: 145',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF991B1B),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Improved
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                '✨ Ucapan Ditingkatkan',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF065F46),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Saya bekerja di project mobile app dengan deadline yang sangat ketat. Tim kami hanya tiga orang dan kami harus membangun frontend dan backend dalam waktu enam minggu.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF065F46),
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Filler: 0% | WPM: 155',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF065F46),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Text('🔊', style: TextStyle(fontSize: 18)),
                            label: const Text('Dengar Versi Ditingkatkan'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Tips Pro
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '💡 Tips Pro:',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.primary700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildTipItem('Latih jawaban lagi, fokus hilangkan "um/uh"'),
                          const SizedBox(height: 4),
                          _buildTipItem('Boleh jeda diam dibanding filler'),
                          const SizedBox(height: 4),
                          _buildTipItem('Rekam diri & bandingkan'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Content Quality
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
                        Text(
                          '📝 Analisis Kualitas Konten',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '7.5/10',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _buildMetricRow('Relevansi', 'Excellent', AppColors.secondary),
                    const SizedBox(height: 12),
                    _buildMetricRow('Kedalaman', 'Baik', AppColors.secondary),
                    const SizedBox(height: 12),
                    _buildMetricRow('Dampak', 'Bisa lebih kuat', AppColors.warning),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Confidence
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
                        Text(
                          '😊 Percaya Diri & Kehadiran',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '7.0/10',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _buildMetricRow('Tone & Energi', 'Positif', AppColors.secondary),
                    const SizedBox(height: 12),
                    _buildMetricRow('Pace & Ritme', 'Konsisten', AppColors.secondary),
                    const SizedBox(height: 12),
                    _buildMetricRow('Keyakinan', 'Agak ragu-ragu', AppColors.warning),
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
                    color: Theme.of(context).brightness == Brightness.light ? Colors.black.withOpacity(0.05) : Colors.transparent,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _currentQuestion > 1
                      ? () {
                          setState(() => _currentQuestion--);
                        }
                      : null,
                  child: const Text('⏮ Sebelumnya'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Latihan Lagi'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: _currentQuestion < 5
                      ? () {
                          setState(() => _currentQuestion++);
                        }
                      : null,
                  child: const Text('Selanjutnya ⏭'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarComponent(
    BuildContext context,
    String title,
    Color borderColor,
    Color bgColor,
    String quote,
    String? suggestion,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: borderColor == AppColors.secondary
                  ? const Color(0xFF065F46)
                  : borderColor == AppColors.primary
                      ? const Color(0xFF0369A1)
                      : const Color(0xFF78350F),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: borderColor == AppColors.secondary
                  ? const Color(0xFFD1FAE5)
                  : borderColor == AppColors.primary
                      ? const Color(0xFFBAE6FD)
                      : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '"$quote"',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: borderColor == AppColors.secondary
                    ? const Color(0xFF065F46)
                    : borderColor == AppColors.primary
                        ? const Color(0xFF075985)
                        : const Color(0xFF78350F),
              ),
            ),
          ),
          if (suggestion != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                border: Border.all(color: borderColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saran:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: borderColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          suggestion,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF92400E),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFillerWordBar(String word, int count, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '"$word"',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              '${count}x (${percentage.toStringAsFixed(1)}%)',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 6,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.warning),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        Row(
          children: [
            Icon(
              valueColor == AppColors.secondary ? Icons.check_circle : Icons.warning,
              size: 16,
              color: valueColor,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: valueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(fontSize: 12, color: AppColors.primary800),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: AppColors.primary800),
          ),
        ),
      ],
    );
  }
}

class _SpeakingPaceChartPainter extends CustomPainter {
  final Color lineColor;
  final Color gridColor;
  final Color textColor;

  _SpeakingPaceChartPainter({
    required this.lineColor,
    required this.gridColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Simulate speaking pace data
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.5),
      Offset(size.width * 0.3, size.height * 0.3),
      Offset(size.width * 0.45, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.35),
      Offset(size.width * 0.75, size.height * 0.5),
      Offset(size.width * 0.9, size.height * 0.6),
      Offset(size.width, size.height * 0.7),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (var point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }

    canvas.drawPath(path, paint);

    // Draw grid lines
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final labels = ['200', '180', '160', '140', '120'];
    for (int i = 0; i < labels.length; i++) {
      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(fontSize: 10, color: textColor),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-30, size.height * i / 4 - 5));
    }

    // X-axis labels
    final timeLabels = ['0s', '30s', '60s', '90s', '120s'];
    for (int i = 0; i < timeLabels.length; i++) {
      textPainter.text = TextSpan(
        text: timeLabels[i],
        style: TextStyle(fontSize: 10, color: textColor),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(size.width * i / 4 - 10, size.height + 5));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}