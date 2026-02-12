import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';

@RoutePage()
class InterviewFeedbackRecommendationsScreen extends StatelessWidget {
  const InterviewFeedbackRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () => context.router.push(const InterviewFeedbackOverviewRoute()),
        ),
        title: Row(
          children: [
            Icon(Iconsax.lamp_on, color: Theme.of(context).colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            const Text('Rekomendasi'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.document_download),
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
                  Icon(Iconsax.lamp_on, color: Theme.of(context).colorScheme.primary, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    'Rekomendasi',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Berdasarkan performa interview Anda',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              // Strengths Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  border: const Border(
                    left: BorderSide(color: AppColors.secondary, width: 4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Iconsax.weight, color: Theme.of(context).colorScheme.secondary, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'Kekuatan Kamu',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildListItem(context, '✓ Struktur STAR excellent (avg 8.0)', Theme.of(context).colorScheme.onSurface),
                    const SizedBox(height: 10),
                    _buildListItem(context, '✓ Kecepatan bicara baik (145 WPM)', Theme.of(context).colorScheme.onSurface),
                    const SizedBox(height: 10),
                    _buildListItem(context, '✓ Konten relevan dan detail', Theme.of(context).colorScheme.onSurface),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Improvements Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  border: const Border(
                    left: BorderSide(color: AppColors.warning, width: 4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Iconsax.direct_up, color: Theme.of(context).colorScheme.error, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'Area untuk Ditingkatkan',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildListItem(context, '⚠️ Kurangi filler words 13.6% → <5%', Theme.of(context).colorScheme.onSurface),
                    const SizedBox(height: 10),
                    _buildListItem(context, '⚠️ Perkuat "Result" dengan metrik', Theme.of(context).colorScheme.onSurface),
                    const SizedBox(height: 10),
                    _buildListItem(context, '⚠️ Pertanyaan 5 struktur STAR lemah', Theme.of(context).colorScheme.onSurface),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Practice Recommendations
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
                        Icon(Iconsax.book, color: Theme.of(context).colorScheme.primary, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'Latihan Terpilih',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildPracticeItem(
                      context,
                      1,
                      'Ulangi Q1 fokus hilangkan filler',
                      'Latihan Q1 →',
                    ),
                    const SizedBox(height: 12),
                    _buildPracticeItem(
                      context,
                      2,
                      'Latihan Q5 dengan STAR lebih baik',
                      'Latihan Q5 →',
                    ),
                    const SizedBox(height: 12),
                    _buildPracticeItem(
                      context,
                      3,
                      'Siapkan 3 cerita Result yang kuat',
                      'Pelajari Tips →',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Readiness Assessment
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.secondary, Color(0xFF34D399)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Iconsax.tick_circle, size: 40, color: Theme.of(context).colorScheme.onSecondary),
                    const SizedBox(height: 12),
                    const Text(
                      'Siap untuk Interview?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Berdasarkan skor 7.5/10, kamu SIAP:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildReadinessItem('✓ Posisi Junior-Mid level'),
                    const SizedBox(height: 10),
                    _buildReadinessItem('✓ Lingkungan startup (fast-paced)'),
                    const SizedBox(height: 10),
                    _buildReadinessItem('⚠️ Senior roles - tambah metrik & dampak', opacity: 0.8),
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
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Iconsax.refresh),
                label: const Text('Latihan Lagi'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.email),
                label: const Text('📧 Email Laporan'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => context.router.push(const InterviewPrepRoute()),
                icon: const Icon(Icons.home),
                label: const Text('🏠 Dashboard'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.gray600,
                  side: const BorderSide(color: AppColors.gray300),
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPracticeItem(BuildContext context, int number, String title, String buttonText) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {},
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReadinessItem(String text, {double opacity = 1.0}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(opacity),
            ),
          ),
        ),
      ],
    );
  }
}