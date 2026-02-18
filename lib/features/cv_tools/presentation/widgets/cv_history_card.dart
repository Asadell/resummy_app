import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';

class CvHistoryCard extends StatelessWidget {
  final CVData cv;
  final int index;

  const CvHistoryCard({
    super.key,
    required this.cv,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final date = '${cv.updatedAt.day}/${cv.updatedAt.month}/${cv.updatedAt.year}';

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getSourceColor(context, cv.source).withValues(alpha: 0.1),
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
          '${_getSourceLabel(l10n, cv.source)} • ${l10n.updatedOnDate(date)}',
        ),
        trailing: IconButton(
          icon: const Icon(Iconsax.edit),
          onPressed: () => _openCvBuilder(context),
        ),
        onTap: () => _openCvBuilder(context),
      ),
    );
  }

  Future<void> _openCvBuilder(BuildContext context) async {
    final provider = context.read<CVBuilderProvider>();
    await provider.loadCV(cv.id);
    if (context.mounted) {
      context.router.push(const CvBuilderStep1Route());
    }
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
