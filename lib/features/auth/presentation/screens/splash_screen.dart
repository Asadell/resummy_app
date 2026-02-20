import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:resummy_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:resummy_app/core/providers/locale_provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final router = context.router;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!localeProvider.hasSelectedLanguage) {
      router.replace(const LanguageSelectionRoute());
      return;
    }


    await authProvider.waitForAuthState();
    if (!mounted) return;

    if (!authProvider.isAuthenticated) {
      router.replace(const AuthRoute());
      return;
    }

    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.loadProfile(authProvider.currentUser!.id);

    final onboardingDone = profileProvider.profile?.onboardingDone ?? false;

    if (!onboardingDone) {
      router.replace(const OnboardingStep1Route());
      return;
    }

    router.replace(const MainRoute());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSizes.md,
            children: [
              Image.asset(
                'assets/icon/icon.png',
                width: 120,
                height: 120,
              ),
              Column(
                spacing: AppSizes.xs,
                children: [
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    l10n.buildYourCareer,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xl),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
