import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_builder_step_layout.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/custom_section_editor_dialog.dart';
import 'package:resummy_app/features/cv_tools/presentation/utils/dynamic_cv_steps.dart';

@RoutePage()
class CvBuilderCustomSectionStepScreen extends StatelessWidget {
  final String sectionId;

  const CvBuilderCustomSectionStepScreen({
    super.key,
    @PathParam('sectionId') required this.sectionId,
  });

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

        // Find the custom section
        final sectionIndex = cv.sections.indexWhere((s) => s.id == sectionId);
        if (sectionIndex == -1) {
          return Scaffold(
            body: Center(child: Text('Section not found')),
          );
        }

        final section = cv.sections[sectionIndex];
        if (section is! CustomSection) {
          return Scaffold(
            body: Center(child: Text('Invalid section type')),
          );
        }

        final currentStep = DynamicCvSteps.getStepForSectionIndex(sectionIndex, cv);

        return CVBuilderStepLayout(
          title: 'CV Builder',
          currentStep: currentStep,
          editContent: _buildCustomSectionForm(context, provider, section, currentStep),
          onBack: () {
            DynamicCvSteps.navigateToPreviousStep(context, currentStep);
          },
          onNext: () {
            provider.saveCurrentCV();
            // Navigate to next step dynamically
            DynamicCvSteps.navigateToNextStep(context, currentStep);
          },
        );
      },
    );
  }

  Widget _buildCustomSectionForm(
    BuildContext context,
    CVBuilderProvider provider,
    CustomSection section,
    int currentStep,
  ) {
    final theme = Theme.of(context);
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
                color: theme.cardColor,
                border: Border.all(color: theme.primaryColor),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Step $currentStep/$totalSteps',
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
              section.title,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),

          Center(
            child: Text(
              'Custom Section',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 32),

          // 1. LIST OF ADDED CONTENT (Top)
          if (section.content.isNotEmpty) ...[
            _buildContentCard(context, section, theme),
            const SizedBox(height: 24),
          ] else ...[
            // Placeholder if empty
             Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.disabledColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.disabledColor.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Icon(Iconsax.document_text, size: 48, color: theme.disabledColor.withOpacity(0.5)),
                  const SizedBox(height: 12),
                  Text(
                    'No content yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.disabledColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add content using the form below',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // 2. ADD FORM (Bottom)
          Text(
            'Add Content',
             style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildInlineForm(context, provider, section, theme),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildContentCard(BuildContext context, CustomSection section, ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.note_text, color: theme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Current Content',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                // Template Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getTemplateName(section.template),
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildContentPreview(section),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineForm(BuildContext context, CVBuilderProvider provider, CustomSection section, ThemeData theme) {
     // We need to manage state for the input here. 
     // Since this is a StatelessWidget, we can use a StatefulBuilder or convert to StatefulWidget.
     // Accessing provider methods is fine.
     // For simplicity in this edit, I'll use a StatefulBuilder for the form fields.
     
     return StatefulBuilder(
       builder: (context, setState) {
         final controller = TextEditingController(text: section.content); // Pre-fill with existing content? 
         // User wants "Add form at bottom". 
         // If content already exists, maybe the form should be for editing/appending?
         // User said: "atasnya ada kaya hasil sertif... trus ada form di bawahnya buat ngisi gitu".
         // Certificate section allows adding MULTIPLE items. Custom section currently has ONE content string.
         // If custom section is just one big string, then the form should allow EDITING it.
         // BUT user compares it to Certificate section (Step 7), which is a LIST of items.
         // CustomSection has `content` string. 
         // If we want it to behave like a list, we need to treat `content` as a joined list or change data structure.
         // The current data structure `CustomSection` only has a `String content`.
         // `SectionTemplate` determines how it's formatted.
         // If template is `bulletList` or `simpleList`, we can treat `content` as new-line separated items.
         
         // Let's implement an "Add Item" form that APPENDS to the content string.
         // And maybe a "Clear/Reset" button to clear content.
         
         final inputController = TextEditingController();
         
         return Container(
           padding: const EdgeInsets.all(16),
           decoration: BoxDecoration(
             color: theme.cardColor,
             borderRadius: BorderRadius.circular(12),
             border: Border.all(color: theme.disabledColor.withOpacity(0.2)),
           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               if (section.template == SectionTemplate.paragraph) ...[
                  TextField(
                    controller: controller..text = section.content, // Bind to current content for paragraph
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: 'Paragraph Content',
                      hintText: 'Enter your custom section content here...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      alignLabelWithHint: true,
                    ),
                    onChanged: (value) {
                      provider.updateCustomSection(section.id, value);
                    },
                  ),
               ] else ...[
                  // For lists, show an "Add Item" input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: inputController,
                          decoration: InputDecoration(
                            labelText: 'Add Item',
                            hintText: 'e.g. Project A - Description',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            prefixIcon: Icon(Iconsax.add_circle),
                          ),
                          onSubmitted: (value) {
                             if (value.trim().isNotEmpty) {
                               final newContent = section.content.isEmpty 
                                   ? value.trim() 
                                   : '${section.content}\n${value.trim()}';
                               provider.updateCustomSection(section.id, newContent);
                               inputController.clear();
                               setState(() {}); // Clear input
                             }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton.filled(
                        onPressed: () {
                           if (inputController.text.trim().isNotEmpty) {
                               final newContent = section.content.isEmpty 
                                   ? inputController.text.trim() 
                                   : '${section.content}\n${inputController.text.trim()}';
                               provider.updateCustomSection(section.id, newContent);
                               inputController.clear();
                               setState(() {}); 
                           }
                        },
                        icon: const Icon(Iconsax.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Items will be added to the list above.',
                    style: TextStyle(fontSize: 12, color: theme.disabledColor),
                  ),
                  
                  // Allow clearing content for lists too
                  if (section.content.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        // Confirm clear
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Clear Content?'),
                            content: const Text('This will remove all items in this section.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  provider.updateCustomSection(section.id, '');
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                child: const Text('Clear All'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Iconsax.eraser, size: 16),
                      label: const Text('Clear All Items'),
                    ),
                  ],
               ],
             ],
           ),
         );
       }
     );
  }

  Widget _buildContentPreview(CustomSection section) {
    if (section.template == SectionTemplate.paragraph) {
      return Text(
        section.content,
        style: const TextStyle(fontSize: 14, height: 1.5),
      );
    }

    final lines = section.content.split('\n').where((l) => l.trim().isNotEmpty).toList();
    if (lines.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.asMap().entries.map((entry) {
        final index = entry.key;
        final line = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  line.trim(),
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
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
}


