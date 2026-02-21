import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';

class CVCard extends StatelessWidget {
  final CVData cv;
  final int index;

  const CVCard({super.key, required this.cv, required this.index});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final date =
        '${cv.updatedAt.day}/${cv.updatedAt.month}/${cv.updatedAt.year}';
    final provider = context.read<CVBuilderProvider>();

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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
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
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
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
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            foregroundColor:
                                Theme.of(context).colorScheme.onError,
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
            backgroundColor:
                _getSourceColor(context, cv.source).withValues(alpha: 0.1),
            child: Icon(
              _getSourceIcon(cv.source),
              color: _getSourceColor(context, cv.source),
            ),
          ),
          title: Text(
            cv.name.isNotEmpty ? cv.name : l10n.cvNumber(index + 1),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${_getSourceLabel(l10n, cv.source)} • $date',
          ),
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
