import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class InterviewSessionUserQuestionsScreen extends StatefulWidget {
  const InterviewSessionUserQuestionsScreen({super.key});

  @override
  State<InterviewSessionUserQuestionsScreen> createState() => _InterviewSessionUserQuestionsScreenState();
}

class _InterviewSessionUserQuestionsScreenState extends State<InterviewSessionUserQuestionsScreen> {
  
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
        title: Text(l10n.yourQuestionsTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.anyQuestionsPrompt),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => context.router.push(const InterviewSessionClosingRoute()),
                    child: Text(l10n.skip),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                    onPressed: () => context.router.push(const InterviewSessionClosingRoute()),
                    child: Text(l10n.askInterviewer),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
