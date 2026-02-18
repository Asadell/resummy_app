import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:resummy_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';

@RoutePage()
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Image.asset(
                'assets/icon/icon.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: AppSizes.xl),
              Column(
                spacing: AppSizes.sm,
                children: [
                  Text(
                    l10n.welcomeToResummy,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    l10n.buildPerfectResumeWithAi,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Spacer(),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      side: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    onPressed: authProvider.isLoading
                        ? null
                        : () => _signInWithGoogle(context),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: AppSizes.sm,
                            children: [
                              Image.network(
                                'https://www.google.com/favicon.ico',
                                width: 24,
                                height: 24,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Iconsax.login),
                              ),
                              Text(l10n.loginWithGoogle),
                            ],
                          ),
                  );
                },
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final router = context.router;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    await authProvider.signInWithGoogle();

    if (authProvider.isAuthenticated && context.mounted) {
      final user = authProvider.currentUser!;

      await profileProvider.createProfileIfNotExists(user.id,
          email: user.email,
          fullName: user.displayName,
          photoUrl: user.photoUrl);

      if (context.mounted) {
        if (profileProvider.profile?.onboardingDone ?? false) {
          router.replace(const MainRoute());
        } else {
          router.replace(const OnboardingStep1Route());
        }
      }
    } else if (authProvider.errorMessage != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.loginError(authProvider.errorMessage!))),
      );
    }
  }
}
