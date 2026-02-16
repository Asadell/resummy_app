import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

/// Widget for managing section order, visibility, and titles
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
        title: const Text('Section Order & Visibility'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFEFF6FF),
            child: Row(
              children: [
                const Icon(Iconsax.info_circle, color: Color(0xFF0EA5E9), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Drag sections to reorder, toggle visibility, or edit titles',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Reorderable section list
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

          // Add custom section button
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: () => _showAddCustomSectionDialog(context, provider),
              icon: const Icon(Iconsax.add),
              label: const Text('Add Custom Section'),
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
                // Drag handle
                const Icon(
                  Iconsax.menu,
                  color: Color(0xFF9CA3AF),
                  size: 20,
                ),
                const SizedBox(width: 12),

                // Section icon
                Icon(
                  _getSectionIcon(section.type),
                  color: section.isVisible ? const Color(0xFF0EA5E9) : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),

                // Section title or edit field
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
                              provider.updateSectionTitle(section.id, value.trim());
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
                            color: section.isVisible ? Colors.black87 : Colors.grey,
                          ),
                        ),
                ),

                // Edit title button
                if (!isEditing)
                  IconButton(
                    icon: const Icon(Iconsax.edit_2, size: 18),
                    onPressed: () {
                      setState(() {
                        _editingTitleSectionId = section.id;
                      });
                    },
                    tooltip: 'Edit title',
                  ),

                // Save button when editing
                if (isEditing)
                  IconButton(
                    icon: const Icon(Iconsax.tick_circle, size: 18),
                    color: const Color(0xFF10B981),
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        provider.updateSectionTitle(section.id, controller.text.trim());
                      }
                      setState(() {
                        _editingTitleSectionId = null;
                      });
                    },
                    tooltip: 'Save',
                  ),

                const SizedBox(width: 8),

                // Visibility toggle
                Switch(
                  value: section.isVisible,
                  onChanged: (value) {
                    provider.toggleSectionVisibility(section.id);
                  },
                  activeThumbColor: const Color(0xFF0EA5E9),
                ),
              ],
            ),

            // Delete button for custom sections
            if (section is CustomSection) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  _showDeleteConfirmation(context, provider, section);
                },
                icon: const Icon(Iconsax.trash, size: 16, color: Colors.red),
                label: const Text(
                  'Delete Section',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddCustomSectionDialog(BuildContext context, CVBuilderProvider provider) {
    final titleController = TextEditingController();
    SectionTemplate selectedTemplate = SectionTemplate.simpleList;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Custom Section'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Section Title',
                  hintText: 'e.g., Publications, Awards, Projects',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              const Text(
                'Template:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<SectionTemplate>(
                initialValue: selectedTemplate,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: SectionTemplate.values.map((template) {
                  return DropdownMenuItem(
                    value: template,
                    child: Text(_templateName(template)),
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
              child: const Text('Cancel'),
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
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    CVBuilderProvider provider,
    CustomSection section,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Section'),
        content: Text('Are you sure you want to delete "${section.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteCustomSection(section.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _templateName(SectionTemplate template) {
    switch (template) {
      case SectionTemplate.bulletList:
        return 'Bullet List';
      case SectionTemplate.categoryList:
        return 'Category List';
      case SectionTemplate.paragraph:
        return 'Paragraph';
      case SectionTemplate.simpleList:
        return 'Simple List';
    }
  }
}
