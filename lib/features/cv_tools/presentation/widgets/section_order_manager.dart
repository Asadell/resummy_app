import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

class SectionOrderManager extends StatefulWidget {
  const SectionOrderManager({super.key});

  @override
  State<SectionOrderManager> createState() => _SectionOrderManagerState();
}

class _SectionOrderManagerState extends State<SectionOrderManager> {
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
        return Iconsax.book;
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
    final provider = context.watch<CVBuilderProvider>();
    final cv = provider.currentCV;

    if (cv == null) {
      return Center(
        child: Text(
          l10n.noCvData,
          style: const TextStyle(color: Color(0xFF9CA3AF)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sectionOrderVisibility),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFEFF6FF),
            child: Row(
              children: [
                const Icon(Iconsax.info_circle,
                    color: Color(0xFF0EA5E9), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.sectionOrderTip,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cv.sections.length,
              onReorder: (oldIndex, newIndex) {
                provider.reorderSections(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final section = cv.sections[index];
                return _buildSectionCard(context, section, provider, l10n);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: () =>
                  _showAddCustomSectionDialog(context, provider, l10n),
              icon: const Icon(Iconsax.add),
              label: Text(l10n.addCustomSection),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    SectionData section,
    CVBuilderProvider provider,
    AppLocalizations l10n,
  ) {
    final isEditing = _editingTitleSectionId == section.id;
    final controller = _getController(section);

    return Card(
      key: ValueKey(section.id),
      margin: const EdgeInsets.only(bottom: 12),
      elevation: section.isVisible ? 2 : 0,
      color: section.isVisible ? Colors.white : Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Iconsax.menu,
                  color: Color(0xFF9CA3AF),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Icon(
                  _getSectionIcon(section.type),
                  color:
                      section.isVisible ? const Color(0xFF0EA5E9) : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
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
                              horizontal: 8,
                              vertical: 4,
                            ),
                            border: OutlineInputBorder(),
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
                        )
                      : Text(
                          section.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: section.isVisible
                                ? Colors.black87
                                : Colors.grey,
                          ),
                        ),
                ),
                if (!isEditing)
                  IconButton(
                    icon: const Icon(Iconsax.edit_2, size: 18),
                    onPressed: () {
                      setState(() {
                        _editingTitleSectionId = section.id;
                      });
                    },
                    tooltip: l10n.edit,
                  ),
                if (isEditing)
                  IconButton(
                    icon: const Icon(Iconsax.tick_circle, size: 18),
                    color: const Color(0xFF10B981),
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        provider.updateSectionTitle(
                            section.id, controller.text.trim());
                      }
                      setState(() {
                        _editingTitleSectionId = null;
                      });
                    },
                    tooltip: l10n.save,
                  ),
                const SizedBox(width: 8),
                Switch(
                  value: section.isVisible,
                  onChanged: (value) {
                    provider.toggleSectionVisibility(section.id);
                  },
                  activeThumbColor: const Color(0xFF0EA5E9),
                ),
              ],
            ),
            if (section is CustomSection) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  _showDeleteConfirmation(context, provider, section, l10n);
                },
                icon: const Icon(Iconsax.trash, size: 16, color: Colors.red),
                label: Text(
                  l10n.deleteSection,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddCustomSectionDialog(
      BuildContext context, CVBuilderProvider provider, AppLocalizations l10n) {
    final titleController = TextEditingController();
    CustomSectionTemplate selectedTemplate = CustomSectionTemplate.bulletList;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
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
                      Iconsax.add_square,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      l10n.addCustomSection,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: l10n.categoryName,
                  hintText: l10n.sectionLabelHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Iconsax.edit_2),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              Text(
                '${l10n.templateLabel}:',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<CustomSectionTemplate>(
                initialValue: selectedTemplate,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: CustomSectionTemplate.values.map((template) {
                  return DropdownMenuItem(
                    value: template,
                    child: Text(_getTemplateName(template, l10n)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setModalState(() {
                      selectedTemplate = value;
                    });
                  }
                },
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
                        if (titleController.text.trim().isNotEmpty) {
                          provider.addCustomSection(
                            titleController.text.trim(),
                            template: selectedTemplate,
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(l10n.add),
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

  void _showDeleteConfirmation(
    BuildContext context,
    CVBuilderProvider provider,
    CustomSection section,
    AppLocalizations l10n,
  ) {
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
              l10n.deleteItemConfirmation(section.title),
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

  String _getTemplateName(
      CustomSectionTemplate template, AppLocalizations l10n) {
    switch (template) {
      case CustomSectionTemplate.experienceLike:
        return l10n.templateExperienceNameLabel;
      case CustomSectionTemplate.educationLike:
        return l10n.templateEducationNameLabel;
      case CustomSectionTemplate.skillsLike:
        return l10n.templateSkillsNameLabel;
      case CustomSectionTemplate.bulletList:
        return l10n.templateBulletNameLabel;
      case CustomSectionTemplate.paragraph:
        return l10n.templateParagraphNameLabel;
    }
  }
}
