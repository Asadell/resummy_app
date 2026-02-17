import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';
import 'package:intl/intl.dart';

@RoutePage()
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.history),
      ),
      body: SafeArea(
        child: Consumer<InterviewProvider>(
          builder: (context, provider, child) {
            final history = provider.history;
            
            if (history.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.document_text, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noInterviewHistory,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final report = history[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                       backgroundColor: _getScoreColor(context, report.overallScore).withValues(alpha: 0.1),
                       child: Icon(Iconsax.microphone, color: _getScoreColor(context, report.overallScore)),
                    ),
                    title: Text(l10n.interviewResults), // TODO: Add Role to InterviewReport so we can show it here
                    subtitle: Text(
                      DateFormat('MMM d, y • HH:mm').format(report.createdAt),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${report.overallScore}/100',
                           style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getScoreColor(context, report.overallScore),
                           ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Iconsax.arrow_right_3, size: 16),
                      ],
                    ),
                    onTap: () {
                      provider.setReport(report);
                      context.router.push(const InterviewFeedbackOverviewRoute());
                    },
                  ),
                );
              },
            );
          },
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
