import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';

@RoutePage()
class InterviewPrepScreen extends StatelessWidget {
  const InterviewPrepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.interviewPrep),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Iconsax.microphone,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.aiInterviewPractice,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.practiceInterviewWithAi,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Start button
              ElevatedButton.icon(
                onPressed: () => context.router.push(const InterviewSetupStep1Route()),
                icon: const Icon(Iconsax.play),
                label: Text(l10n.startNewInterview),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              if (kDebugMode) ...[
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                     context.read<InterviewProvider>().startInterviewWithDummyData();
                     context.router.push(const InterviewSessionClosingRoute());
                  },
                  child: const Text('DEBUG: Skip with Dummy Data'),
                ),
              ],
              const SizedBox(height: 16),
              
              // History button
              OutlinedButton.icon(
                onPressed: () => context.router.navigate(const HistoryRoute()),
                icon: const Icon(Iconsax.clock),
                label: Text(l10n.viewInterviewHistory),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
