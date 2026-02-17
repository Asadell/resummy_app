import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';
import 'package:intl/intl.dart';

@RoutePage()
class InterviewPrepScreen extends StatelessWidget {
  const InterviewPrepScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              const SizedBox(height: 32),
              
              // Recent Interviews Headers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.recentInterviews,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.router.navigate(const HistoryRoute()),
                    child: Text(l10n.viewAll),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Recent Interviews List
              Consumer<InterviewProvider>(
                builder: (context, provider, _) {
                  if (provider.history.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          l10n.noInterviewHistory,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }
                  
                  // Show top 3
                  final recent = provider.history.take(3).toList();
                  
                  return Column(
                    children: recent.map((report) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getScoreColor(context, report.overallScore).withValues(alpha: 0.1),
                            child: Text(
                              report.overallScore.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getScoreColor(context, report.overallScore),
                              ),
                            ),
                          ),
                          title: Text(l10n.interviewResults), // Context? Position?
                          subtitle: Text(
                            DateFormat.yMMMd().format(report.createdAt),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: const Icon(Iconsax.arrow_right_3, size: 16),
                          onTap: () {
                            provider.setReport(report);
                            context.router.push(const InterviewFeedbackOverviewRoute());
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(BuildContext context, int score) {
    if (score >= 80) return Theme.of(context).colorScheme.primary;
    if (score >= 60) return Colors.orange;
    return Theme.of(context).colorScheme.error;
  }
}
