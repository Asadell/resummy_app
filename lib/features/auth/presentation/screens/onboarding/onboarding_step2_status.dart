import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/app/routes/app_router.gr.dart';

@RoutePage()
class OnboardingStep2Screen extends StatefulWidget {
  const OnboardingStep2Screen({super.key});

  @override
  State<OnboardingStep2Screen> createState() => _OnboardingStep2ScreenState();
}

class _OnboardingStep2ScreenState extends State<OnboardingStep2Screen> {
  String _selectedStatus = 'fresh_grad';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 2/4'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.push(const OnboardingStep1Route()),
        ),
      ),
      body: SafeArea(
        child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What\'s your current status?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            _buildStatusOption('Fresh Graduate', 'fresh_grad'),
            _buildStatusOption('Currently Working', 'working'),
            _buildStatusOption('Looking for Job', 'job_seeking'),
            _buildStatusOption('Freelancer', 'freelancer'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                context.router.push(const OnboardingStep3Route());
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildStatusOption(String label, String value) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: _selectedStatus,
      onChanged: (val) {
        setState(() {
          _selectedStatus = val!;
        });
      },
    );
  }
}
