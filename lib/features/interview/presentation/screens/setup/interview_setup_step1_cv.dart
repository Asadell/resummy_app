import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';

@RoutePage()
class InterviewSetupStep1Screen extends StatefulWidget {
  const InterviewSetupStep1Screen({super.key});

  @override
  State<InterviewSetupStep1Screen> createState() => _InterviewSetupStep1ScreenState();
}

class _InterviewSetupStep1ScreenState extends State<InterviewSetupStep1Screen> {
  int _selectedCvIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      appBar: AppBar(
        title: const Text('🎤 AI Interview Simulator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.push(const InterviewPrepRoute()),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Section
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
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
                  children: [
                    const Text(
                      '🎤',
                      style: TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'AI Interview Simulator',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Latihan interview dengan AI yang disesuaikan dengan CV dan role Anda',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Info Cards
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📝 Format Interview:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.5,
                      children: [
                        _buildInfoChip('Durasi: ±15 menit'),
                        _buildInfoChip('Pertanyaan: 5 soal'),
                        _buildInfoChip('Bahasa: ID / EN'),
                        _buildInfoChip('Method: STAR-based'),
                      ],
                    ),
                  ],
                ),
              ),

              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Step 1: Pilih CV Anda',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
              ),

              // CV Selection
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildCvOption(
                      index: 0,
                      filename: 'CV_Software_Engineer.pdf',
                      score: 78,
                    ),
                    const SizedBox(height: 12),
                    _buildCvOption(
                      index: 1,
                      filename: 'CV_Product_Manager.pdf',
                      score: 85,
                    ),
                    const SizedBox(height: 12),
                    _buildUploadOption(),
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
            onPressed: () => context.router.push(const InterviewSetupStep2Route()),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: const Text('Lanjut →'),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCvOption({required int index, required String filename, required int score}) {
    final isSelected = _selectedCvIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedCvIndex = index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).cardTheme.color,
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerTheme.color!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            const Text('📄', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                filename,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              'Score: $score/100',
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.upload_file, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            '📤 Upload CV Baru',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}