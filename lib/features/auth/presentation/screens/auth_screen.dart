import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/app/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

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
              Icon(
                Iconsax.document_text,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),
              Text(
                l10n.welcomeToResummy,
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.buildPerfectResumeWithAi,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement Google Sign-In
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.googleSignInComingSoon)),
                  );
                },
                icon: const Icon(Iconsax.google, size: 24),
                label: Text(l10n.loginWithGoogle),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  context.router.push(const LanguageSelectionRoute());
                },
                child: Text(l10n.goToLanguageSelection),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
