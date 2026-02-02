import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/app/routes/app_router.gr.dart';

@RoutePage()
class CvBuilderPreviewScreen extends StatelessWidget {
  const CvBuilderPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview CV'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.push(const CvBuilderStep7Route()),
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
                      Icon(Icons.file_present, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('PDF Preview Placeholder'),
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
                onPressed: () => context.router.push(const CvAnalyzerLoadingRoute()),
                child: const Text('Analisis CV Ini'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  // TODO: Implement download
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading...')),
                  );
                },
                child: const Text('Download Langsung'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => context.router.push(const CvToolsHubRoute()),
                child: const Text('Simpan sebagai Draft'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.router.push(const CvBuilderStep1Route()),
                child: const Text('Edit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
