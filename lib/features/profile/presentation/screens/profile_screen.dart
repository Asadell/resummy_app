import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/app/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/providers/locale_provider.dart';
import 'package:resummy_app/core/providers/theme_provider.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Icon(
                          Iconsax.user,
                          size: 48,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.userName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        l10n.userEmail,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Settings Section
              Text(
                l10n.settings,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              
              // Theme Toggle
              Card(
                child: SwitchListTile(
                  title: Text(l10n.darkMode),
                  subtitle: Text(
                    themeProvider.isDarkMode ? l10n.darkThemeEnabled : l10n.lightThemeEnabled
                  ),
                  secondary: Icon(
                    themeProvider.isDarkMode ? Iconsax.moon : Iconsax.sun_1,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
              ),
              const SizedBox(height: 8),
              
              // Language Toggle  
              Card(
                child: SwitchListTile(
                  title: Text(l10n.language),
                  subtitle: Text(
                    localeProvider.isIndonesian ? l10n.bahasaIndonesia : l10n.english
                  ),
                  secondary: Icon(
                    Iconsax.global,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  value: localeProvider.isIndonesian,
                  onChanged: (_) => localeProvider.toggleLocale(),
                ),
              ),
              const SizedBox(height: 24),
              
              // Logout Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  padding: const EdgeInsets.all(16),
                ),
                icon: const Icon(Iconsax.logout),
                label: Text(l10n.logout),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.logout),
                      content: Text(l10n.confirmLogout),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.router.push(const AuthRoute());
                          },
                          child: Text(l10n.logout),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
