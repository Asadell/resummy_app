import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:resummy_app/features/auth/data/user_profile_repository.dart';

@RoutePage()
class OnboardingConfirmationScreen extends StatefulWidget {
  final String fullName;
  final String? workStatus;
  final String? targetRole;
  final String? careerGoal;

  const OnboardingConfirmationScreen({
    super.key,
    required this.fullName,
    this.workStatus,
    this.targetRole,
    this.careerGoal,
  });

  @override
  State<OnboardingConfirmationScreen> createState() =>
      _OnboardingConfirmationScreenState();
}

class _OnboardingConfirmationScreenState
    extends State<OnboardingConfirmationScreen> {
  bool _isLoading = false;
  final _repository = UserProfileRepository();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final displayName = widget.fullName.isNotEmpty
        ? widget.fullName
        : authProvider.currentUser?.displayName ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.confirmation),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Iconsax.tick_circle,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.yourProfileIsReady,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(context, l10n.fullName, displayName),
                      const Divider(),
                      _buildInfoRow(context, l10n.status,
                          _getStatusLabel(context, widget.workStatus)),
                      const Divider(),
                      _buildInfoRow(
                          context, l10n.targetRole, widget.targetRole ?? '-'),
                      const Divider(),
                      _buildInfoRow(
                          context, l10n.goal, widget.careerGoal ?? '-'),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: _isLoading
                    ? null
                    : () => _completeOnboarding(context, displayName),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n.startUsingApp),
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

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(BuildContext context, String? status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case 'fresh_grad':
        return l10n.freshGraduate;
      case 'working':
        return l10n.currentlyWorking;
      case 'job_seeking':
        return l10n.lookingForJob;
      case 'freelancer':
        return l10n.freelancer;
      default:
        return '-';
    }
  }

  Future<void> _completeOnboarding(
      BuildContext context, String displayName) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    final router = context.router;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.currentUser == null) {
      setState(() => _isLoading = false);
      return;
    }

    final success = await _repository.completeOnboarding(
      authProvider.currentUser!.id,
      fullName: displayName,
      workStatus: widget.workStatus,
      targetRole: widget.targetRole,
      careerGoal: widget.careerGoal,
    );

    if (success) {
      router.replace(const MainRoute());
    } else {
      setState(() => _isLoading = false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorSavingProfile)),
        );
      }
    }
  }
}
