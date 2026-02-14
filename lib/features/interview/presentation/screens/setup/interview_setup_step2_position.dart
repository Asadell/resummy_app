import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class InterviewSetupStep2Screen extends StatefulWidget {
  const InterviewSetupStep2Screen({super.key});

  @override
  State<InterviewSetupStep2Screen> createState() => _InterviewSetupStep2ScreenState();
}

class _InterviewSetupStep2ScreenState extends State<InterviewSetupStep2Screen> {
  final _positionController = TextEditingController(text: 'Software Engineer');
  final _companyController = TextEditingController(text: 'PT Tech Startup Indonesia');
  int _selectedLevel = 1; // 0: Junior, 1: Mid, 2: Senior
  String _selectedIndustry = 'Technology';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<InterviewProvider>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.setupInterview),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.push(const InterviewSetupStep1Route()),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                l10n.stepProgress(2, 5),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Success Indicator
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.tick_circle, color: Theme.of(context).colorScheme.secondary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${l10n.cvLabel} ${provider.cvFileName ?? l10n.cvDefaultLabel}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Form
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Position Field
                    Text(
                      l10n.appliedPositionLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _positionController,
                      decoration: InputDecoration(
                        hintText: l10n.targetRoleHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.autoFillFromProfile,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Company Field
                    Text(
                      l10n.companyNameLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _companyController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Google, Microsoft',
                        prefixIcon: const Icon(Iconsax.building_3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Level Position
                    Text(
                      l10n.positionLevelLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        _buildLevelOption(0, l10n.juniorLevel),
                        const SizedBox(height: 8),
                        _buildLevelOption(1, l10n.midLevel),
                        const SizedBox(height: 8),
                        _buildLevelOption(2, l10n.seniorLevel),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Industry
                    Text(
                      l10n.industryLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedIndustry,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: ['Technology', 'Finance', 'Healthcare', 'Education', 'Other']
                          .map((industry) {
                            String label = industry;
                            switch (industry) {
                              case 'Technology': label = l10n.industryTechnology; break;
                              case 'Finance': label = l10n.industryFinance; break;
                              case 'Healthcare': label = l10n.industryHealthcare; break;
                              case 'Education': label = l10n.industryEducation; break;
                              case 'Other': label = l10n.industryOther; break;
                            }
                            return DropdownMenuItem(
                                value: industry,
                                child: Text(label),
                            );
                          })
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedIndustry = value);
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Info Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Iconsax.lamp_on, color: Theme.of(context).colorScheme.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.dataHelpsAiTailor,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light ? Colors.black.withValues(alpha: 0.05) : Colors.transparent,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.router.push(const InterviewSetupStep1Route()),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text('← ${l10n.back}'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    final provider = context.read<InterviewProvider>();
                    final position = _positionController.text;
                    final level = _selectedLevel == 0 ? l10n.juniorLevel : _selectedLevel == 1 ? l10n.midLevel : l10n.seniorLevel;
                    final fullRole = "$level $position";
                    
                    provider.updateRole(fullRole);
                    provider.updateCompanyName(_companyController.text);
                    context.router.push(const InterviewSetupStep3Route());
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text('${l10n.continueText} →'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelOption(int index, String label) {
    final isSelected = _selectedLevel == index;
    return InkWell(
      onTap: () => setState(() => _selectedLevel = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).cardTheme.color,
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerTheme.color!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Iconsax.record_circle : Iconsax.stop_circle,
              color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _positionController.dispose();
    _companyController.dispose();
    super.dispose();
  }
}