import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';

@RoutePage()
class InterviewSessionClosingScreen extends StatefulWidget {
  const InterviewSessionClosingScreen({super.key});

  @override
  State<InterviewSessionClosingScreen> createState() => _InterviewSessionClosingScreenState();
}

class _InterviewSessionClosingScreenState extends State<InterviewSessionClosingScreen> {
  double _progress = 0.0;
  int _currentStep = 0;

  final List<String> _steps = [
    'Analyzing answers',
    'Evaluating STAR structure',
    'Calculating fluency score',
    'Generating recommendations',
  ];

  @override
  void initState() {
    super.initState();
    _simulateProgress();
  }

  void _simulateProgress() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() {
          _currentStep = i + 1;
          _progress = (i + 1) / _steps.length;
        });
      }
    }
    
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      context.router.push(const InterviewFeedbackOverviewRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {},
        ),
        title: const Text(
          'Interview Completed! 🎉',
          style: TextStyle(color: AppColors.secondary),
        ),
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
                    child: const Text('🏆', style: TextStyle(fontSize: 100)),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                'Interview Completed!',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Kerja bagus, John!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Stats Card
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
                      '📊 Session Summary:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem('⏱️', 'Total Duration', '14:32'),
                        ),
                        Expanded(
                          child: _buildStatItem('❓', 'Questions', '5 answered'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem('💬', 'Words spoken', '~1,250'),
                        ),
                        Expanded(
                          child: _buildStatItem('🎯', 'Follow-ups', '2'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

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
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryLight],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Terima kasih banyak, John. Anda akan mendapat feedback detail dalam beberapa saat.',
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
              Text(
                'Generating feedback... ⏳',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 8,
                  backgroundColor: AppColors.gray200,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                '${(_progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
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
                  children: List.generate(_steps.length, (index) {
                    final isDone = index < _currentStep;
                    final isInProgress = index == _currentStep;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          if (isDone)
                            const Icon(Icons.check_circle, color: AppColors.secondary, size: 20)
                          else if (isInProgress)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                              ),
                            )
                          else
                            Icon(Icons.circle_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3), size: 20),
                          const SizedBox(width: 12),
                          Text(
                            _steps[index],
                            style: TextStyle(
                              color: isDone
                                  ? AppColors.secondary700
                                  : isInProgress
                                      ? AppColors.primary
                                      : AppColors.gray300,
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
                'Estimasi: 15-20 detik',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String icon, String label, String value) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}