import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/providers/auth_provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/auth/data/user_profile_repository.dart';
import 'package:resummy_app/features/auth/domain/user_profile_model.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';

@RoutePage()
class CvBuilderWelcomeScreen extends StatefulWidget {
  const CvBuilderWelcomeScreen({super.key});

  @override
  State<CvBuilderWelcomeScreen> createState() => _CvBuilderWelcomeScreenState();
}

class _CvBuilderWelcomeScreenState extends State<CvBuilderWelcomeScreen> {
  final _profileRepository = UserProfileRepository();
  UserProfile? _profile;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      final profile = await _profileRepository.getUserProfile(authProvider.user!.uid);
      if (mounted) {
        setState(() {
          _profile = profile;
          _isLoadingProfile = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoadingProfile = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cvBuilder),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Iconsax.document_text,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.cvBuilderWelcomeTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.cvBuilderWelcomeDesc,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              if (_isLoadingProfile)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () {
                    // Pre-fill from profile (prioritize Firestore fullName)
                    final name = _profile?.fullName ?? authProvider.displayName;
                    final email = _profile?.email ?? authProvider.email;
                    final phone = authProvider.phoneNumber;

                    // Initialize new CV before navigating
                    context.read<CVBuilderProvider>().startNewCV(
                      name: name,
                      email: email,
                      phone: phone,
                    );
                    context.router.push(const CvBuilderStep1Route());
                  },
                  child: Text(l10n.startCreatingCv),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
