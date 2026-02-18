import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
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
                  children: [
                    _FeatureCard(
                      icon: Iconsax.document_text,
                      title: l10n.cvBuilder,
                      description: l10n.cvBuilderDesc,
                      color: Theme.of(context).colorScheme.primary,
                      onTap: () => context.router
                          .push(const CvBuilderWelcomeRoute()),
                    ),
                    const SizedBox(height: AppSizes.md),
                    _FeatureCard(
                      icon: Iconsax.chart_2,
                      title: l10n.cvAnalyzer,
                      description: l10n.cvAnalyzerDesc,
                      color: Theme.of(context).colorScheme.secondary,
                      onTap: () => context.router
                          .push(const CvAnalyzerUploadRoute()),
                    ),
                    const SizedBox(height: AppSizes.md),
                    _FeatureCard(
                      icon: Iconsax.magic_star,
                      title: l10n.convertToCvAts,
                      description: l10n.uploadOldCvDesc,
                      color: Colors.purple,
                      onTap: () =>
                          context.router.push(const CvAtsConverterRoute()),
                    ),
                    const SizedBox(height: AppSizes.md),
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
                  children: [
                    Text(
                      l10n.myCvs,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppSizes.md),
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

                                final date =
                                    '${cv.updatedAt.day}/${cv.updatedAt.month}/${cv.updatedAt.year}';

                                return Dismissible(
                                  key: Key(cv.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    color: Colors.red,
                                    child: const Icon(Iconsax.trash,
                                        color: Colors.white),
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
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(24)),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Center(
                                                child: Container(
                                                  width: 40,
                                                  height: 4,
                                                  margin: const EdgeInsets.only(
                                                      bottom: 24),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(2),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .errorContainer,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Icon(
                                                      Iconsax.trash,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .error,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Text(
                                                      l10n.confirmation,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                l10n.deleteCvConfirmation,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                                      height: 1.5,
                                                    ),
                                              ),
                                              const SizedBox(height: 32),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      style:
                                                          OutlinedButton.styleFrom(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 16),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      child: Text(l10n.cancel
                                                          .toUpperCase()),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    flex: 2,
                                                    child: FilledButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      style:
                                                          FilledButton.styleFrom(
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .error,
                                                        foregroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .onError,
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 16),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                      ),
                                                      child: Text(l10n.delete
                                                          .toUpperCase()),
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
                                        backgroundColor:
                                            _getSourceColor(context, cv.source)
                                                .withValues(alpha: 0.1),
                                        child: Icon(
                                          _getSourceIcon(cv.source),
                                          color: _getSourceColor(
                                              context, cv.source),
                                        ),
                                      ),
                                      title: Text(
                                        cv.name.isNotEmpty
                                            ? cv.name
                                            : l10n.cvNumber(index + 1),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(
                                          '${_getSourceLabel(l10n, cv.source)} • ${l10n.updatedOnDate(date)}'),
                                      trailing: IconButton(
                                        icon: const Icon(Iconsax.edit),
                                        onPressed: () async {
                                          await provider.loadCV(cv.id);
                                          if (mounted) {
                                            // ignore: use_build_context_synchronously
                                            this
                                                .context
                                                .router
                                                .push(const CvBuilderStep1Route());
                                          }
                                        },
                                      ),
                                      onTap: () async {
                                        await provider.loadCV(cv.id);
                                        if (mounted) {
                                          // ignore: use_build_context_synchronously
                                          this
                                              .context
                                              .router
                                              .push(const CvBuilderStep1Route());
                                        }
                                      },
                                    ),
                                  ),
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

  IconData _getSourceIcon(String source) {
    switch (source) {
      case 'builder':
        return Iconsax.document_text;
      case 'ats_converter':
        return Iconsax.magic_star;
      case 'analyzer':
        return Iconsax.chart_2;
      default:
        return Iconsax.document_text;
    }
  }

  Color _getSourceColor(BuildContext context, String source) {
    switch (source) {
      case 'builder':
        return Theme.of(context).colorScheme.primary;
      case 'ats_converter':
        return Colors.purple;
      case 'analyzer':
        return Colors.green;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  String _getSourceLabel(AppLocalizations l10n, String source) {
    switch (source) {
      case 'builder':
        return l10n.cvSourceBuilder;
      case 'ats_converter':
        return l10n.cvSourceAtsConverter;
      case 'analyzer':
        return l10n.cvSourceAnalyzer;
      default:
        return l10n.cvSourceBuilder;
    }
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
