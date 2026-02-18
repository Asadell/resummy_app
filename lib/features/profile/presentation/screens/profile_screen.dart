import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/providers/locale_provider.dart';
import 'package:resummy_app/core/providers/theme_provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:resummy_app/features/auth/domain/user_profile_model.dart';
import 'package:resummy_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';
import 'package:resummy_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateProfile(
    BuildContext context, {
    String? fullName,
    String? workStatus,
    String? targetRole,
    String? careerGoal,
  }) async {
    final provider = context.read<ProfileProvider>();
    await provider.updateProfile(
      fullName: fullName,
      workStatus: workStatus,
      targetRole: targetRole,
      careerGoal: careerGoal,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final profile = profileProvider.profile;
        final isLoading = profileProvider.isLoading;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(l10n.profile),
          ),
          body: SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppSection(
                          child: Column(
                            spacing: AppSizes.md,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                backgroundImage: authProvider
                                            .currentUser?.photoUrl !=
                                        null
                                    ? NetworkImage(
                                        authProvider.currentUser!.photoUrl!)
                                    : null,
                                child:
                                    authProvider.currentUser?.photoUrl == null
                                        ? Icon(
                                            Iconsax.user,
                                            size: 48,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          )
                                        : null,
                              ),
                              Column(
                                spacing: AppSizes.xs,
                                children: [
                                  Text(
                                    profile?.fullName ??
                                        authProvider.currentUser?.displayName ??
                                        '',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    profile?.email ??
                                        authProvider.currentUser?.email ??
                                        '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        AppSection(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: AppSizes.md,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    l10n.profileInfo,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Iconsax.edit),
                                    onPressed: () =>
                                        _showEditBottomSheet(context, profile),
                                  ),
                                ],
                              ),
                              _buildProfileRow(
                                  context,
                                  l10n.status,
                                  _getStatusLabel(
                                      context, profile?.workStatus)),
                              _buildProfileRow(context, l10n.targetRole,
                                  profile?.targetRole ?? '-'),
                              _buildProfileRow(context, l10n.goal,
                                  profile?.careerGoal ?? '-'),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        AppSection(
                          padding: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.lg,
                                  vertical: AppSizes.md,
                                ),
                                child: Text(
                                  l10n.settings,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              SwitchListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.lg,
                                  vertical: 4,
                                ),
                                title: Text(l10n.darkMode),
                                subtitle: Text(themeProvider.isDarkMode
                                    ? l10n.darkThemeEnabled
                                    : l10n.lightThemeEnabled),
                                secondary: Icon(
                                  themeProvider.isDarkMode
                                      ? Iconsax.moon
                                      : Iconsax.sun_1,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                value: themeProvider.isDarkMode,
                                onChanged: (_) => themeProvider.toggleTheme(),
                              ),
                              Divider(
                                height: 1,
                                indent: AppSizes.lg,
                                endIndent: AppSizes.lg,
                                color: Theme.of(context).dividerTheme.color,
                              ),
                              SwitchListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.lg,
                                  vertical: 4,
                                ),
                                title: Text(l10n.language),
                                subtitle: Text(localeProvider.isIndonesian
                                    ? l10n.bahasaIndonesia
                                    : l10n.english),
                                secondary: Icon(
                                  Iconsax.global,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                value: localeProvider.isIndonesian,
                                onChanged: (_) => localeProvider.toggleLocale(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        AppSection(
                          padding: const EdgeInsets.all(AppSizes.lg),
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.error,
                              side: BorderSide(
                                  color: Theme.of(context).colorScheme.error),
                              padding: const EdgeInsets.all(AppSizes.md),
                            ),
                            icon: const Icon(Iconsax.logout),
                            label: Text(l10n.logout),
                            onPressed: () => _showLogoutDialog(context),
                          ),
                        ),
                        if (kDebugMode) ...[
                          const SizedBox(height: 50),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.lg),
                            child: OutlinedButton(
                              onPressed: () {
                                context
                                    .read<InterviewProvider>()
                                    .startInterviewWithDummyData();
                                context.router
                                    .push(const InterviewSessionClosingRoute());
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.all(AppSizes.md),
                                side: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.5)),
                              ),
                              child: Text(l10n.debugSkipQuestions),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }



  Widget _buildProfileRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
              style: Theme.of(context).textTheme.bodyMedium,
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

  void _showEditBottomSheet(BuildContext context, UserProfile? profile) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: profile?.fullName ?? '');
    final roleController =
        TextEditingController(text: profile?.targetRole ?? '');
    final goalController =
        TextEditingController(text: profile?.careerGoal ?? '');
    String? selectedStatus = profile?.workStatus;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setBottomSheetState) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                l10n.profile,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              Column(
                spacing: AppSizes.md,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: l10n.fullName,
                      prefixIcon: const Icon(Iconsax.user),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.sm)),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: selectedStatus,
                    decoration: InputDecoration(
                      labelText: l10n.status,
                      prefixIcon: const Icon(Iconsax.status),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.sm)),
                    ),
                    items: [
                      DropdownMenuItem(
                          value: 'fresh_grad', child: Text(l10n.freshGraduate)),
                      DropdownMenuItem(
                          value: 'working', child: Text(l10n.currentlyWorking)),
                      DropdownMenuItem(
                          value: 'job_seeking', child: Text(l10n.lookingForJob)),
                      DropdownMenuItem(
                          value: 'freelancer', child: Text(l10n.freelancer)),
                    ],
                    onChanged: (value) {
                      setBottomSheetState(() => selectedStatus = value);
                    },
                  ),
                  TextField(
                    controller: roleController,
                    decoration: InputDecoration(
                      labelText: l10n.targetRole,
                      prefixIcon: const Icon(Iconsax.briefcase),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.sm)),
                    ),
                  ),
                  TextField(
                    controller: goalController,
                    decoration: InputDecoration(
                      labelText: l10n.goal,
                      prefixIcon: const Icon(Iconsax.direct_up),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.sm)),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.sm)),
                      ),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _updateProfile(
                          context,
                          fullName: nameController.text.trim(),
                          workStatus: selectedStatus,
                          targetRole: roleController.text.trim(),
                          careerGoal: goalController.text.trim(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.sm)),
                      ),
                      child: Text(l10n.save),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.only(
          bottom: 32,
          top: 8,
          left: 24,
          right: 24,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Iconsax.logout,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.logout,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              l10n.confirmLogout,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      await authProvider.signOut();
                      if (context.mounted) {
                        context.router.replaceAll([const AuthRoute()]);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(l10n.logout),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
