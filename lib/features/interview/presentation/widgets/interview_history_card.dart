import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/interview/domain/entities/interview_entity.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';

class InterviewHistoryCard extends StatelessWidget {
  final InterviewEntity interview;

  const InterviewHistoryCard({
    super.key,
    required this.interview,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final score = interview.report?.overallScore ?? 0;

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getScoreColor(context, score).withValues(alpha: 0.1),
          child: Text(
            score.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _getScoreColor(context, score),
            ),
          ),
        ),
        title: Text(l10n.interviewResults),
        subtitle: Text(
          DateFormat.yMMMd().format(interview.createdAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Iconsax.arrow_right_3, size: 16),
        onTap: () {
          if (interview.report != null) {
            context.read<InterviewProvider>().setReport(interview.report!);
            context.router.push(const InterviewFeedbackOverviewRoute());
          }
        },
      ),
    );
  }

  Color _getScoreColor(BuildContext context, int score) {
    if (score >= 80) return Theme.of(context).colorScheme.primary;
    if (score >= 60) return Colors.orange;
    return Theme.of(context).colorScheme.error;
  }
}
