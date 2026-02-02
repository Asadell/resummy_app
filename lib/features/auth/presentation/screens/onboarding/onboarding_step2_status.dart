import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class OnboardingStep2Screen extends StatefulWidget {
  final String fullName;
  
  const OnboardingStep2Screen({
    super.key,
    required this.fullName,
  });

  @override
  State<OnboardingStep2Screen> createState() => _OnboardingStep2ScreenState();
}

class _OnboardingStep2ScreenState extends State<OnboardingStep2Screen> {
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.stepProgress(2, 4)),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.router.maybePop(),
        ),
        actions: [
          TextButton(
            onPressed: () => _skipToConfirmation(context),
            child: Text(l10n.skip),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Iconsax.briefcase,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.whatsYourCurrentStatus,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildStatusOption(l10n.freshGraduate, 'fresh_grad', Iconsax.teacher),
              const SizedBox(height: 12),
              _buildStatusOption(l10n.currentlyWorking, 'working', Iconsax.building),
              const SizedBox(height: 12),
              _buildStatusOption(l10n.lookingForJob, 'job_seeking', Iconsax.search_normal),
              const SizedBox(height: 12),
              _buildStatusOption(l10n.freelancer, 'freelancer', Iconsax.code),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: () {
                  context.router.push(OnboardingStep3Route(
                    fullName: widget.fullName,
                    workStatus: _selectedStatus,
                  ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.next),
                    const SizedBox(width: 8),
                    const Icon(Iconsax.arrow_right),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusOption(String label, String value, IconData icon) {
    final isSelected = _selectedStatus == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedStatus = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Iconsax.tick_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  void _skipToConfirmation(BuildContext context) {
    context.router.push(OnboardingConfirmationRoute(
      fullName: widget.fullName,
      workStatus: _selectedStatus,
      targetRole: null,
      careerGoal: null,
    ));
  }
}
