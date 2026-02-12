import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';

@RoutePage()
class InterviewSetupStep4Screen extends StatelessWidget {
  const InterviewSetupStep4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      appBar: AppBar(
        title: const Text('Konfirmasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.push(const InterviewSetupStep4Route()),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Step 5/5',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),

              // Success Icon
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                'Setup Complete',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Siap untuk memulai interview',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.light ? Colors.black.withOpacity(0.05) : Colors.transparent,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interview Summary:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryRow(context, '📄', 'CV:', 'CV_Software_Engineer.pdf'),
                    const SizedBox(height: 12),
                    _buildSummaryRow(context, '🎯', 'Role:', 'Software Engineer'),
                    const SizedBox(height: 12),
                    _buildSummaryRow(context, '🏢', 'Company:', 'PT Tech Startup'),
                    const SizedBox(height: 12),
                    _buildSummaryRow(context, '🌐', 'Language:', 'Bahasa Indonesia'),
                    const SizedBox(height: 12),
                    _buildSummaryRow(context, '❓', 'Questions:', '5 pertanyaan'),
                    const SizedBox(height: 12),
                    _buildSummaryRow(context, '⏱️', 'Duration:', '±15 menit'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // STAR Method Guide
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerTheme.color!,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 STAR Method Guide',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'S - Situation (Konteks)\nT - Task (Tugas/Tanggung jawab)\nA - Action (Aksi yang diambil)\nR - Result (Hasil terukur)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text('Lihat Contoh STAR Method →'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tips Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tips: Berikan jawaban yang spesifik dan terukur. Gunakan angka dan hasil konkret untuk memperkuat cerita Anda.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
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
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () => context.router.push(const InterviewSessionOpeningRoute()),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
            ),
            child: const Text(
              'Mulai Interview Sekarang! →',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              children: [
                TextSpan(
                  text: '$label ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}