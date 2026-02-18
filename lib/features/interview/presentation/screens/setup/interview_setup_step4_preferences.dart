import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';

import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';

@RoutePage()
class InterviewSetupStep4Screen extends StatelessWidget {
  const InterviewSetupStep4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<InterviewProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.interviewFocus),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () =>
              context.router.push(const InterviewSetupStep3Route()),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.md),
            child: Center(
              child: Text(
                l10n.stepProgress(4, 5),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSizes.sm,
            children: [
              AppSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSizes.xs,
                  children: [
                    Text(
                      l10n.selectInterviewFocus,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      l10n.interviewFocusDesc,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),

              AppSection(
                child: Column(
                  spacing: AppSizes.sm,
                  children: [
                    _buildFocusCard(
                      context,
                      title: l10n.focusBehavioralTitle,
                      description: l10n.focusBehavioralDesc,
                      icon: Iconsax.user_search,
                      value: InterviewFocus.behavioral,
                      groupValue: provider.selectedFocus,
                      onChanged: (val) => provider.updateFocus(val!),
                    ),
                    _buildFocusCard(
                      context,
                      title: l10n.focusTechnicalTitle,
                      description: l10n.focusTechnicalDesc,
                      icon: Iconsax.code_1,
                      value: InterviewFocus.technical,
                      groupValue: provider.selectedFocus,
                      onChanged: (val) => provider.updateFocus(val!),
                    ),
                    _buildFocusCard(
                      context,
                      title: l10n.focusMixedTitle,
                      description: l10n.focusMixedDesc,
                      icon: Iconsax.blend_2,
                      value: InterviewFocus.mixed,
                      groupValue: provider.selectedFocus,
                      onChanged: (val) => provider.updateFocus(val!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withValues(alpha: 0.05)
                  : Colors.transparent,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      context.router.push(const InterviewSetupStep3Route()),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: Text('← ${l10n.back}'),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.router
                        .push(const InterviewSetupConfirmationRoute());
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: Text('${l10n.continueText} →'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFocusCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required InterviewFocus value,
    required InterviewFocus groupValue,
    required ValueChanged<InterviewFocus?> onChanged,
  }) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(AppSizes.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.2)
              : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppSizes.sm),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSizes.xs,
                children: [
                  Row(
                    children: [
                      Icon(icon,
                          size: 20,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: AppSizes.sm),
                      Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                      ),
                    ],
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
