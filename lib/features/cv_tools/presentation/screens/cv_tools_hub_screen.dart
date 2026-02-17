import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';

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
    // Load saved CVs when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CVBuilderProvider>().loadAllCVs();
    });
  }

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
              // Feature Cards
              _FeatureCard(
                icon: Iconsax.document_text,
                title: l10n.cvBuilder,
                description: l10n.cvBuilderDesc,
                color: Theme.of(context).colorScheme.primary,
                onTap: () => context.router.push(const CvBuilderWelcomeRoute()),
              ),
              const SizedBox(height: 16),
              _FeatureCard(
                icon: Iconsax.chart_2,
                title: l10n.cvAnalyzer,
                description: l10n.cvAnalyzerDesc,
                color: Theme.of(context).colorScheme.secondary,
                onTap: () => context.router.push(const CvAnalyzerUploadRoute()),
              ),
              const SizedBox(height: 16),
              _FeatureCard(
                icon: Iconsax.translate,
                title: l10n.cvTranslator,
                description: l10n.cvTranslatorDesc,
                color: Colors.orange,
                onTap: () => context.router.push(const CvTranslatorUploadRoute()),
              ),
              const SizedBox(height: 16),
              _FeatureCard(
                icon: Iconsax.magic_star,
                title: l10n.convertToCvAts,
                description: l10n.uploadOldCvDesc,
                color: Colors.purple,
                onTap: () => context.router.push(const CvAtsConverterRoute()),
              ),
              const SizedBox(height: 16),
              _FeatureCard(
                icon: Iconsax.clock,
                title: l10n.cvHistory,
                description: l10n.cvHistoryDesc,
                color: Theme.of(context).colorScheme.tertiary,
                onTap: () => context.router.push(const CvHistoryRoute()),
              ),
              
              const SizedBox(height: 32),
              
              // Saved CVs Section
              Text(
                l10n.myCvs,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Consumer<CVBuilderProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (provider.savedCVs.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        children: [
                          Icon(Iconsax.folder_open, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            l10n.noSavedCvs,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () => context.router.push(const CvBuilderWelcomeRoute()),
                            icon: const Icon(Iconsax.add),
                            label: Text(l10n.startCreatingCv),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.savedCVs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final cv = provider.savedCVs[index];
                      // Format date: dd/MM/yyyy
                      final date = '${cv.updatedAt.day}/${cv.updatedAt.month}/${cv.updatedAt.year}';
                      
                      return Dismissible(
                        key: Key(cv.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Iconsax.trash, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await showModalBottomSheet<bool>(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return Container(
                                padding: const EdgeInsets.only(
                                  bottom: 32,
                                  top: 8,
                                  left: 24,
                                  right: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 40,
                                        height: 4,
                                        margin: const EdgeInsets.only(bottom: 24),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.errorContainer,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Iconsax.trash,
                                            color: Theme.of(context).colorScheme.error,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            l10n.confirmation,
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      l10n.deleteCvConfirmation,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                            height: 1.5,
                                          ),
                                    ),
                                    const SizedBox(height: 32),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            style: OutlinedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(l10n.cancel.toUpperCase()),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          flex: 2,
                                          child: FilledButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            style: FilledButton.styleFrom(
                                              backgroundColor: Theme.of(context).colorScheme.error,
                                              foregroundColor: Theme.of(context).colorScheme.onError,
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(l10n.delete.toUpperCase()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          provider.deleteCV(cv.id);
                        },
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                              child: Text(
                                cv.template.substring(0, 1).toUpperCase(),
                                style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                            ),
                            title: Text(
                              cv.name.isNotEmpty ? cv.name : l10n.cvNumber(index + 1),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text('${l10n.updatedOnDate(date)} • ${cv.template}'),
                            trailing: IconButton(
                              icon: const Icon(Iconsax.edit),
                              onPressed: () async {
                                await provider.loadCV(cv.id);
                                if (context.mounted) {
                                  context.router.push(const CvBuilderStep1Route());
                                }
                              },
                            ),
                            onTap: () async {
                              await provider.loadCV(cv.id);
                              if (context.mounted) {
                                context.router.push(const CvBuilderStep1Route());
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
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
