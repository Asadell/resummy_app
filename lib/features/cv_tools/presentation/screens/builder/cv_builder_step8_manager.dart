
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_builder_step_layout.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

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
      _titleControllers[section.id] = TextEditingController(text: section.title);
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

    return CVBuilderStepLayout(
      title: l10n.cvBuilder,
      currentStep: 8,
      totalSteps: 8,
      onBack: () => context.router.maybePop(),
      onNext: () {
        context.read<CVBuilderProvider>().saveCurrentCV();
        final router = context.router;
        router.push(const CvBuilderPreviewRoute());
      },
      nextLabel: l10n.previewCV,
      editContent: Consumer<CVBuilderProvider>(
        builder: (context, provider, child) {
          final cv = provider.currentCV;
          if (cv == null) {
            return Center(child: Text(l10n.noCvData));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      border: Border.all(color: theme.primaryColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.stepHeader(8, 8),
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                Center(
                  child: Text(
                    l10n.sectionManagerTitle,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                
                Center(
                  child: Text(
                    l10n.sectionManagerDesc,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 24),

                // Info Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.info_circle, color: theme.primaryColor, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.sectionManagerTips,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : theme.primaryColor.withOpacity(0.9),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Reorderable Section List
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cv.sections.length,
                  onReorder: (oldIndex, newIndex) {
                    provider.reorderSections(oldIndex, newIndex);
                  },
                  itemBuilder: (context, index) {
                    final section = cv.sections[index];
                    // Skip header section in reordering visual if desired, but user wants reordering. 
                    // Header is fixed at top usually. Let's assume header is NOT in reorder list or displayed differently?
                    // CVData struct puts header separate. `sections` only contains reorderable body sections.
                    // Wait, `CVData` has `header` field AND `sections`. So `sections` are body sections. Yes.
                    return _buildSectionCard(section, provider, index, context);
                  },
                ),

                const SizedBox(height: 24),

                // Add Custom Section Button
                OutlinedButton.icon(
                  onPressed: () => _showAddCustomSectionDialog(provider),
                  icon: const Icon(Iconsax.add),
                  label: Text(l10n.addCustomSection),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard(SectionData section, CVBuilderProvider provider, int index, BuildContext context) {
    final isEditing = _editingTitleSectionId == section.id;
    final controller = _getController(section);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      key: ValueKey(section.id),
      margin: const EdgeInsets.only(bottom: 12),
      elevation: section.isVisible ? 2 : 0,
      color: section.isVisible 
          ? theme.cardColor 
          : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Drag Handle
                Icon(Iconsax.menu_1, color: theme.disabledColor, size: 20),
                const SizedBox(width: 12),

                // Section Icon
                Icon(
                  _getSectionIcon(section.type),
                  color: section.isVisible ? theme.primaryColor : theme.disabledColor,
                  size: 20,
                ),
                const SizedBox(width: 12),

                // Section Number
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: section.isVisible 
                        ? theme.primaryColor.withOpacity(0.1)
                        : theme.disabledColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: section.isVisible ? theme.primaryColor : theme.disabledColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Section Title or Edit Field
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
                            counterText: '',
                          ),
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              provider.updateSectionTitle(section.id, value.trim());
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

                const SizedBox(width: 12),

                // Visibility Toggle
                Switch(
                  value: section.isVisible,
                  onChanged: (value) {
                    provider.toggleSectionVisibility(section.id);
                  },
                  activeColor: theme.primaryColor,
                ),
              ],
            ),

            // Entry Count
            if (section is ExperienceSection ||
                section is EducationSection ||
                section is OrganizationSection ||
                section is CertificationsSection) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(width: 44),
                  Icon(Iconsax.document, size: 14, color: theme.disabledColor),
                  const SizedBox(width: 4),
                  Text(
                    '${_getEntryCount(section)} entries',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ],

            // Delete Button for Custom Sections
            if (section is CustomSection) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(width: 44),
                  TextButton.icon(
                    onPressed: () => _showDeleteConfirmation(provider, section),
                    icon: const Icon(Iconsax.trash, size: 16, color: Colors.red),
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
    final titleController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    SectionTemplate selectedTemplate = SectionTemplate.simpleList;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.addCustomSection),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: l10n.sectionLabel,
                  hintText: l10n.sectionLabelHint,
                  border: const OutlineInputBorder(),
                  counterText: '',
                ),
                autofocus: true,
                maxLength: 30,
              ),
              const SizedBox(height: 16),
              
              const Text(
                'Template:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              
              DropdownButtonFormField<SectionTemplate>(
                value: selectedTemplate,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: SectionTemplate.values.map((template) {
                  return DropdownMenuItem(
                    value: template,
                    child: Text(template.name.toUpperCase()), // Simplified for now
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedTemplate = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  provider.addCustomSection(
                    titleController.text.trim(),
                    template: selectedTemplate,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(CVBuilderProvider provider, SectionData section) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteSection),
        content: Text(l10n.deleteSectionConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              provider.deleteCustomSection(section.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
