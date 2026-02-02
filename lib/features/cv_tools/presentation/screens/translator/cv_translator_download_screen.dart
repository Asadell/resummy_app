import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/app/routes/app_router.gr.dart';

@RoutePage()
class CvTranslatorDownloadScreen extends StatelessWidget {
  const CvTranslatorDownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download CV'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.router.push(const CvToolsHubRoute()),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
                      SizedBox(height: 16),
                      Text('Translation Complete!'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading PDF...')),
                  );
                },
                child: const Text('Download PDF'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => context.router.push(const CvAnalyzerLoadingRoute()),
                child: const Text('Analisis CV'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.router.push(const HomeRoute()),
                child: const Text('Kembali ke Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
