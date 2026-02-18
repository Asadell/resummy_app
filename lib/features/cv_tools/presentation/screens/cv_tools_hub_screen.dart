import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_card.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';

@RoutePage()
class CvToolsHubScreen extends StatefulWidget {
  const CvToolsHubScreen({super.key});

  @override
  State<CvToolsHubScreen> createState() => _CvToolsHubScreenState();
}

class _CvToolsHubScreenState extends State<CvToolsHubScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CVBuilderProvider>().loadAllCVs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.cvTools),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSection(
                child: Column(
                  spacing: AppSizes.md,
                  children: [
                    _FeatureCard(
                      icon: Iconsax.document_text,
                      title: l10n.cvBuilder,
                      description: l10n.cvBuilderDesc,
                      color: Theme.of(context).colorScheme.primary,
                      onTap: () => context.router
                          .push(const CvBuilderWelcomeRoute()),
                    ),
                    _FeatureCard(
                      icon: Iconsax.chart_2,
                      title: l10n.cvAnalyzer,
                      description: l10n.cvAnalyzerDesc,
                      color: Theme.of(context).colorScheme.secondary,
                      onTap: () => context.router
                          .push(const CvAnalyzerUploadRoute()),
                    ),
                    _FeatureCard(
                      icon: Iconsax.magic_star,
                      title: l10n.convertToCvAts,
                      description: l10n.uploadOldCvDesc,
                      color: Colors.purple,
                      onTap: () =>
                          context.router.push(const CvAtsConverterRoute()),
                    ),
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
              const SizedBox(height: AppSizes.sm),
              AppSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSizes.md,
                  children: [
                    Text(
                      l10n.myCvs,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Consumer<CVBuilderProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading &&
                            provider.savedCVs.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (provider.savedCVs.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(AppSizes.xl),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.withValues(alpha: 0.2)),
                            ),
                            child: Column(
                              children: [
                                Icon(Iconsax.folder_open,
                                    size: 48, color: Colors.grey[400]),
                                const SizedBox(height: AppSizes.md),
                                Text(
                                  l10n.noSavedCvs,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                                const SizedBox(height: AppSizes.md),
                                OutlinedButton.icon(
                                  onPressed: () => context.router
                                      .push(const CvBuilderWelcomeRoute()),
                                  icon: const Icon(Iconsax.add),
                                  label: Text(l10n.startCreatingCv),
                                ),
                              ],
                            ),
                          );
                        }

                        return Stack(
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.savedCVs.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: AppSizes.md),
                              itemBuilder: (context, index) {
                                final cv = provider.savedCVs[index];


                                return CVCard(
                                  cv: cv,
                                  index: index,
                                );
                              },
                            ),
                            if (provider.isLoading)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
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
