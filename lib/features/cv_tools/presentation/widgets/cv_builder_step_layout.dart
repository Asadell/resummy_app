import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/utils/dynamic_cv_steps.dart';
import 'package:resummy_app/features/cv_tools/utils/cv_pdf_service.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:auto_route/auto_route.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';

class CVBuilderStepLayout extends StatefulWidget {
  final String title;
  final int currentStep;
  final Widget editContent;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final String? nextLabel;
  final String? backLabel;
  final bool isNextEnabled;

  const CVBuilderStepLayout({
    super.key,
    required this.title,
    required this.currentStep,
    required this.editContent,
    this.onNext,
    this.onBack,
    this.nextLabel,
    this.backLabel,
    this.isNextEnabled = true,
  });

  @override
  State<CVBuilderStepLayout> createState() => _CVBuilderStepLayoutState();
}

class _CVBuilderStepLayoutState extends State<CVBuilderStepLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<Uint8List>? _pdfFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.index == 1 && !_tabController.indexIsChanging) {
      _generatePdfPreview();
    }
  }

  void _generatePdfPreview() {
    final provider = context.read<CVBuilderProvider>();
    final cv = provider.currentCV;
    if (cv != null) {
      if (mounted) {
        setState(() {
          _pdfFuture = CvPdfService().generatePDFBytes(cv);
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<CVBuilderProvider>(
      builder: (context, provider, _) {
        final totalSteps = DynamicCvSteps.getTotalSteps(provider.currentCV);
        final stepTitle =
            DynamicCvSteps.getStepTitle(widget.currentStep, provider.currentCV);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_left),
              onPressed: () => _showExitConfirmation(context, l10n),
            ),
            title: InkWell(
              onTap: () => _showStepSelector(context, provider, l10n),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        stepTitle,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, size: 20),
                  ],
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: () async {
                    final success = await provider.saveCurrentCV();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? l10n.cvSavedToLibrary
                                : (provider.errorMessage ??
                                    l10n.failedToSaveCv),
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
            ],
          ),
          body: Column(
            children: [
              LinearProgressIndicator(
                value: widget.currentStep / totalSteps,
                backgroundColor: const Color(0xFFE5E7EB),
                color: const Color(0xFF0EA5E9),
                minHeight: 4,
              ),
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: Theme.of(context).colorScheme.onPrimary,
                  unselectedLabelColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(
                      height: 36,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Iconsax.edit_2, size: 16),
                          const SizedBox(width: 8),
                          Text(l10n.edit),
                        ],
                      ),
                    ),
                    Tab(
                      height: 36,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Iconsax.eye, size: 16),
                          const SizedBox(width: 8),
                          Text(l10n.previewCV),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    widget.editContent,
                    Container(
                      color: const Color(0xFFF5F5F5),
                      child: FutureBuilder<Uint8List>(
                        future: _pdfFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('Failed to load PDF: ${snapshot.error}', textAlign: TextAlign.center),
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return SfPdfViewer.memory(
                              snapshot.data!,
                              enableDoubleTapZooming: true,
                            );
                          } else {
                            return Center(
                              child: Text(
                                'Tap the Preview tab to load CV',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
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
              child: Row(
                children: [
                  if (widget.currentStep > 1 && widget.onBack != null) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onBack,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(widget.backLabel ?? l10n.goBack),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  if (widget.onNext != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.isNextEnabled ? widget.onNext : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(widget.nextLabel ?? l10n.next),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showStepSelector(
      BuildContext context, CVBuilderProvider provider, AppLocalizations l10n) {
    final cv = provider.currentCV;
    if (cv == null) return;

    final totalSteps = DynamicCvSteps.getTotalSteps(cv);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.8,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  l10n.selectSectionFormat, // Reusing existing key if appropriate or just 'Select Step'
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: totalSteps,
                  itemBuilder: (context, index) {
                    final step = index + 1;
                    final stepTitle = DynamicCvSteps.getStepTitle(step, cv);
                    final isCurrent = step == widget.currentStep;

                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        if (!isCurrent) {
                          DynamicCvSteps.navigateToStep(context, step);
                        }
                      },
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? Theme.of(context).primaryColor
                              : Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$step',
                            style: TextStyle(
                              color: isCurrent
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        stepTitle,
                        style: TextStyle(
                          fontWeight:
                              isCurrent ? FontWeight.bold : FontWeight.normal,
                          color: isCurrent
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                      ),
                      trailing: isCurrent
                          ? Icon(Icons.check_circle,
                              color: Theme.of(context).primaryColor)
                          : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.exitBuilderTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.exitBuilderMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(l10n.stay),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.router.replaceAll([
                        const MainRoute(children: [CvToolsHubRoute()]),
                      ]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(l10n.exit),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
