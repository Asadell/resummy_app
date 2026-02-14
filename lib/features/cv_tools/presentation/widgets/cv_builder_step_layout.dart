import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_preview_card.dart';

class CVBuilderStepLayout extends StatefulWidget {
  final String title;
  final int currentStep;
  final int totalSteps;
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
    required this.totalSteps,
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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${widget.currentStep}/${widget.totalSteps}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
           LinearProgressIndicator(
            value: widget.currentStep / widget.totalSteps,
            backgroundColor: const Color(0xFFE5E7EB),
            color: const Color(0xFF0EA5E9),
            minHeight: 4,
          ),

          // Tab Bar
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
                // Edit Tab
                widget.editContent,
                
                // Preview Tab
                Consumer<CVBuilderProvider>(
                  builder: (context, provider, child) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: CvPreviewCard(cvData: provider.currentCV),
                    );
                  },
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
              if (widget.onBack != null) ...[
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
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('${widget.nextLabel ?? l10n.next} →'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
