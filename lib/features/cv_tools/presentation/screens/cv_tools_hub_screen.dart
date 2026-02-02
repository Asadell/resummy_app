import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class CvToolsHubScreen extends StatelessWidget {
  const CvToolsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cvTools),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // CV Analyzer
              _FeatureCard(
                icon: Iconsax.chart_2,
                title: l10n.cvAnalyzer,
                description: l10n.cvAnalyzerDesc,
                color: Theme.of(context).colorScheme.secondary,
                onTap: () => context.router.push(const CvAnalyzerUploadRoute()),
              ),
              const SizedBox(height: 16),
              
              // CV Builder
              _FeatureCard(
                icon: Iconsax.document_text,
                title: l10n.cvBuilder,
                description: l10n.cvBuilderDesc,
                color: Theme.of(context).colorScheme.primary,
                onTap: () => context.router.push(const CvBuilderWelcomeRoute()),
              ),
              const SizedBox(height: 16),
              
              // CV Translator
              _FeatureCard(
                icon: Iconsax.translate,
                title: l10n.cvTranslator,
                description: l10n.cvTranslatorDesc,
                color: Colors.orange,
                onTap: () => context.router.push(const CvTranslatorUploadRoute()),
              ),
              const SizedBox(height: 16),
              
              // CV History
              _FeatureCard(
                icon: Iconsax.clock,
                title: l10n.cvHistory,
                description: l10n.cvHistoryDesc,
                color: Theme.of(context).colorScheme.tertiary,
                onTap: () => context.router.push(const CvHistoryRoute()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                Iconsax.arrow_right_3,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
