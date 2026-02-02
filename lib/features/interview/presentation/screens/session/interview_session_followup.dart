import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/app/routes/app_router.gr.dart';

@RoutePage()
class InterviewSessionFollowupScreen extends StatefulWidget {
  const InterviewSessionFollowupScreen({super.key});

  @override
  State<InterviewSessionFollowupScreen> createState() => _InterviewSessionFollowupScreenState();
}

class _InterviewSessionFollowupScreenState extends State<InterviewSessionFollowupScreen> {

  Future<void> _showExitDialog() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Interview?'),
        content: const Text('Progress akan hilang jika keluar sekarang.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Lanjut Interview'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Keluar'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Follow-up'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Good job! Now let\'s act on some follow-up points.',
                 style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => context.router.push(const InterviewSessionUserQuestionsRoute()),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
