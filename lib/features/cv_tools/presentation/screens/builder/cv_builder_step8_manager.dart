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
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';

@RoutePage()
class CvBuilderStep8Screen extends StatefulWidget {
  const CvBuilderStep8Screen({super.key});

  @override
  State<CvBuilderStep8Screen> createState() => _CvBuilderStep8ScreenState();
}

class _CvBuilderStep8ScreenState extends State<CvBuilderStep8Screen> {
  String? _editingTitleSectionId;
  final Map<String, TextEditingController> _titleControllers = {};

  @override
  void dispose() {
    for (var controller in _titleControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(SectionData section) {
    if (!_titleControllers.containsKey(section.id)) {
      _titleControllers[section.id] =
          TextEditingController(text: section.title);
    }
    return _titleControllers[section.id]!;
  }

  IconData _getSectionIcon(SectionType type) {
    switch (type) {
      case SectionType.summary:
        return Iconsax.document_text;
      case SectionType.experience:
        return Iconsax.briefcase;
      case SectionType.education:
        return Iconsax.teacher;
      case SectionType.organization:
        return Iconsax.people;
      case SectionType.skills:
        return Iconsax.code;
      case SectionType.certifications:
        return Iconsax.award;
      case SectionType.custom:
        return Iconsax.add_square;
      default:
        return Iconsax.document;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<CVBuilderProvider>(
      builder: (context, provider, _) {
        final totalSteps = DynamicCvSteps.getTotalSteps(provider.currentCV);

        return CVBuilderStepLayout(
          title: l10n.cvBuilder,
          currentStep: totalSteps,
          onBack: () {
            DynamicCvSteps.navigateToPreviousStep(context, totalSteps);
          },
          onNext: () async {
            await provider.saveCurrentCV();
            if (context.mounted) {
              final router = context.router;
              router.push(const CvBuilderPreviewRoute());
            }
          },
          nextLabel: l10n.previewCV,
          editContent:
              _buildContent(context, provider, totalSteps, theme, isDark, l10n),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, CVBuilderProvider provider,
      int totalSteps, ThemeData theme, bool isDark, AppLocalizations l10n) {
    final cv = provider.currentCV;
    if (cv == null) {
      return Center(child: Text(l10n.noCvData));
    }

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
                    color: theme.cardColor,
                    border: Border.all(color: theme.primaryColor),
                    borderRadius: BorderRadius.circular(AppSizes.xl),
                  ),
                  child: Text(
                    l10n.stepHeader(totalSteps, totalSteps),
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  l10n.sectionManagerTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  l10n.sectionManagerDesc,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          AppSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cv.sections.length,
                  proxyDecorator:
                      (Widget child, int index, Animation<double> animation) {
                    return child;
                  },
                  onReorder: (oldIndex, newIndex) {
                    provider.reorderSections(oldIndex, newIndex);
                  },
                  itemBuilder: (context, index) {
                    final section = cv.sections[index];

                    return _buildSectionCard(section, provider, index, context);
                  },
                ),
                const SizedBox(height: AppSizes.md),
                OutlinedButton.icon(
                  onPressed: () => _showAddCustomSectionDialog(provider),
                  icon: const Icon(Iconsax.add),
                  label: Text(l10n.addCustomSection),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.sm),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSectionCard(SectionData section, CVBuilderProvider provider,
      int index, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = _editingTitleSectionId == section.id;
    final controller = _getController(section);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      key: ValueKey(section.id),
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      elevation: section.isVisible ? 2 : 0,
      color: section.isVisible
          ? theme.cardColor
          : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.menu_1, color: theme.disabledColor, size: 20),
                const SizedBox(width: AppSizes.sm),
                Icon(
                  _getSectionIcon(section.type),
                  color: section.isVisible
                      ? theme.primaryColor
                      : theme.disabledColor,
                  size: 20,
                ),
                const SizedBox(width: AppSizes.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.xs, vertical: 4),
                  decoration: BoxDecoration(
                    color: section.isVisible
                        ? theme.primaryColor.withValues(alpha: 0.1)
                        : theme.disabledColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: section.isVisible
                          ? theme.primaryColor
                          : theme.disabledColor,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: isEditing
                      ? TextField(
                          controller: controller,
                          autofocus: true,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppSizes.xs,
                              vertical: 4,
                            ),
                            border: OutlineInputBorder(),
                            counterText: '',
                          ),
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              provider.updateSectionTitle(
                                  section.id, value.trim());
                            }
                            setState(() {
                              _editingTitleSectionId = null;
                            });
                          },
                          maxLength: 30,
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              _editingTitleSectionId = section.id;
                            });
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  section.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: section.isVisible
                                        ? theme.textTheme.bodyLarge?.color
                                        : theme.disabledColor,
                                  ),
                                ),
                              ),
                              Icon(
                                Iconsax.edit_2,
                                size: 16,
                                color: theme.disabledColor,
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(width: AppSizes.sm),
                Switch(
                  value: section.isVisible,
                  onChanged: (value) {
                    provider.toggleSectionVisibility(section.id);
                  },
                  activeThumbColor: theme.primaryColor,
                ),
              ],
            ),
            if (section is ExperienceSection ||
                section is EducationSection ||
                section is OrganizationSection ||
                section is CertificationsSection) ...[
              const SizedBox(height: AppSizes.xs),
              Row(
                children: [
                  const SizedBox(width: 44),
                  Icon(Iconsax.document, size: 14, color: theme.disabledColor),
                  const SizedBox(width: 4),
                  Text(
                    l10n.entriesCount(_getEntryCount(section)),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ],
            if (section is CustomSection) ...[
              const SizedBox(height: AppSizes.xs),
              Row(
                children: [
                  const SizedBox(width: 44),
                  TextButton.icon(
                    onPressed: () => _showDeleteConfirmation(provider, section),
                    icon:
                        const Icon(Iconsax.trash, size: 16, color: Colors.red),
                    label: Text(
                      AppLocalizations.of(context)!.deleteSection,
                      style: const TextStyle(color: Colors.red),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _getEntryCount(SectionData section) {
    if (section is ExperienceSection) return section.entries.length;
    if (section is EducationSection) return section.entries.length;
    if (section is OrganizationSection) return section.entries.length;
    if (section is CertificationsSection) return section.entries.length;
    return 0;
  }

  void _showAddCustomSectionDialog(CVBuilderProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    CustomSectionTemplate selectedTemplate =
        CustomSectionTemplate.experienceLike;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.selectSectionFormat,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              ...CustomSectionTemplate.values.map((template) {
                final isSelected = selectedTemplate == template;
                return GestureDetector(
                  onTap: () => setState(() => selectedTemplate = template),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppSizes.sm),
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.08)
                          : Theme.of(context).cardColor,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.sm),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getTemplateIcon(template),
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getTemplateName(template),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _getTemplateDesc(template),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    String defaultTitle;
                    switch (selectedTemplate) {
                      case CustomSectionTemplate.experienceLike:
                        defaultTitle = l10n.projectExperience;
                        break;
                      case CustomSectionTemplate.educationLike:
                        defaultTitle = l10n.courseCertification;
                        break;
                      case CustomSectionTemplate.skillsLike:
                        defaultTitle = l10n.otherSkills;
                        break;
                      case CustomSectionTemplate.bulletList:
                        defaultTitle = l10n.additionalInfo;
                        break;
                      case CustomSectionTemplate.paragraph:
                        defaultTitle = l10n.briefProfile;
                        break;
                    }

                    provider.addCustomSection(
                      defaultTitle,
                      template: selectedTemplate,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.createSection,
                      style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTemplateIcon(CustomSectionTemplate template) {
    switch (template) {
      case CustomSectionTemplate.experienceLike:
        return Iconsax.briefcase;
      case CustomSectionTemplate.educationLike:
        return Iconsax.teacher;
      case CustomSectionTemplate.skillsLike:
        return Iconsax.code;
      case CustomSectionTemplate.bulletList:
        return Iconsax.menu;
      case CustomSectionTemplate.paragraph:
        return Iconsax.document_text;
    }
  }

  void _showDeleteConfirmation(
      CVBuilderProvider provider, CustomSection section) {
    if (!mounted) return;
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
                    l10n.deleteSection,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              l10n.deleteSectionConfirmation,
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
                      provider.deleteCustomSection(section.id);
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

  String _getTemplateName(CustomSectionTemplate template) {
    final l10n = AppLocalizations.of(context)!;
    switch (template) {
      case CustomSectionTemplate.experienceLike:
        return l10n.templateExperienceName;
      case CustomSectionTemplate.educationLike:
        return l10n.templateEducationName;
      case CustomSectionTemplate.skillsLike:
        return l10n.templateSkillsName;
      case CustomSectionTemplate.bulletList:
        return l10n.templateBulletName;
      case CustomSectionTemplate.paragraph:
        return l10n.templateParagraphName;
    }
  }

  String _getTemplateDesc(CustomSectionTemplate template) {
    final l10n = AppLocalizations.of(context)!;
    switch (template) {
      case CustomSectionTemplate.experienceLike:
        return l10n.templateExperienceDesc;
      case CustomSectionTemplate.educationLike:
        return l10n.templateEducationDesc;
      case CustomSectionTemplate.skillsLike:
        return l10n.templateSkillsDesc;
      case CustomSectionTemplate.bulletList:
        return l10n.templateBulletDesc;
      case CustomSectionTemplate.paragraph:
        return l10n.templateParagraphDesc;
    }
  }
}
