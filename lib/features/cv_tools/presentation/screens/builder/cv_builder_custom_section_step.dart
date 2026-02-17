// lib/features/cv_tools/presentation/screens/builder/cv_builder_custom_section_step.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_builder_step_layout.dart';
import 'package:resummy_app/features/cv_tools/presentation/utils/dynamic_cv_steps.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class CvBuilderCustomSectionStepScreen extends StatelessWidget {
  final String sectionId;

  const CvBuilderCustomSectionStepScreen({
    super.key,
    @PathParam('sectionId') required this.sectionId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<CVBuilderProvider>(
      builder: (context, provider, _) {
        final cv = provider.currentCV;
        if (cv == null) {
          return Scaffold(body: Center(child: Text(l10n.noCvData)));
        }

        final sectionIndex = cv.sections.indexWhere((s) => s.id == sectionId);
        if (sectionIndex == -1) {
          return Scaffold(body: Center(child: Text(l10n.sectionNotFound)));
        }

        final section = cv.sections[sectionIndex];
        if (section is! CustomSection) {
          return Scaffold(body: Center(child: Text(l10n.invalidSectionType)));
        }

        final currentStep = DynamicCvSteps.getStepForSectionIndex(sectionIndex, cv);

        return CVBuilderStepLayout(
          title: l10n.cvBuilder,
          currentStep: currentStep,
          editContent: _CustomSectionForm(
            section: section,
            sectionId: sectionId,
            currentStep: currentStep,
          ),
          onBack: () => DynamicCvSteps.navigateToPreviousStep(context, currentStep),
          onNext: () {
            provider.saveCurrentCV();
            DynamicCvSteps.navigateToNextStep(context, currentStep);
          },
        );
      },
    );
  }
}

// ============================================================
// FORM WIDGET (StatefulWidget for local state)
// ============================================================
class _CustomSectionForm extends StatefulWidget {
  final CustomSection section;
  final String sectionId;
  final int currentStep;

  const _CustomSectionForm({
    required this.section,
    required this.sectionId,
    required this.currentStep,
  });

  @override
  State<_CustomSectionForm> createState() => _CustomSectionFormState();
}

class _CustomSectionFormState extends State<_CustomSectionForm> {
  // For bulletList / paragraph templates
  late TextEditingController _contentController;
  
  // For Experience/Education/Entry
  final _titleCtrl = TextEditingController();
  final _subtitleCtrl = TextEditingController();
  final _metaCtrl = TextEditingController();
  final _startDateCtrl = TextEditingController();
  final _endDateCtrl = TextEditingController();
  final _bulletCtrl = TextEditingController(); // For adding a bullet to the list
  List<String> _bullets = [];
  bool _isPresent = false;

  // For Skills
  final _categoryNameCtrl = TextEditingController();
  final _categorySkillsCtrl = TextEditingController();

  // For Bullet List Item
  final _bulletItemCtrl = TextEditingController();

  // State
  int? _editingIndex; // For entries and bullet list items
  String? _editingCategoryName; // For skills categories
  bool _showValidation = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.section.content);
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleCtrl.dispose();
    _subtitleCtrl.dispose();
    _metaCtrl.dispose();
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    _bulletCtrl.dispose();
    _categoryNameCtrl.dispose();
    _categorySkillsCtrl.dispose();
    _bulletItemCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.read<CVBuilderProvider>();
    final theme = Theme.of(context);
    final totalSteps = DynamicCvSteps.getTotalSteps(provider.currentCV);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Badge
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border.all(color: theme.primaryColor),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l10n.stepHeader(widget.currentStep, totalSteps),
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
              widget.section.title,
              style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),

          Center(
            child: Text(
              _getTemplateDisplayName(context, widget.section.template),
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),

          const SizedBox(height: 24),

          // ============================================================
          // RENDER BASED ON TEMPLATE
          // ============================================================
          if (widget.section.template == CustomSectionTemplate.experienceLike ||
              widget.section.template == CustomSectionTemplate.educationLike)
            _buildEntryListTemplate(context, provider, theme)
          else if (widget.section.template == CustomSectionTemplate.skillsLike)
            _buildSkillsLikeTemplate(context, provider, theme)
          else if (widget.section.template == CustomSectionTemplate.bulletList)
            _buildBulletListTemplate(context, provider, theme)
          else
            _buildParagraphTemplate(context, provider, theme),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ============================================================
  // TEMPLATE 1: Experience-like / Education-like (List of entries)
  // ============================================================
  Widget _buildEntryListTemplate(
    BuildContext context,
    CVBuilderProvider provider,
    ThemeData theme,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final section = _getCurrentSection(provider);
    final isExperienceLike = section.template == CustomSectionTemplate.experienceLike;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tips card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Iconsax.info_circle, color: Colors.blue.shade700, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isExperienceLike
                      ? '${l10n.formatExperience}: ${section.titleLabel} (bold) + ${section.subtitleLabel} (italic) + ${l10n.startDate} - ${l10n.endDate} + bullet points'
                      : '${l10n.formatEducation}: ${section.titleLabel} (bold) + ${section.subtitleLabel} (italic) + ${l10n.startDate} - ${l10n.endDate} + bullets ${l10n.optionalField}',
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Entry list
        if (section.entries.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Iconsax.document_text, size: 56, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noItems,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        else
          ...section.entries.asMap().entries.map((e) {
            final index = e.key;
            final entry = e.value;
            return _EntryCard(
              entry: entry,
              section: section,
              onEdit: () => _editEntry(index, entry),
              onDelete: () => provider.removeCustomEntry(sectionId: section.id, entryIndex: index),
            );
          }),

        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),

        _buildInlineEntryForm(context, provider, section),
      ],
    );
  }

  // ============================================================
  // TEMPLATE: Skills-Like (Category: skill1, skill2)
  // ============================================================
  Widget _buildSkillsLikeTemplate(
    BuildContext context,
    CVBuilderProvider provider,
    ThemeData theme,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final section = _getCurrentSection(provider);
    final categories = section.skillCategories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tips card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Iconsax.info_circle, color: Colors.blue.shade700, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${l10n.formatSkills}: ${l10n.categoryName}: skill1, skill2, skill3',
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Category cards
        if (categories.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(Iconsax.code, size: 56, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text(
                    l10n.noCategories,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.addCategoryPrompt,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
          )
        else
          ...categories.entries.map((entry) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.edit_2, size: 18),
                        onPressed: () => _editSkillCategory(entry.key, entry.value),
                        tooltip: l10n.edit,
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.trash, size: 18, color: Colors.red),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(l10n.deleteItem),
                            content: Text(l10n.deleteItemConfirmation(entry.key)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(l10n.cancel),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  provider.removeCustomSkillCategory(
                                    sectionId: section.id,
                                    categoryName: entry.key,
                                  );
                                  Navigator.pop(ctx);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text(l10n.delete),
                              ),
                            ],
                          ),
                        ),
                        tooltip: l10n.delete,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: entry.value.map((skill) => Chip(
                      label: Text(skill, style: const TextStyle(fontSize: 11)),
                      backgroundColor: Colors.blue.shade50,
                      side: BorderSide(color: Colors.blue.shade200),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                ],
              ),
            ),
          )).toList(),

        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),

        _buildInlineSkillsForm(context, provider, section),
      ],
    );
  }

  void _editSkillCategory(String categoryName, List<String> skills) {
    setState(() {
      _editingCategoryName = categoryName;
      _categoryNameCtrl.text = categoryName;
      _categorySkillsCtrl.text = skills.join(', ');
      _showValidation = false;
    });
  }

  void _resetSkillForm() {
    setState(() {
      _editingCategoryName = null;
      _categoryNameCtrl.clear();
      _categorySkillsCtrl.clear();
      _showValidation = false;
    });
  }

  void _saveSkillForm(CVBuilderProvider provider, CustomSection section) {
    // ignore: unused_local_variable
    final l10n = AppLocalizations.of(context)!;
    setState(() => _showValidation = true);

    if (_categoryNameCtrl.text.trim().isEmpty || _categorySkillsCtrl.text.trim().isEmpty) {
      return;
    }

    final name = _categoryNameCtrl.text.trim();
    final skillsText = _categorySkillsCtrl.text.trim();
    final skills = skillsText.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

    if (skills.isEmpty) return;

    if (_editingCategoryName != null) {
      provider.updateCustomSkillCategory(
        sectionId: section.id,
        oldName: _editingCategoryName!,
        newName: name,
        skills: skills,
      );
    } else {
      provider.addCustomSkillCategory(
        sectionId: section.id,
        categoryName: name,
        skills: skills,
      );
    }
    _resetSkillForm();
  }

  Widget _buildInlineSkillsForm(
    BuildContext context,
    CVBuilderProvider provider,
    CustomSection section,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = _editingCategoryName != null;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEditing ? '${l10n.edit} ${l10n.categoryName}' : '${l10n.addItem} ${l10n.categoryName}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isEditing)
                TextButton.icon(
                  onPressed: _resetSkillForm,
                  icon: const Icon(Icons.close),
                  label: Text(l10n.cancel),
                ),
            ],
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _categoryNameCtrl,
            decoration: InputDecoration(
              labelText: l10n.categoryName,
              hintText: l10n.categoryNamePlaceholder,
              border: const OutlineInputBorder(),
            ),
             autovalidateMode: _showValidation ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            validator: (v) => v?.trim().isEmpty == true ? l10n.requiredField : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _categorySkillsCtrl,
            decoration: InputDecoration(
              labelText: l10n.skills,
              hintText: l10n.skillsPlaceholder,
              border: const OutlineInputBorder(),
            ),
             autovalidateMode: _showValidation ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            validator: (v) => v?.trim().isEmpty == true ? l10n.requiredField : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _saveSkillForm(provider, section),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text(isEditing ? l10n.save : l10n.add),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TEMPLATE 2: Bullet List
  // ============================================================
  Widget _buildBulletListTemplate(
    BuildContext context,
    CVBuilderProvider provider,
    ThemeData theme,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final section = _getCurrentSection(provider);
    final lines = section.content.split('\n').where((l) => l.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Existing items
        if (lines.isNotEmpty) ...[
          Text(
            l10n.itemsCount(lines.length),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          ...lines.asMap().entries.map((e) {
            final index = e.key;
            final line = e.value.trim();
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Text('•', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                title: Text(line, style: const TextStyle(fontSize: 14)),
                trailing: IconButton(
                  icon: const Icon(Iconsax.trash, size: 18, color: Colors.red),
                  onPressed: () {
                    final newLines = List<String>.from(lines)..removeAt(index);
                    provider.updateCustomSectionContent(
                      sectionId: section.id,
                      content: newLines.join('\n'),
                    );
                  },
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
        ],

        _buildInlineBulletForm(context, provider, section),
      ],
    );
  }

  void _saveBulletItem(CVBuilderProvider provider, CustomSection section) {
    if (_bulletItemCtrl.text.trim().isEmpty) return;

    final currentContent = section.content;
    final newContent = currentContent.isEmpty
        ? _bulletItemCtrl.text.trim()
        : '$currentContent\n${_bulletItemCtrl.text.trim()}';

    provider.updateCustomSectionContent(
      sectionId: section.id,
      content: newContent,
    );
    _bulletItemCtrl.clear();
  }

  Widget _buildInlineBulletForm(
    BuildContext context,
    CVBuilderProvider provider,
    CustomSection section,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.addItem,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _bulletItemCtrl,
                  decoration: InputDecoration(
                    hintText: l10n.typeAndAddHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Iconsax.add_circle),
                  ),
                  onSubmitted: (_) => _saveBulletItem(provider, section),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => _saveBulletItem(provider, section),
                style: ElevatedButton.styleFrom(
                   minimumSize: const Size(0, 56), // Match text field height
                   backgroundColor: Theme.of(context).primaryColor,
                   foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: Text(l10n.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TEMPLATE 3: Paragraph
  // ============================================================
  Widget _buildParagraphTemplate(
    BuildContext context,
    CVBuilderProvider provider,
    ThemeData theme,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.contentLabel,
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _contentController,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: l10n.contentHint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            alignLabelWithHint: true,
          ),
          onChanged: (value) {
            provider.updateCustomSectionContent(
              sectionId: widget.sectionId,
              content: value,
            );
          },
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${_contentController.text.length} ${l10n.characters}',
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DIALOG: Add/Edit Entry
  // ============================================================
  void _editEntry(int index, CustomEntry entry) {
    setState(() {
      _editingIndex = index;
      _titleCtrl.text = entry.title;
      _subtitleCtrl.text = entry.subtitle ?? '';
      _metaCtrl.text = entry.meta ?? '';
      _startDateCtrl.text = entry.startDate ?? '';
      _endDateCtrl.text = entry.endDate ?? '';
      _isPresent = entry.isPresent;
      _bullets = List.from(entry.bullets);
      _showValidation = false;
    });
  }

  void _resetEntryForm() {
    setState(() {
      _editingIndex = null;
      _titleCtrl.clear();
      _subtitleCtrl.clear();
      _metaCtrl.clear();
      _startDateCtrl.clear();
      _endDateCtrl.clear();
      _bulletCtrl.clear();
      _bullets = [];
      _isPresent = false;
      _showValidation = false;
    });
  }

  void _saveEntryForm(CVBuilderProvider provider, CustomSection section) {
    // ignore: unused_local_variable
    final l10n = AppLocalizations.of(context)!;
    setState(() => _showValidation = true);

    if (_titleCtrl.text.trim().isEmpty) {
       return; // Validator in UI will show error
    }
    
    // Additional validation if needed
    
    final newEntry = CustomEntry(
      id: _editingIndex != null ? section.entries[_editingIndex!].id : const Uuid().v4(),
      title: _titleCtrl.text.trim(),
      subtitle: _subtitleCtrl.text.trim().isEmpty ? null : _subtitleCtrl.text.trim(),
      meta: _metaCtrl.text.trim().isEmpty ? null : _metaCtrl.text.trim(),
      startDate: _startDateCtrl.text.trim().isEmpty ? null : _startDateCtrl.text.trim(),
      endDate: _isPresent ? null : (_endDateCtrl.text.trim().isEmpty ? null : _endDateCtrl.text.trim()),
      isPresent: _isPresent,
      bullets: _bullets,
    );

    if (_editingIndex != null) {
      provider.updateCustomEntry(
        sectionId: section.id,
        entryIndex: _editingIndex!,
        entry: newEntry,
      );
    } else {
      provider.addCustomEntry(
        sectionId: section.id,
        entry: newEntry,
      );
    }
    _resetEntryForm();
  }

  Widget _buildInlineEntryForm(
    BuildContext context,
    CVBuilderProvider provider,
    CustomSection section,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isEditing = _editingIndex != null;
    final isExperienceLike = section.template == CustomSectionTemplate.experienceLike;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEditing ? '${l10n.edit} ${section.titleLabel}' : '${l10n.addItem} ${section.titleLabel}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isEditing)
                TextButton.icon(
                  onPressed: _resetEntryForm,
                  icon: const Icon(Icons.close),
                  label: Text(l10n.cancel),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Title
          TextFormField(
            controller: _titleCtrl,
            decoration: InputDecoration(
              labelText: '${section.titleLabel} *',
              hintText: isExperienceLike ? l10n.exampleSoftwareEngineer : l10n.exampleBachelor,
              border: const OutlineInputBorder(),
            ),
            autovalidateMode: _showValidation ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            validator: (v) => v?.trim().isEmpty == true ? l10n.requiredField : null,
          ),
          const SizedBox(height: 16),

          // Subtitle
          TextFormField(
            controller: _subtitleCtrl,
            decoration: InputDecoration(
              labelText: section.subtitleLabel,
              hintText: isExperienceLike ? l10n.exampleGoogle : l10n.exampleUniversity,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Meta (Location/City)
          TextFormField(
            controller: _metaCtrl,
            decoration: InputDecoration(
              labelText: l10n.location, // Assuming meta is location based on context usually
              hintText: l10n.exampleLocation,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Dates
          Row(
            children: [
               Expanded(
                child: TextFormField(
                  controller: _startDateCtrl,
                  decoration: InputDecoration(
                    labelText: l10n.startDate,
                    hintText: l10n.exampleYear,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _endDateCtrl,
                  enabled: !_isPresent,
                   decoration: InputDecoration(
                    labelText: _isPresent ? l10n.present : l10n.endDate,
                    hintText: l10n.exampleYearEnd,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          CheckboxListTile(
            value: _isPresent,
            onChanged: (val) {
              setState(() {
                _isPresent = val ?? false;
                if (_isPresent) _endDateCtrl.clear();
              });
            },
            title: Text(l10n.present),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 16),

          // Bullets
          Text(l10n.bulletPoints, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
             children: [
               Expanded(
                 child: TextField(
                   controller: _bulletCtrl,
                   decoration: InputDecoration(
                     hintText: l10n.addBulletPoint,
                     border: const OutlineInputBorder(),
                   ),
                   onSubmitted: (value) {
                     if (value.trim().isNotEmpty) {
                       setState(() {
                         _bullets.add(value.trim());
                         _bulletCtrl.clear();
                       });
                     }
                   },
                 ),
               ),
               const SizedBox(width: 8),
               IconButton.filled(
                 onPressed: () {
                    if (_bulletCtrl.text.trim().isNotEmpty) {
                       setState(() {
                         _bullets.add(_bulletCtrl.text.trim());
                         _bulletCtrl.clear();
                       });
                     }
                 },
                 icon: const Icon(Icons.add),
               ),
             ],
          ),
          if (_bullets.isNotEmpty) ...[
            const SizedBox(height: 8),
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (int i = 0; i < _bullets.length; i++)
                  ListTile(
                    key: ValueKey('bullet_$i'),
                    dense: true,
                    leading: const Icon(Icons.drag_handle, size: 20, color: Colors.grey),
                    title: Text(_bullets[i]),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => setState(() => _bullets.removeAt(i)),
                    ),
                  ),
              ],
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = _bullets.removeAt(oldIndex);
                  _bullets.insert(newIndex, item);
                });
              },
            ),
          ],
          
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _saveEntryForm(provider, section),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: theme.primaryColor,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            child: Text(isEditing ? l10n.save : l10n.add),
          ),
        ],
      ),
    );
  }

  CustomSection _getCurrentSection(CVBuilderProvider provider) {
    return provider.currentCV!.sections
        .firstWhere((s) => s.id == widget.sectionId) as CustomSection;
  }

  String _getTemplateDisplayName(BuildContext context, CustomSectionTemplate template) {
    final l10n = AppLocalizations.of(context)!;
    switch (template) {
      case CustomSectionTemplate.experienceLike:
        return l10n.formatExperience;
      case CustomSectionTemplate.educationLike:
        return l10n.formatEducation;
      case CustomSectionTemplate.skillsLike:
        return l10n.formatSkills;
      case CustomSectionTemplate.bulletList:
        return l10n.formatBulletList;
      case CustomSectionTemplate.paragraph:
        return l10n.formatParagraph;
    }
  }
}

// ============================================================
// ENTRY CARD WIDGET
// ============================================================
class _EntryCard extends StatelessWidget {
  final CustomEntry entry;
  final CustomSection section;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EntryCard({
    required this.entry,
    required this.section,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateStr = entry.startDate != null
        ? '${entry.startDate} - ${entry.isPresent ? l10n.present : (entry.endDate ?? "")}'
        : '';

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (entry.subtitle?.isNotEmpty == true) ...[
                        const SizedBox(height: 2),
                        Text(
                          entry.subtitle!,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.edit_2, size: 18),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Iconsax.trash, size: 18, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l10n.deleteItem),
                        content: Text(l10n.deleteItemConfirmation(entry.title)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(l10n.cancel),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              onDelete();
                              Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: Text(l10n.delete),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            if (entry.meta?.isNotEmpty == true || dateStr.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (entry.meta?.isNotEmpty == true)
                    Text(
                      entry.meta!,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                  if (dateStr.isNotEmpty)
                    Text(
                      dateStr,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                    ),
                ],
              ),
            ],
            if (entry.bullets.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...entry.bullets.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 12)),
                      Expanded(
                        child: Text(b, style: const TextStyle(fontSize: 12, color: Color(0xFF374151))),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ENTRY DIALOG — Add / Edit
// ============================================================
