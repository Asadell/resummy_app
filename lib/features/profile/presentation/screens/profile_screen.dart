import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/providers/auth_provider.dart';
import 'package:resummy_app/core/providers/locale_provider.dart';
import 'package:resummy_app/core/providers/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';
import 'package:resummy_app/features/auth/data/user_profile_repository.dart';
import 'package:resummy_app/features/auth/domain/user_profile_model.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _repository = UserProfileRepository();
  UserProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      final profile = await _repository.getUserProfile(authProvider.user!.uid);
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
      ),
      body: SafeArea(
        child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                              backgroundImage: authProvider.photoUrl != null
                                  ? NetworkImage(authProvider.photoUrl!)
                                  : null,
                              child: authProvider.photoUrl == null
                                  ? Icon(
                                      Iconsax.user,
                                      size: 48,
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _profile?.fullName ?? authProvider.displayName,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              _profile?.email ?? authProvider.email,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Profile Info Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Profile Info',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Iconsax.edit),
                                  onPressed: () => _showEditDialog(context),
                                ),
                              ],
                            ),
                            const Divider(),
                            _buildProfileRow(context, l10n.status, _getStatusLabel(context, _profile?.workStatus)),
                            _buildProfileRow(context, l10n.targetRole, _profile?.targetRole ?? '-'),
                            _buildProfileRow(context, l10n.goal, _profile?.careerGoal ?? '-'),
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
                      onPressed: () => _showLogoutDialog(context),
                    ),

                    if (kDebugMode) ...[
                      const SizedBox(height: 50),
                      OutlinedButton(
                        onPressed: () {
                          context.read<InterviewProvider>().startInterviewWithDummyData();
                          context.router.push(const InterviewSessionClosingRoute());
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          side: BorderSide(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
                        ),
                        child: const Text('DEBUG: Skip with 5 Questions'),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProfileRow(BuildContext context, String label, String value) {
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

  void _showEditDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: _profile?.fullName ?? '');
    final roleController = TextEditingController(text: _profile?.targetRole ?? '');
    final goalController = TextEditingController(text: _profile?.careerGoal ?? '');
    String? selectedStatus = _profile?.workStatus;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.edit),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l10n.fullName),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedStatus,
                  decoration: InputDecoration(labelText: l10n.status),
                  items: [
                    DropdownMenuItem(value: 'fresh_grad', child: Text(l10n.freshGraduate)),
                    DropdownMenuItem(value: 'working', child: Text(l10n.currentlyWorking)),
                    DropdownMenuItem(value: 'job_seeking', child: Text(l10n.lookingForJob)),
                    DropdownMenuItem(value: 'freelancer', child: Text(l10n.freelancer)),
                  ],
                  onChanged: (value) {
                    setDialogState(() => selectedStatus = value);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: roleController,
                  decoration: InputDecoration(labelText: l10n.targetRole),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: goalController,
                  decoration: InputDecoration(labelText: l10n.goal),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _updateProfile(
                  fullName: nameController.text.trim(),
                  workStatus: selectedStatus,
                  targetRole: roleController.text.trim(),
                  careerGoal: goalController.text.trim(),
                );
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile({
    required String fullName,
    String? workStatus,
    String? targetRole,
    String? careerGoal,
  }) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user == null) return;

    await _repository.updateUserProfile(authProvider.user!.uid, {
      'fullName': fullName.isNotEmpty ? fullName : authProvider.displayName,
      'workStatus': workStatus,
      'targetRole': targetRole?.isNotEmpty == true ? targetRole : null,
      'careerGoal': careerGoal?.isNotEmpty == true ? careerGoal : null,
    });

    await _loadProfile();
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            onPressed: () async {
              Navigator.pop(context);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.signOut();
              if (context.mounted) {
                context.router.replaceAll([const AuthRoute()]);
              }
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}
