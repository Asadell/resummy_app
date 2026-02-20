import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:resummy_app/features/cv_tools/utils/cv_pdf_service.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';

@RoutePage()
class CvBuilderPreviewScreen extends StatefulWidget {
  const CvBuilderPreviewScreen({super.key});

  @override
  State<CvBuilderPreviewScreen> createState() => _CvBuilderPreviewScreenState();
}

class _CvBuilderPreviewScreenState extends State<CvBuilderPreviewScreen> {
  bool _isExporting = false;
  Future<Uint8List>? _pdfFuture;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  void _loadPdf() {
    final provider = context.read<CVBuilderProvider>();
    final cv = provider.currentCV;
    if (cv != null) {
      _pdfFuture = CvPdfService().generatePDFBytes(cv);
    }
  }

  Future<void> _downloadPdf() async {
    final provider = context.read<CVBuilderProvider>();
    final cv = provider.currentCV;
    if (cv == null) return;

    setState(() => _isExporting = true);
    try {
      final service = CvPdfService();
      final path = await service.saveToDownloads(cv);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.cvSavedTo(path)),
            action: SnackBarAction(
              label: l10n.ok,
              onPressed: () {},
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToGeneratePdf(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<void> _sharePdf() async {
    final provider = context.read<CVBuilderProvider>();
    final cv = provider.currentCV;
    if (cv == null) return;

    setState(() => _isExporting = true);
    try {
      final service = CvPdfService();
      await service.sharePdf(cv);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToGeneratePdf(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  void _showPdfOptions() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.exportCv,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Iconsax.document_download,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(l10n.downloadPdf),
              subtitle: Text(l10n.saveToDownloads),
              onTap: () {
                Navigator.pop(context);
                _downloadPdf();
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Iconsax.share,
                  color: Colors.green,
                ),
              ),
              title: Text(l10n.share),
              subtitle: Text(l10n.shareDesc),
              onTap: () {
                Navigator.pop(context);
                _sharePdf();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.previewCV),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.router.maybePop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: IconButton(
                onPressed: () async {
                  final provider = context.read<CVBuilderProvider>();
                  final success = await provider.saveCurrentCV();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success ? l10n.cvSavedToLibrary : l10n.failedToSaveCv,
                        ),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                    if (success) {
                      context.router.replaceAll([
                        const MainRoute(children: [CvToolsHubRoute()]),
                      ]);
                    }
                  }
                },
                icon: Icon(
                  Iconsax.save_2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: AppSection(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.sm, horizontal: AppSizes.md),
                color: Colors.green.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 20),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        l10n.cvConvertedSuccess,
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _pdfFuture == null
                    ? Center(
                        child: Text(
                          l10n.noCvData,
                          style: const TextStyle(color: Color(0xFF9CA3AF)),
                        ),
                      )
                    : FutureBuilder<Uint8List>(
                        future: _pdfFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(
                                  l10n.failedToGeneratePdf(snapshot.error.toString()),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return SfPdfViewer.memory(
                              snapshot.data!,
                              canShowScrollHead: false,
                              canShowScrollStatus: false,
                              enableDoubleTapZooming: true,
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, -4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.all(AppSizes.md),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.sm),
                                ),
                              ),
                              onPressed: () => context.router
                                  .push(const CvBuilderStep1Route()),
                              child: Text(l10n.edit),
                            ),
                          ),
                          const SizedBox(width: AppSizes.md),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                padding: const EdgeInsets.all(AppSizes.md),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.sm),
                                ),
                              ),
                              onPressed: () async {
                                final provider =
                                    context.read<CVBuilderProvider>();
                                final success = await provider.saveCurrentCV();

                                if (context.mounted) {
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.cvSavedToLibrary),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    context.router
                                        .replaceAll([const HomeRoute()]);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.failedToSaveCv),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                l10n.save,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.sm),
                      TextButton.icon(
                        onPressed: _isExporting ? null : _showPdfOptions,
                        icon: _isExporting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Iconsax.export_1, size: 20),
                        label: Text(_isExporting
                            ? l10n.exportPdf // Assume exporting string or similar if available, just use exportPdf for now
                            : l10n.exportPdf),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

