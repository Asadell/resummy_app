import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';

@RoutePage()
class InterviewSessionClosingScreen extends StatefulWidget {
  const InterviewSessionClosingScreen({super.key});

  @override
  State<InterviewSessionClosingScreen> createState() => _InterviewSessionClosingScreenState();
}

class _InterviewSessionClosingScreenState extends State<InterviewSessionClosingScreen> {
  @override
  void initState() {
    super.initState();
    _generateFeedback();
  }

  Future<void> _generateFeedback() async {
    // Simulate API Call
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.router.push(const InterviewFeedbackOverviewRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Generating Feedback...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
