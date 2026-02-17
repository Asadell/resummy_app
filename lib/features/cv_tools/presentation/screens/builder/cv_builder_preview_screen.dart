import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_preview_card.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class CvBuilderPreviewScreen extends StatelessWidget {
  const CvBuilderPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.previewCV),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: Column(
        children: [
          // Preview Area
          Expanded(
            child: Consumer<CVBuilderProvider>(
              builder: (context, provider, child) {
                return CvPreviewCard(cvData: provider.currentCV);
              },
            ),
          ),
          
          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
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
                  // Save as Draft Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.all(16),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      final provider = context.read<CVBuilderProvider>();
                      await provider.saveCurrentCV();
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.cvSavedSuccess),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Navigate to hub to see saved CV
                        context.router.push(const CvToolsHubRoute());
                      }
                    },
                    child: Text(l10n.saveAsDraft),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Download PDF Button (placeholder)
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Implement PDF download
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.downloadPdfUnavailable),
                        ),
                      );
                    },
                    child: Text(l10n.downloadPdf),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Edit Button
                  TextButton(
                    onPressed: () => context.router.push(const CvBuilderStep1Route()),
                    child: Text(l10n.edit),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
