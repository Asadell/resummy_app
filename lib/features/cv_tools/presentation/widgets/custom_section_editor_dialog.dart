import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

/// Dialog untuk edit content custom section
/// Ini yang tadinya KURANG! Makanya custom section gabisa diisi
class CustomSectionEditorDialog extends StatefulWidget {
  final CVBuilderProvider provider;
  final CustomSection section;

  const CustomSectionEditorDialog({
    super.key,
    required this.provider,
    required this.section,
  });

  @override
  State<CustomSectionEditorDialog> createState() => _CustomSectionEditorDialogState();
}

class _CustomSectionEditorDialogState extends State<CustomSectionEditorDialog> {
  late TextEditingController _contentController;
  late SectionTemplate _selectedTemplate;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.section.content);
    _selectedTemplate = widget.section.template;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.edit, color: theme.primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.editCustomSection ?? 'Edit Custom Section',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.section.title,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Template Selector
                    Text(
                      l10n.templateLabel ?? 'Template:',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    DropdownButtonFormField<SectionTemplate>(
                      value: _selectedTemplate,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: SectionTemplate.values.map((template) {
                        return DropdownMenuItem(
                          value: template,
                          child: Text(_getTemplateName(template)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedTemplate = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Template Instructions
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Iconsax.info_circle, 
                            color: Colors.blue.shade700, 
                            size: 20
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _getTemplateInstructions(_selectedTemplate),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade900,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Content Editor
                    Text(
                      l10n.contentLabel ?? 'Content:',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        hintText: _getTemplateHint(_selectedTemplate),
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 12,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                      onChanged: (val) {
                        setState(() {}); // Rebuild for preview & char count
                      },
                    ),

                    const SizedBox(height: 16),

                    // Character Count
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${_contentController.text.length} characters',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Preview Section
                    Text(
                      l10n.previewLabel ?? 'Preview:',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: _buildPreview(),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _save,
                    child: Text(l10n.save),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (_contentController.text.trim().isEmpty) {
      return Text(
        'Preview will appear here...',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade500,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    switch (_selectedTemplate) {
      case SectionTemplate.paragraph:
        return Text(
          _contentController.text,
          style: const TextStyle(
            fontSize: 13,
            height: 1.6,
            color: Colors.black87,
          ),
          textAlign: TextAlign.justify,
        );

      case SectionTemplate.bulletList:
      case SectionTemplate.simpleList:
        final lines = _contentController.text
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lines.map((line) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 13)),
                  Expanded(
                    child: Text(
                      line.trim(),
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );

      case SectionTemplate.categoryList:
        final lines = _contentController.text
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lines.map((line) {
            final parts = line.split(':');
            if (parts.length >= 2) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text: '${parts[0].trim()}: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: parts.sublist(1).join(':').trim(),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Text(
              line,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.black87,
              ),
            );
          }).toList(),
        );
    }
  }

  void _save() {
    // Update custom section content
    widget.provider.updateCustomSection(
      widget.section.id,
      _contentController.text.trim(),
    );

    // Also update template if changed
    if (_selectedTemplate != widget.section.template) {
      // We need to update the entire section with new template
      final currentCV = widget.provider.currentCV;
      if (currentCV != null) {
        final updatedSections = currentCV.sections.map((section) {
          if (section.id == widget.section.id && section is CustomSection) {
            return section.copyWith(
              content: _contentController.text.trim(),
              template: _selectedTemplate,
            );
          }
          return section;
        }).toList();

        // Update CV with new sections
        final updatedCV = currentCV.copyWith(sections: updatedSections);
        widget.provider.updateCV(updatedCV);
      }
    }

    Navigator.pop(context);
  }

  String _getTemplateName(SectionTemplate template) {
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

  String _getTemplateInstructions(SectionTemplate template) {
    switch (template) {
      case SectionTemplate.bulletList:
        return 'Enter each point on a new line. They will be formatted as bullet points.\n\nBest for: Awards, Projects, Achievements';
      case SectionTemplate.categoryList:
        return 'Format: Category: item1, item2, item3\nEach category on a new line.\n\nBest for: Grouped skills or items';
      case SectionTemplate.paragraph:
        return 'Write continuous text. It will be formatted as a justified paragraph.\n\nBest for: Summaries, descriptions';
      case SectionTemplate.simpleList:
        return 'Enter each item on a new line. Simple bullet list format.\n\nBest for: Lists of items';
    }
  }

  String _getTemplateHint(SectionTemplate template) {
    switch (template) {
      case SectionTemplate.bulletList:
        return 'Example:\nBest Paper Award, IEEE Conference 2023\nDean\'s List, 2020-2022\nHackathon Winner, TechFest 2021';
      case SectionTemplate.categoryList:
        return 'Example:\nLanguages: English (Fluent), Indonesian (Native), Mandarin (Basic)\nTools: Git, Docker, Kubernetes\nFrameworks: React, Vue, Angular';
      case SectionTemplate.paragraph:
        return 'Example:\nActive contributor to open-source projects with over 100+ GitHub stars. Published research on machine learning optimization in peer-reviewed journals.';
      case SectionTemplate.simpleList:
        return 'Example:\nPublished 3 papers in AI conferences\nMentor for 20+ students\nOrganized 5 tech meetups';
    }
  }
}
