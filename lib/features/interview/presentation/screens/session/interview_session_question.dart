import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/app/routes/app_router.gr.dart';

@RoutePage()
class InterviewSessionQuestionScreen extends StatefulWidget {
  const InterviewSessionQuestionScreen({super.key});

  @override
  State<InterviewSessionQuestionScreen> createState() => _InterviewSessionQuestionScreenState();
}

class _InterviewSessionQuestionScreenState extends State<InterviewSessionQuestionScreen> {
  int _currentQuestion = 1;
  final int _totalQuestions = 5;

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

  void _nextQuestion() {
    if (_currentQuestion < _totalQuestions) {
      setState(() {
        _currentQuestion++;
      });
      // In a real app, load new question data
    } else {
      context.router.push(const InterviewSessionFollowupRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question $_currentQuestion/$_totalQuestions'),
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
                'Tell me about a time you handled a difficult situation.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _nextQuestion,
                child: const Text('Next Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
