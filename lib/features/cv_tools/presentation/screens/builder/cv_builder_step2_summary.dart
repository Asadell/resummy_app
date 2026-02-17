
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_builder_step_layout.dart';
import 'package:resummy_app/features/cv_tools/presentation/utils/dynamic_cv_steps.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class CvBuilderStep2Screen extends StatefulWidget {
  const CvBuilderStep2Screen({super.key});

  @override
  State<CvBuilderStep2Screen> createState() => _CvBuilderStep2ScreenState();
}

class _CvBuilderStep2ScreenState extends State<CvBuilderStep2Screen> {
  late TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CVBuilderProvider>();
    _summaryController = TextEditingController(
      text: provider.currentCV?.summarySection?.content ?? '',
    );
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  void _saveAndNext() {
    final provider = context.read<CVBuilderProvider>();
    provider.updateSummary(_summaryController.text.trim());
    provider.saveCurrentCV();
    final currentStep = DynamicCvSteps.getStepForSection(context, 'summary');
    DynamicCvSteps.navigateToNextStep(context, currentStep);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentStep = DynamicCvSteps.getStepForSection(context, 'summary');

    return CVBuilderStepLayout(
      title: l10n.cvBuilder,
      currentStep: currentStep,

      onBack: () {
        DynamicCvSteps.navigateToPreviousStep(context, currentStep);
      },
      onNext: _saveAndNext,
      editContent: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Header
            Center(
              child: Consumer<CVBuilderProvider>(
                builder: (context, provider, _) {
                  final currentStep = DynamicCvSteps.getStepForSection(context, 'summary');
                  final totalSteps = DynamicCvSteps.getTotalSteps(provider.currentCV);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      border: Border.all(color: theme.primaryColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.stepHeader(currentStep, totalSteps),
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                l10n.summaryHeader,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                l10n.summaryDesc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Tips Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Icon(Iconsax.info_circle, color: theme.primaryColor, size: 20),
                   const SizedBox(width: 12),
                   Expanded(
                     child: Text(
                       l10n.summaryTips,
                       style: TextStyle(
                         color: isDark ? Colors.white70 : theme.primaryColor.withOpacity(0.8),
                         fontSize: 12,
                         height: 1.5,
                       ),
                     ),
                   ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Summary Input
            Text(
              l10n.summaryHeader,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            TextField(
              controller: _summaryController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: l10n.summaryHint,
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: theme.hintColor,
                  height: 1.5,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                counterText: '',
                filled: true,
                fillColor: theme.canvasColor,
              ),
              style: const TextStyle(fontSize: 14, height: 1.6),
              onChanged: (value) {
                setState(() {});
                context.read<CVBuilderProvider>().updateSummary(value.trim());
              },
              maxLength: 2000,
            ),

            const SizedBox(height: 16),

            // Character counter
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_summaryController.text.length} characters',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.disabledColor,
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
