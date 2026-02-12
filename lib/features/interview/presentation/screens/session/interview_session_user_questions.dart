import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';

@RoutePage()
class InterviewSessionUserQuestionsScreen extends StatefulWidget {
  const InterviewSessionUserQuestionsScreen({super.key});

  @override
  State<InterviewSessionUserQuestionsScreen> createState() => _InterviewSessionUserQuestionsScreenState();
}

class _InterviewSessionUserQuestionsScreenState extends State<InterviewSessionUserQuestionsScreen> {
  
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
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      appBar: AppBar(
        title: const Text('Your Questions'),
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
              const Text('Do you have any questions for the interviewer?'),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => context.router.push(const InterviewSessionClosingRoute()),
                    child: const Text('Skip'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                    onPressed: () => context.router.push(const InterviewSessionClosingRoute()),
                    child: const Text('Tanya ke Interviewer'),
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
