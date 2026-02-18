import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/providers/locale_provider.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:resummy_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:resummy_app/features/profile/presentation/providers/profile_provider.dart';

@RoutePage()
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSizes.xxl),
              Icon(
                Iconsax.language_square,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              Column(
                spacing: AppSizes.xs,
                children: [
                  Text(
                    _selectedLanguage == 'en'
                        ? 'Choose Your Language'
                        : 'Pilih Bahasa Anda',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    _selectedLanguage == 'en'
                        ? 'Please select your preferred language'
                        : 'Silakan pilih bahasa yang Anda inginkan',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xl),
              Column(
                spacing: AppSizes.md,
                children: [
                  _buildLanguageOption(
                    '🇬🇧',
                    l10n.english,
                    'en',
                  ),
                  _buildLanguageOption(
                    '🇮🇩',
                    l10n.bahasaIndonesia,
                    'id',
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: () async {
                  final router = context.router;
                  final localeProvider =
                      Provider.of<LocaleProvider>(context, listen: false);
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);

                  await localeProvider.setLocale(Locale(_selectedLanguage));
                  await localeProvider.markLanguageSelected();

                  if (authProvider.isAuthenticated && context.mounted) {
                    final profileProvider =
                        Provider.of<ProfileProvider>(context, listen: false);
                    await profileProvider
                        .loadProfile(authProvider.currentUser!.id);

                    if (context.mounted) {
                      if (profileProvider.profile?.onboardingDone ?? false) {
                        router.replace(const MainRoute());
                      } else {
                        router.replace(const OnboardingStep1Route());
                      }
                    }
                  } else {
                    router.replace(const AuthRoute());
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: AppSizes.sm,
                  children: [
                    Text(_selectedLanguage == 'en' ? 'Continue' : 'Lanjutkan'),
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

  Widget _buildLanguageOption(String flag, String language, String code) {
    final isSelected = _selectedLanguage == code;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = code;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.3)
              : null,
        ),
        child: Row(
          spacing: AppSizes.md,
          children: [
            Text(flag, style: const TextStyle(fontSize: 40)),
            Text(
              language,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Iconsax.tick_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
