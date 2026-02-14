import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_builder_step_layout.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class CvBuilderStep5Screen extends StatefulWidget {
  const CvBuilderStep5Screen({super.key});

  @override
  State<CvBuilderStep5Screen> createState() => _CvBuilderStep5ScreenState();
}

class _CvBuilderStep5ScreenState extends State<CvBuilderStep5Screen> {
  final TextEditingController _skillController = TextEditingController();
  final FocusNode _skillFocusNode = FocusNode();

  @override
  void dispose() {
    _skillController.dispose();
    _skillFocusNode.dispose();
    super.dispose();
  }

  void _addSkill(CVBuilderProvider provider) {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty) {
      provider.addSkill(skill);
      _skillController.clear();
      // Keep focus to add more
      _skillFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CVBuilderStepLayout(
      title: l10n.cvBuilder,
      currentStep: 5,
      totalSteps: 7,
      onBack: () => context.router.maybePop(),
      onNext: () {
        context.read<CVBuilderProvider>().saveCurrentCV();
        context.router.push(const CvBuilderStep6Route());
      },
      editContent: Consumer<CVBuilderProvider>(
        builder: (context, provider, child) {
          final skills = provider.currentCV?.skills ?? [];
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step Header
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.stepHeader(5, 7),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    l10n.skillsHeader,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    l10n.skillsDesc,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Input Field
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).dividerColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.addSkill,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _skillController,
                              focusNode: _skillFocusNode,
                              decoration: InputDecoration(
                                hintText: l10n.skillHint,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              onSubmitted: (_) => _addSkill(provider),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () => _addSkill(provider),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              minimumSize: const Size(48, 48),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Icon(Iconsax.add),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.skillTip,
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 12,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      // AI Suggestion (Placeholder)
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.featureComingSoon)),
                          );
                        },
                        icon: const Icon(Iconsax.magic_star, size: 18),
                        label: Text(l10n.aiSuggestion),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.purple,
                          side: const BorderSide(color: Colors.purple),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Skills List
                if (skills.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Iconsax.task_square, size: 48, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noSkillsData,
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: skills.map((skill) {
                      return Chip(
                        label: Text(skill),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => provider.removeSkill(skill),
                        backgroundColor: Theme.of(context).cardColor,
                        side: BorderSide(color: Theme.of(context).dividerColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }).toList(),
                  ),
                  
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }
}
