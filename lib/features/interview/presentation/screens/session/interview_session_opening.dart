import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';

@RoutePage()
class InterviewSessionOpeningScreen extends StatefulWidget {
  const InterviewSessionOpeningScreen({super.key});

  @override
  State<InterviewSessionOpeningScreen> createState() => _InterviewSessionOpeningScreenState();
}

class _InterviewSessionOpeningScreenState extends State<InterviewSessionOpeningScreen> {
  bool _showTranscript = true;

  Future<void> _showExitDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.exitInterviewTitle),
        content: Text(l10n.exitInterviewContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.continueInterview),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.exitYes),
          ),
        ],
      ),
    ) ?? false;

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
          icon: Icon(Iconsax.close_circle, color: Theme.of(context).colorScheme.error),
          onPressed: _showExitDialog,
        ),
        title: Row(
          children: [
            Icon(Iconsax.microphone_2, color: Theme.of(context).colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(l10n.interviewStarted),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Consumer<InterviewProvider>(
                builder: (context, provider, _) => Row(
                  children: [
                    Icon(Iconsax.timer_1, size: 16, color: Theme.of(context).colorScheme.primary),
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
            // Toggle Control
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                border: Border.all(color: Theme.of(context).dividerTheme.color!),
                borderRadius: BorderRadius.circular(8),
              ),
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
                  const SizedBox(width: 8),
                  _buildToggleButton(false, l10n.off),
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // AI Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)],
                          ),
                          border: Border.all(color: Theme.of(context).colorScheme.surface, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Iconsax.profile_circle,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 40,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // AI Message Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).brightness == Brightness.light ? Colors.black.withValues(alpha: 0.05) : Colors.transparent,
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Iconsax.profile_circle, color: Theme.of(context).colorScheme.primary, size: 18),
                                const SizedBox(width: 8),
                                  Text(
                                    l10n.aiInterviewer,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.aiMessageOpening,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Transcript Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.lamp_on, color: Theme.of(context).colorScheme.primary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            l10n.transcriptToggleHint,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Action Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
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
                  const SizedBox(height: 16),
                  Text(
                    l10n.tapToAnswer,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.router.push(const InterviewSessionQuestionRoute()),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}