import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/app/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.stepProgress(2, 4)),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
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
              l10n.whatsYourCurrentStatus,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            _buildStatusOption(l10n.freshGraduate, 'fresh_grad'),
            _buildStatusOption(l10n.currentlyWorking, 'working'),
            _buildStatusOption(l10n.lookingForJob, 'job_seeking'),
            _buildStatusOption(l10n.freelancer, 'freelancer'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                context.router.push(const OnboardingStep3Route());
              },
              child: Text(l10n.next),
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
