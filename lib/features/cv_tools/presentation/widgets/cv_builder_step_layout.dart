import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_preview_card.dart';
import 'package:resummy_app/features/cv_tools/presentation/utils/dynamic_cv_steps.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
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
            title: Text(stepTitle),
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
                          backgroundColor:
                              success ? Colors.green : Colors.red,
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
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFF0EA5E9),
                  indicatorWeight: 3,
                  labelColor: const Color(0xFF0EA5E9),
                  unselectedLabelColor: const Color(0xFF6B7280),
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: l10n.edit),
                    Tab(text: l10n.previewCV),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    widget.editContent,
                    CvPreviewCard(cvData: provider.currentCV),
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
