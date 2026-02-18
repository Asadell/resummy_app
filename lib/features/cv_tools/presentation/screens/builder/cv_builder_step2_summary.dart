import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_builder_step_layout.dart';
import 'package:resummy_app/features/cv_tools/presentation/utils/dynamic_cv_steps.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';

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
    final currentStep = DynamicCvSteps.getStepForSection(context, 'summary');

    return CVBuilderStepLayout(
      title: l10n.cvBuilder,
      currentStep: currentStep,
      onBack: () {
        DynamicCvSteps.navigateToPreviousStep(context, currentStep);
      },
      onNext: _saveAndNext,
      editContent: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSection(
              child: Column(
                spacing: AppSizes.sm,
                children: [
                  Consumer<CVBuilderProvider>(
                    builder: (context, provider, _) {
                      final currentStep =
                          DynamicCvSteps.getStepForSection(context, 'summary');
                      final totalSteps =
                          DynamicCvSteps.getTotalSteps(provider.currentCV);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
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
                  Text(
                    l10n.summaryHeader,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    l10n.summaryDesc,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            AppSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSizes.md,
                children: [
                  Text(
                    l10n.summaryHeader,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _summaryController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: l10n.summaryHint,
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.sm),
                      ),
                      counterText: '',
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerLowest,
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                    onChanged: (value) {
                      setState(() {});
                      context
                          .read<CVBuilderProvider>()
                          .updateSummary(value.trim());
                    },
                    maxLength: 2000,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_summaryController.text.length} ${l10n.characters}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
