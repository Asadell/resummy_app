import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/app/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Iconsax.document_text, color: Colors.blue),
                title: Text(l10n.cvSoftwareEngineer),
                subtitle: Text(l10n.analyzedOnDate('Oct 24, 2023', 85)),
                trailing: const Icon(Iconsax.arrow_right_3, size: 16),
                onTap: () => context.router.push(const CvAnalyzerResultRoute()),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Iconsax.microphone, color: Colors.green),
                title: Text(l10n.interviewPracticeFrontend),
                subtitle: Text(l10n.completedOnDate('Oct 25, 2023')),
                trailing: const Icon(Iconsax.arrow_right_3, size: 16),
                onTap: () => context.router.push(const InterviewFeedbackOverviewRoute()),
              ),
            ),
             const SizedBox(height: 12),
             // Placeholder
             Center(child: Padding(
               padding: const EdgeInsets.all(24.0),
               child: Text(l10n.moreHistoryWillAppear, style: const TextStyle(color: Colors.grey)),
             )),
          ],
        ),
      ),
    );
  }
}
