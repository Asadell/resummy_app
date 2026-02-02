import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';

@RoutePage()
class CvTranslatorLoadingScreen extends StatefulWidget {
  const CvTranslatorLoadingScreen({super.key});

  @override
  State<CvTranslatorLoadingScreen> createState() => _CvTranslatorLoadingScreenState();
}

class _CvTranslatorLoadingScreenState extends State<CvTranslatorLoadingScreen> {
  @override
  void initState() {
    super.initState();
    _startTranslation();
  }

  Future<void> _startTranslation() async {
    // Simulate translation process (20-30 seconds)
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      context.router.push(const CvTranslatorReviewRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Language icons animation
                const Text(
                  '🇮🇩 ↔️ 🇬🇧',
                  style: TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 32),
                
                // Title
                Text(
                  'Menerjemahkan CV... ⏳',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  'ID → EN',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 40),
                
                // Progress indicator
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                
                // Estimate
                Text(
                  'Estimasi: 20-30 detik',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 48),
                
                // Info card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tips: Setelah selesai, Anda bisa review dan edit hasil terjemahan sebelum download.',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
