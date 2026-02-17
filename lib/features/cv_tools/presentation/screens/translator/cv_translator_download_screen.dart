import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class CvTranslatorDownloadScreen extends StatelessWidget {
  const CvTranslatorDownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.downloadPdf),
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
               Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
                      const SizedBox(height: 16),
                      Text(l10n.translationComplete),
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
                    SnackBar(content: Text(l10n.downloadingPdf)),
                  );
                },
                child: Text(l10n.downloadPdf),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => context.router.push(const CvAnalyzerUploadRoute()),
                child: Text(l10n.analyzeCv),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.router.push(const HomeRoute()),
                child: Text(l10n.backToDashboard),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
