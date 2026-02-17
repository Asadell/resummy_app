import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';

@RoutePage()
class InterviewSetupConfirmationScreen extends StatelessWidget {
  const InterviewSetupConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<InterviewProvider>();

    String getFocusLabel(InterviewFocus focus) {
      switch (focus) {
        case InterviewFocus.behavioral: return l10n.focusBehavioralTitle;
        case InterviewFocus.technical: return l10n.focusTechnicalTitle;
        case InterviewFocus.mixed: return l10n.focusMixedTitle;
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.confirmation),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.back(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                l10n.stepProgress(5, 5),
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),

              // Success Icon
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                l10n.setupComplete,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.readyToStartDesc,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.light 
                          ? Colors.black.withValues(alpha: 0.05) 
                          : Colors.transparent,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.interviewSummary,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    _buildSummaryRow(context, Iconsax.document_1, l10n.cvLabel, provider.cvFileName ?? l10n.cvDefaultLabel),
                    const SizedBox(height: 16),
                    _buildSummaryRow(context, Iconsax.briefcase, l10n.roleLabel, provider.role ?? '-'),
                    const SizedBox(height: 16),
                    _buildSummaryRow(context, Iconsax.radar_1, l10n.interviewFocus, getFocusLabel(provider.selectedFocus)),
                    const SizedBox(height: 16),
                    _buildSummaryRow(context, Iconsax.global, l10n.languageLabel, provider.locale == 'en-US' ? l10n.english : l10n.indonesian),
                    const SizedBox(height: 16),
                    _buildSummaryRow(context, Iconsax.message_question, l10n.questionsLabel, l10n.questionsCountDynamic(5)), // Dynamic?
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                     // Start Interview
                     context.read<InterviewProvider>().startInterview(
                        role: provider.role ?? "Candidate",
                        focus: provider.selectedFocus,
                     );
                     context.router.push(const InterviewSessionOpeningRoute());
                  },
                  child: Text(
                    l10n.startInterviewNow,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
