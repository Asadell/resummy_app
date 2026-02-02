import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/app/routes/app_router.gr.dart';

@RoutePage()
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.description, color: Colors.blue),
                title: const Text('CV Software Engineer'),
                subtitle: const Text('Analyzed on Oct 24, 2023 • Score: 85'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => context.router.push(const CvAnalyzerResultRoute()),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.mic, color: Colors.green),
                title: const Text('Interview Practice: Frontend Dev'),
                subtitle: const Text('Completed on Oct 25, 2023'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => context.router.push(const InterviewFeedbackOverviewRoute()),
              ),
            ),
             const SizedBox(height: 12),
             // Placeholder
             const Center(child: Padding(
               padding: EdgeInsets.all(24.0),
               child: Text('More history will appear here', style: TextStyle(color: Colors.grey)),
             )),
          ],
        ),
      ),
    );
  }
}
