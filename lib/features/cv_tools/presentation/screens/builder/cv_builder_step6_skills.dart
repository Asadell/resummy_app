import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_builder_step_layout.dart';
import 'package:resummy_app/features/cv_tools/presentation/utils/dynamic_cv_steps.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class CvBuilderStep6Screen extends StatelessWidget {
  const CvBuilderStep6Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CVBuilderProvider>(
      builder: (context, provider, _) {
        final cv = provider.currentCV;
        if (cv == null) {
          return Scaffold(
            body: Center(child: Text('No CV data')),
          );
        }

        final currentStep = DynamicCvSteps.getStepForSection(context, 'skills');
        final totalSteps = DynamicCvSteps.getTotalSteps(cv);
        final l10n = AppLocalizations.of(context)!;

        return CVBuilderStepLayout(
          title: l10n.cvBuilder,
          currentStep: currentStep,
          editContent: _SkillsForm(),
          onBack: () {
            DynamicCvSteps.navigateToPreviousStep(context, currentStep);
          },
          onNext: () {
            provider.saveCurrentCV();
            DynamicCvSteps.navigateToNextStep(context, currentStep);
          },
        );
      },
    );
  }
}

class _SkillsForm extends StatefulWidget {
  @override
  State<_SkillsForm> createState() => _SkillsFormState();
}

class _SkillsFormState extends State<_SkillsForm> {
  final _categoryController = TextEditingController();
  final _skillsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _categoryController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _addCategory(CVBuilderProvider provider) {
    if (_formKey.currentState!.validate()) {
      final skills = _skillsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      if (skills.isNotEmpty) {
        provider.addSkillCategory(
          _categoryController.text.trim(),
          skills,
        );
        _categoryController.clear();
        _skillsController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Skill category added')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<CVBuilderProvider>(
      builder: (context, provider, child) {
        final skillsSection = provider.currentCV?.sections
            .whereType<SkillsSection>()
            .firstOrNull;

        if (skillsSection == null) {
          return const Center(child: Text('Skills section not found'));
        }

        final categories = skillsSection.skillCategories;
        final currentStep = DynamicCvSteps.getStepForSection(context, 'skills');
        final totalSteps = DynamicCvSteps.getTotalSteps(provider.currentCV);

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
                    l10n.stepHeader(currentStep, totalSteps),
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
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 24),

              // Tips Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Iconsax.info_circle, color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Skills Organization Tips:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '• Group skills by category (Technical, Languages, Tools)\n'
                            '• List most relevant skills first\n'
                            '• Be specific (Node.js instead of just JavaScript)\n'
                            '• Include proficiency levels if relevant',
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Existing Categories List
              if (categories.isNotEmpty) ...[
                 Text(
                  'Added Categories',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...categories.entries.map((entry) {
                  return _SkillCategoryCard(
                    categoryName: entry.key,
                    skills: entry.value,
                    onEdit: () => _showEditCategoryDialog(
                      context,
                      provider,
                      entry.key,
                      entry.value,
                    ),
                    onDelete: () => _showDeleteCategoryDialog(
                      context,
                      provider,
                      entry.key,
                    ),
                  );
                }),
                const SizedBox(height: 24),
                const Divider(thickness: 1),
                const SizedBox(height: 24),
              ],

              // Add New Category Form (Inline)
              Text(
                'Add New Category',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          labelText: 'Category Name',
                          hintText: 'e.g., Programming Languages',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Iconsax.tag),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _skillsController,
                        decoration: const InputDecoration(
                          labelText: 'Skills',
                          hintText: 'Separate with commas: Java, Python, C++',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Iconsax.code),
                        ),
                        maxLines: 3,
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _addCategory(provider),
                          icon: const Icon(Iconsax.add),
                          label: const Text('Add Category'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  void _showEditCategoryDialog(
    BuildContext context,
    CVBuilderProvider provider,
    String oldCategory,
    List<String> currentSkills,
  ) {
    final categoryController = TextEditingController(text: oldCategory);
    final skillsController = TextEditingController(text: currentSkills.join(', '));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Skill Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category Name *',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: skillsController,
              decoration: const InputDecoration(
                labelText: 'Skills *',
                hintText: 'Separate with commas',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (categoryController.text.trim().isNotEmpty &&
                  skillsController.text.trim().isNotEmpty) {
                final skills = skillsController.text
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();

                if (skills.isNotEmpty) {
                  provider.updateSkillCategory(
                    oldCategory,
                    categoryController.text.trim(),
                    skills,
                  );
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteCategoryDialog(
    BuildContext context,
    CVBuilderProvider provider,
    String category,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "$category" category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.removeSkillCategory(category);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SkillCategoryCard extends StatelessWidget {
  final String categoryName;
  final List<String> skills;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SkillCategoryCard({
    required this.categoryName,
    required this.skills,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.edit_2, size: 20),
                  onPressed: onEdit,
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Iconsax.trash, size: 20, color: Colors.red),
                  onPressed: onDelete,
                  tooltip: 'Delete',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills
                  .map((skill) => Chip(
                        label: Text(
                          skill,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.blue.shade50,
                        side: BorderSide(color: Colors.blue.shade200),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
