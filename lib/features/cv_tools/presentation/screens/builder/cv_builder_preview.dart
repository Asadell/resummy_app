import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/utils/cv_pdf_service.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

@RoutePage()
class CvBuilderPreviewScreen extends StatefulWidget {
  const CvBuilderPreviewScreen({super.key});

  @override
  State<CvBuilderPreviewScreen> createState() => _CvBuilderPreviewScreenState();
}

class _CvBuilderPreviewScreenState extends State<CvBuilderPreviewScreen> {
  bool _isGenerating = false;
  Uint8List? _pdfBytes;
  
  @override
  void initState() {
    super.initState();
    // Verify initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPdf();
    });
  }

  Future<void> _loadPdf() async {
    final provider = context.read<CVBuilderProvider>();
    final cv = provider.currentCV;
    if (cv != null) {
      if (mounted) setState(() => _isGenerating = true);
      try {
        final service = CvPdfService();
        final bytes = await service.generatePDFBytes(cv);
        if (mounted) setState(() => _pdfBytes = bytes);
      } catch (e) {
        debugPrint('Error generating PDF preview: $e');
      } finally {
        if (mounted) setState(() => _isGenerating = false);
      }
    }
  }

  Future<void> _downloadPdf(CVData cv) async {
    setState(() => _isGenerating = true);
    try {
      final service = CvPdfService();
      final path = await service.saveToDownloads(cv);
      
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.cvSavedTo(path)),
            action: SnackBarAction(
              label: 'OK',
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
        setState(() => _isGenerating = false);
      }
    }
  }

  Future<void> _sharePdf(CVData cv) async {
    setState(() => _isGenerating = true);
    try {
      final service = CvPdfService();
      await service.sharePdf(cv);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share PDF: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  void _showPdfOptions(CVData cv) {
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
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              'Export CV',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Download option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Iconsax.document_download,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(l10n.downloadPdf),
              subtitle: const Text('Save to Downloads folder'),
              onTap: () {
                Navigator.pop(context);
                _downloadPdf(cv);
              },
            ),
            const SizedBox(height: 8),
            
            // Share option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Iconsax.share,
                  color: Colors.green,
                ),
              ),
              title: const Text('Share'),
              subtitle: const Text('Share via WhatsApp, Email, etc.'),
              onTap: () {
                Navigator.pop(context);
                _sharePdf(cv);
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
    return Consumer<CVBuilderProvider>(
      builder: (context, provider, child) {
        final l10n = AppLocalizations.of(context)!;

        final cv = provider.currentCV;
        if (cv == null) {
          return Scaffold(
            body: Center(child: Text(l10n.noCvData)),
          );
        }

        return Scaffold(
          backgroundColor: Colors.grey[100], // distinct background
          appBar: AppBar(
            title: Text(l10n.previewCV),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: l10n.refreshPreview,
                onPressed: _loadPdf,
              ),
              IconButton(
                icon: const Icon(Iconsax.edit),
                onPressed: () {
                  context.router.push(const CvBuilderStep1Route());
                },
              ),
            ],
          ),
          body: _isGenerating 
              ? const Center(child: CircularProgressIndicator())
              : _pdfBytes != null
                  ? SfPdfViewer.memory(
                      _pdfBytes!,
                      enableDoubleTapZooming: true,
                    )
                  : Center(child: Text(l10n.noCvData)),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _isGenerating ? null : () => _showPdfOptions(cv),
            icon: const Icon(Iconsax.export_1),
            label: const Text('Export'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
