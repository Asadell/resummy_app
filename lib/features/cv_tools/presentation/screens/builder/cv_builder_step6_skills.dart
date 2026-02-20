import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_builder_step_layout.dart';
import 'package:resummy_app/features/cv_tools/presentation/utils/dynamic_cv_steps.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';

@RoutePage()
class CvBuilderStep6Screen extends StatelessWidget {
  const CvBuilderStep6Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<CVBuilderProvider>(
      builder: (context, provider, _) {
        final cv = provider.currentCV;
        if (cv == null) {
          return Scaffold(
            body: Center(child: Text(l10n.noCvData)),
          );
        }

        final currentStep = DynamicCvSteps.getStepForSection(context, 'skills');

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
    final l10n = AppLocalizations.of(context)!;
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
          SnackBar(content: Text(l10n.skillCategoryAdded)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<CVBuilderProvider>(
      builder: (context, provider, child) {
        final skillsSection =
            provider.currentCV?.sections.whereType<SkillsSection>().firstOrNull;

        if (skillsSection == null) {
          return Center(child: Text(l10n.sectionNotFound));
        }

        final categories = skillsSection.skillCategories;
        final currentStep = DynamicCvSteps.getStepForSection(context, 'skills');
        final totalSteps = DynamicCvSteps.getTotalSteps(provider.currentCV);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSection(
                child: Column(
                  spacing: AppSizes.sm,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm, vertical: AppSizes.xs),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(AppSizes.xl),
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
                    Text(
                      l10n.skillsHeader,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      l10n.skillsDesc,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              if (categories.isNotEmpty)
                AppSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.addedCategories,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: AppSizes.md),
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        onReorder: (oldIndex, newIndex) {
                          provider.reorderSkillCategories(oldIndex, newIndex);
                        },
                        itemBuilder: (context, index) {
                          final entry = categories.entries.elementAt(index);
                          return _SkillCategoryCard(
                            key: ValueKey(entry.key),
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
                            l10n: l10n,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSizes.sm),
              AppSection(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: AppSizes.md,
                    children: [
                      Text(
                        l10n.addNewCategory,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      TextFormField(
                        controller: _categoryController,
                        decoration: InputDecoration(
                          labelText: l10n.categoryName,
                          hintText: l10n.categoryNamePlaceholder,
                          border: InputBorder.none,
                          prefixIcon: const Icon(Iconsax.tag),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (value) => value == null || value.isEmpty
                            ? l10n.categoryRequired
                            : null,
                      ),
                      TextFormField(
                        controller: _skillsController,
                        decoration: InputDecoration(
                          labelText: l10n.skills,
                          hintText: l10n.skillsHint,
                          border: InputBorder.none,
                          prefixIcon: const Icon(Iconsax.code),
                        ),
                        maxLines: 3,
                        validator: (value) => value == null || value.isEmpty
                            ? l10n.skillsRequired
                            : null,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _addCategory(provider),
                          icon: const Icon(Iconsax.add),
                          label: Text(l10n.addCategory),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.md),
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
    final l10n = AppLocalizations.of(context)!;
    final categoryController = TextEditingController(text: oldCategory);
    final skillsController =
        TextEditingController(text: currentSkills.join(', '));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
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
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Iconsax.edit_2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.editSkillCategory,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: '${l10n.categoryName} *',
                border: InputBorder.none,
                prefixIcon: const Icon(Iconsax.tag),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: skillsController,
              decoration: InputDecoration(
                labelText: '${l10n.skills} *',
                hintText: l10n.skillsHint,
                border: InputBorder.none,
                prefixIcon: const Icon(Iconsax.code),
              ),
              maxLines: 3,
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
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(l10n.save),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteCategoryDialog(
    BuildContext context,
    CVBuilderProvider provider,
    String category,
  ) {
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
                    Iconsax.trash,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.deleteCategory,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              l10n.deleteCategoryConfirmation(category),
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
                    onPressed: () {
                      provider.removeSkillCategory(category);
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(l10n.delete),
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

class _SkillCategoryCard extends StatelessWidget {
  final String categoryName;
  final List<String> skills;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final AppLocalizations l10n;

  const _SkillCategoryCard({
    super.key,
    required this.categoryName,
    required this.skills,
    required this.onEdit,
    required this.onDelete,
    required this.l10n,
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
                const Icon(Icons.drag_indicator, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
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
                  tooltip: l10n.edit,
                ),
                IconButton(
                  icon: const Icon(Iconsax.trash, size: 20, color: Colors.red),
                  onPressed: onDelete,
                  tooltip: l10n.delete,
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
