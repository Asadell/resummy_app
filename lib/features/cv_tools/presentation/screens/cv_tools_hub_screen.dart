import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/app/routes/app_router.gr.dart';

@RoutePage()
class CvToolsHubScreen extends StatelessWidget {
  const CvToolsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CV Tools'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // CV Analyzer
              _FeatureCard(
                icon: Icons.analytics,
                title: 'CV Analyzer',
                description: 'Get AI-powered feedback on your CV',
                color: Theme.of(context).colorScheme.secondary,
                onTap: () => context.router.push(const CvAnalyzerUploadRoute()),
              ),
              const SizedBox(height: 16),
              
              // CV Builder
              _FeatureCard(
                icon: Icons.edit_document,
                title: 'CV Builder',
                description: 'Build your CV step by step with AI assistance',
                color: Theme.of(context).colorScheme.primary,
                onTap: () => context.router.push(const CvBuilderWelcomeRoute()),
              ),
              const SizedBox(height: 16),
              
              // CV Translator
              _FeatureCard(
                icon: Icons.translate,
                title: 'CV Translator',
                description: 'Translate your CV to multiple languages',
                color: Colors.orange,
                onTap: () => context.router.push(const CvTranslatorUploadRoute()),
              ),
              const SizedBox(height: 16),
              
              // CV History
              _FeatureCard(
                icon: Icons.history,
                title: 'CV History',
                description: 'View and manage all your CVs',
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
                Icons.arrow_forward_ios,
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
