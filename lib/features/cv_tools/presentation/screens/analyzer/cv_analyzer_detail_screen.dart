import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/app/routes/app_router.gr.dart';

@RoutePage()
class CvAnalyzerDetailScreen extends StatelessWidget {
  const CvAnalyzerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.push(const CvAnalyzerResultRoute()),
        ),
      ),
      body: SafeArea(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Detailed Analysis',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'This screen is under construction',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      ),
    );
  }
}
