import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';

@RoutePage()
class InterviewSessionOpeningScreen extends StatefulWidget {
  const InterviewSessionOpeningScreen({super.key});

  @override
  State<InterviewSessionOpeningScreen> createState() =>
      _InterviewSessionOpeningScreenState();
}

class _InterviewSessionOpeningScreenState
    extends State<InterviewSessionOpeningScreen> {
  bool _showTranscript = true;

  Future<void> _showExitBottomSheet() async {
    final l10n = AppLocalizations.of(context)!;
    final shouldExit = await showModalBottomSheet<bool>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.md)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSizes.md,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(AppSizes.xs),
                    ),
                  ),
                ),
                Icon(
                  Iconsax.warning_2,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                Column(
                  spacing: AppSizes.xs,
                  children: [
                    Text(
                      l10n.exitInterviewTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      l10n.exitInterviewContent,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                Row(
                  spacing: AppSizes.sm,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                            l10n.continueInterview,
                            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor: Theme.of(context).colorScheme.onError,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        child: Text(l10n.exitYes),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.xs),
              ],
            ),
          ),
        ) ??
        false;

    if (shouldExit && mounted) {
      context.router.push(const InterviewPrepRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.close_circle,
              color: Theme.of(context).colorScheme.error),
          onPressed: _showExitBottomSheet,
        ),
        title: Row(
          children: [
            Icon(Iconsax.microphone_2,
                color: Theme.of(context).colorScheme.primary, size: 20),
            const SizedBox(width: AppSizes.sm),
            Text(l10n.interviewStarted),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.md),
            child: Center(
              child: Consumer<InterviewProvider>(
                builder: (context, provider, _) => Row(
                  children: [
                    Icon(Iconsax.timer_1,
                        size: 16, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      '${(provider.totalSessionDurationSeconds ~/ 60).toString().padLeft(2, '0')}:${(provider.totalSessionDurationSeconds % 60).toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            AppSection(
              child: Row(
                children: [
                  Text(
                    l10n.toggleText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const Spacer(),
                  _buildToggleButton(true, l10n.on),
                  const SizedBox(width: AppSizes.sm),
                  _buildToggleButton(false, l10n.off),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppSection(
                      child: Column(
                        spacing: AppSizes.md,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            child: Icon(
                              Iconsax.profile_circle,
                              color: Theme.of(context).colorScheme.primary,
                              size: 36,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: AppSizes.sm,
                            children: [
                              Row(
                                children: [
                                  Icon(Iconsax.profile_circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      size: 18),
                                  const SizedBox(width: AppSizes.sm),
                                  Text(
                                    l10n.aiInterviewer,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                              Text(
                                l10n.aiMessageOpening,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.lamp_on,
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                  size: 18),
                              const SizedBox(width: AppSizes.sm),
                              Flexible(
                                child: Text(
                                  l10n.transcriptToggleHint,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: AppSizes.md),
              child: Column(
                spacing: AppSizes.md,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Iconsax.microphone_2,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 48,
                    ),
                  ),
                  Text(
                    l10n.tapToAnswer,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  ElevatedButton(
                    onPressed: () => context.router
                        .push(const InterviewSessionQuestionRoute()),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: Text(l10n.startInterview),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(bool isOn, String label) {
    final isActive = _showTranscript == isOn;
    return InkWell(
      onTap: () => setState(() => _showTranscript = isOn),
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
