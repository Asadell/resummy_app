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
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';

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

        final currentStep =
            DynamicCvSteps.getStepForSectionIndex(sectionIndex, cv);

        return CVBuilderStepLayout(
          title: l10n.cvBuilder,
          currentStep: currentStep,
          editContent: _CustomSectionForm(
            section: section,
            sectionId: sectionId,
            currentStep: currentStep,
          ),
          onBack: () =>
              DynamicCvSteps.navigateToPreviousStep(context, currentStep),
          onNext: () {
            provider.saveCurrentCV();
            DynamicCvSteps.navigateToNextStep(context, currentStep);
          },
        );
      },
    );
  }
}

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
  late TextEditingController _contentController;

  final _titleCtrl = TextEditingController();
  final _subtitleCtrl = TextEditingController();
  final _metaCtrl = TextEditingController();
  final _startDateCtrl = TextEditingController();
  final _endDateCtrl = TextEditingController();
  final _bulletCtrl = TextEditingController();
  List<String> _bullets = [];
  bool _isPresent = false;

  final _categoryNameCtrl = TextEditingController();
  final _categorySkillsCtrl = TextEditingController();

  final _bulletItemCtrl = TextEditingController();

  final _certNameCtrl = TextEditingController();
  final _certIssuerCtrl = TextEditingController();
  final _certDateCtrl = TextEditingController();
  final _certCredentialIdCtrl = TextEditingController();

  final _projectNameCtrl = TextEditingController();
  final _projectTechStackCtrl = TextEditingController();
  final _projectLinkCtrl = TextEditingController();

  int? _editingIndex;
  String? _editingCategoryName;
  bool _showValidation = false;

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
    _certNameCtrl.dispose();
    _certIssuerCtrl.dispose();
    _certDateCtrl.dispose();
    _certCredentialIdCtrl.dispose();
    _projectNameCtrl.dispose();
    _projectTechStackCtrl.dispose();
    _projectLinkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.read<CVBuilderProvider>();
    final theme = Theme.of(context);
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
                    color: theme.cardColor,
                    border: Border.all(color: theme.primaryColor),
                    borderRadius: BorderRadius.circular(AppSizes.xl),
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
                Text(
                  widget.section.title,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  _getTemplateDisplayName(context, widget.section.template),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          if (widget.section.template == CustomSectionTemplate.experienceLike ||
              widget.section.template == CustomSectionTemplate.educationLike)
            _buildEntryListTemplate(context, provider, theme)
          else if (widget.section.template == CustomSectionTemplate.organizationLike)
            _buildEntryListTemplate(context, provider, theme)
          else if (widget.section.template == CustomSectionTemplate.projectsLike)
            _buildEntryListTemplate(context, provider, theme)
          else if (widget.section.template == CustomSectionTemplate.certificationsLike)
            _buildCertificationsLikeTemplate(context, provider, theme)
          else if (widget.section.template == CustomSectionTemplate.skillsLike)
            _buildSkillsLikeTemplate(context, provider, theme)
          else if (widget.section.template == CustomSectionTemplate.bulletList)
            _buildBulletListTemplate(context, provider, theme)
          else
            AppSection(
              child: _buildParagraphTemplate(context, provider, theme),
            ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildEntryListTemplate(
    BuildContext context,
    CVBuilderProvider provider,
    ThemeData theme,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final section = _getCurrentSection(provider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.entries.isEmpty)
          AppSection(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.xxl),
              child: Column(
                spacing: AppSizes.md,
                children: [
                  Icon(Iconsax.document_text,
                      size: 56, color: Colors.grey[300]),
                  Text(
                    l10n.noItems,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        else
          AppSection(
            child: Column(
              children: section.entries.asMap().entries.map((e) {
                final index = e.key;
                final entry = e.value;
                return _EntryCard(
                  entry: entry,
                  section: section,
                  onEdit: () => _editEntry(index, entry),
                  onDelete: () => _showDeleteItemConfirmation(
                    context,
                    l10n.deleteItem,
                    l10n.deleteItemConfirmation(entry.title),
                    () => provider.removeCustomEntry(
                        sectionId: section.id, entryIndex: index),
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: AppSizes.sm),
        AppSection(
          child: _buildInlineEntryForm(context, provider, section),
        ),
      ],
    );
  }

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
        if (categories.isEmpty)
          AppSection(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
              child: Column(
                spacing: AppSizes.sm,
                children: [
                  Icon(Iconsax.code, size: 56, color: Colors.grey[300]),
                  Text(
                    l10n.noCategories,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  Text(
                    l10n.addCategoryPrompt,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
          )
        else
          AppSection(
            child: Column(
              children: categories.entries
                  .map((entry) => _SkillCategoryCard(
                        categoryName: entry.key,
                        skills: entry.value,
                        onEdit: () =>
                            _editSkillCategory(entry.key, entry.value),
                        onDelete: () => _showDeleteItemConfirmation(
                          context,
                          l10n.deleteCategory,
                          l10n.deleteCategoryConfirmation(entry.key),
                          () => provider.removeCustomSkillCategory(
                              sectionId: section.id, categoryName: entry.key),
                        ),
                        l10n: l10n,
                      ))
                  .toList(),
            ),
          ),
        const SizedBox(height: AppSizes.sm),
        AppSection(
          child: _buildInlineSkillsForm(context, provider, section),
        ),
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
    setState(() => _showValidation = true);

    if (_categoryNameCtrl.text.trim().isEmpty ||
        _categorySkillsCtrl.text.trim().isEmpty) {
      return;
    }

    final name = _categoryNameCtrl.text.trim();
    final skillsText = _categorySkillsCtrl.text.trim();
    final skills = skillsText
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.md,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isEditing ? l10n.editItem : l10n.addItem,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
        TextFormField(
          controller: _categoryNameCtrl,
          decoration: InputDecoration(
            labelText: l10n.categoryName,
            hintText: l10n.categoryNamePlaceholder,
            border: InputBorder.none,
          ),
          autovalidateMode: _showValidation
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          validator: (v) =>
              v?.trim().isEmpty == true ? l10n.requiredField : null,
        ),
        TextFormField(
          controller: _categorySkillsCtrl,
          decoration: InputDecoration(
            labelText: l10n.skills,
            hintText: l10n.skillsPlaceholder,
            border: InputBorder.none,
          ),
          autovalidateMode: _showValidation
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          validator: (v) =>
              v?.trim().isEmpty == true ? l10n.requiredField : null,
        ),
        const SizedBox(height: AppSizes.md),
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
    );
  }

  Widget _buildBulletListTemplate(
    BuildContext context,
    CVBuilderProvider provider,
    ThemeData theme,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final section = _getCurrentSection(provider);
    final lines =
        section.content.split('\n').where((l) => l.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (lines.isNotEmpty)
          AppSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.itemsCount(lines.length),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ...lines.asMap().entries.map((e) {
                  final index = e.key;
                  final line = e.value.trim();
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Text('•',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      title: Text(line, style: const TextStyle(fontSize: 14)),
                      trailing: IconButton(
                        icon: const Icon(Iconsax.trash,
                            size: 18, color: Colors.red),
                        onPressed: () => _showDeleteItemConfirmation(
                          context,
                          l10n.deleteItem,
                          l10n.deleteItemConfirmation(line),
                          () {
                            final newLines = List<String>.from(lines)
                              ..removeAt(index);
                            provider.updateCustomSectionContent(
                              sectionId: section.id,
                              content: newLines.join('\n'),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        const SizedBox(height: AppSizes.sm),
        AppSection(
          child: _buildInlineBulletForm(context, provider, section),
        ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.addItem,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _bulletItemCtrl,
                decoration: InputDecoration(
                  hintText: l10n.typeAndAddHint,
                  border: InputBorder.none,
                  prefixIcon: const Icon(Iconsax.add_circle),
                ),
                onSubmitted: (_) => _saveBulletItem(provider, section),
              ),
            ),
            const SizedBox(width: AppSizes.md),
            ElevatedButton(
              onPressed: () => _saveBulletItem(provider, section),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 56),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: Text(l10n.add),
            ),
          ],
        ),
      ],
    );
  }

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
          style:
              TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _contentController,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: l10n.contentHint,
            border: InputBorder.none,
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
    setState(() => _showValidation = true);

    if (_titleCtrl.text.trim().isEmpty) {
      return;
    }

    final newEntry = CustomEntry(
      id: _editingIndex != null
          ? section.entries[_editingIndex!].id
          : const Uuid().v4(),
      title: _titleCtrl.text.trim(),
      subtitle:
          _subtitleCtrl.text.trim().isEmpty ? null : _subtitleCtrl.text.trim(),
      meta: _metaCtrl.text.trim().isEmpty ? null : _metaCtrl.text.trim(),
      startDate: _startDateCtrl.text.trim().isEmpty
          ? null
          : _startDateCtrl.text.trim(),
      endDate: _isPresent
          ? null
          : (_endDateCtrl.text.trim().isEmpty
              ? null
              : _endDateCtrl.text.trim()),
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
    final isExperienceLike =
        section.template == CustomSectionTemplate.experienceLike;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isEditing ? l10n.editItem : l10n.addItem,
              style: theme.textTheme.headlineSmall?.copyWith(
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
        const SizedBox(height: AppSizes.md),
        TextFormField(
          controller: _titleCtrl,
          decoration: InputDecoration(
            labelText: '${section.titleLabel} *',
            hintText: isExperienceLike
                ? l10n.exampleSoftwareEngineer
                : l10n.exampleBachelor,
            border: InputBorder.none,
          ),
          autovalidateMode: _showValidation
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          validator: (v) =>
              v?.trim().isEmpty == true ? l10n.requiredField : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _subtitleCtrl,
          decoration: InputDecoration(
            labelText: section.subtitleLabel,
            hintText: isExperienceLike
                ? l10n.exampleGoogle
                : l10n.exampleUniversity,
            border: InputBorder.none,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _metaCtrl,
          decoration: InputDecoration(
            labelText: l10n.location,
            hintText: l10n.exampleLocation,
            border: InputBorder.none,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _startDateCtrl,
                decoration: InputDecoration(
                  labelText: l10n.startDate,
                  hintText: l10n.exampleYear,
                  border: InputBorder.none,
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
                  border: InputBorder.none,
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
        Text(l10n.bulletPoints,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _bulletCtrl,
                decoration: InputDecoration(
                  hintText: l10n.addBulletPointHint,
                  border: InputBorder.none,
                  prefixIcon: const Icon(Iconsax.add_circle),
                ),
                onSubmitted: (_) {
                  if (_bulletCtrl.text.trim().isNotEmpty) {
                    setState(() {
                      _bullets.add(_bulletCtrl.text.trim());
                      _bulletCtrl.clear();
                    });
                  }
                },
              ),
            ),
            IconButton(
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
                  leading: const Icon(Icons.drag_handle,
                      size: 20, color: Colors.grey),
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
        const SizedBox(height: AppSizes.md),
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
    );
  }

  CustomSection _getCurrentSection(CVBuilderProvider provider) {
    return provider.currentCV!.sections
        .firstWhere((s) => s.id == widget.sectionId) as CustomSection;
  }

  String _getTemplateDisplayName(
      BuildContext context, CustomSectionTemplate template) {
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
      case CustomSectionTemplate.organizationLike:
        return l10n.formatOrganization;
      case CustomSectionTemplate.certificationsLike:
        return l10n.formatCertifications;
      case CustomSectionTemplate.projectsLike:
        return l10n.formatProjects;
    }
  }

  Widget _buildCertificationsLikeTemplate(
    BuildContext context,
    CVBuilderProvider provider,
    ThemeData theme,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final section = _getCurrentSection(provider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.entries.isEmpty)
          AppSection(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.xxl),
              child: Column(
                spacing: AppSizes.md,
                children: [
                  Icon(Iconsax.award, size: 56, color: Colors.grey[300]),
                  Text(
                    l10n.noItems,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        else
          AppSection(
            child: Column(
              children: section.entries.asMap().entries.map((e) {
                final index = e.key;
                final entry = e.value;
                return _CertEntryCard(
                  entry: entry,
                  onEdit: () => _editCertEntry(index, entry),
                  onDelete: () => _showDeleteItemConfirmation(
                    context,
                    l10n.deleteItem,
                    l10n.deleteItemConfirmation(entry.title),
                    () => provider.removeCustomEntry(
                        sectionId: section.id, entryIndex: index),
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: AppSizes.sm),
        AppSection(
          child: _buildInlineCertForm(context, provider, section),
        ),
      ],
    );
  }

  void _editCertEntry(int index, CustomEntry entry) {
    setState(() {
      _editingIndex = index;
      _certNameCtrl.text = entry.title;
      _certIssuerCtrl.text = entry.subtitle ?? '';
      _certDateCtrl.text = entry.startDate ?? '';
      _certCredentialIdCtrl.text = entry.meta ?? '';
      _showValidation = false;
    });
  }

  void _resetCertForm() {
    setState(() {
      _editingIndex = null;
      _certNameCtrl.clear();
      _certIssuerCtrl.clear();
      _certDateCtrl.clear();
      _certCredentialIdCtrl.clear();
      _showValidation = false;
    });
  }

  void _saveCertForm(CVBuilderProvider provider, CustomSection section) {
    setState(() => _showValidation = true);
    if (_certNameCtrl.text.trim().isEmpty) return;

    final newEntry = CustomEntry(
      id: _editingIndex != null
          ? section.entries[_editingIndex!].id
          : const Uuid().v4(),
      title: _certNameCtrl.text.trim(),
      subtitle: _certIssuerCtrl.text.trim().isEmpty
          ? null
          : _certIssuerCtrl.text.trim(),
      startDate: _certDateCtrl.text.trim().isEmpty
          ? null
          : _certDateCtrl.text.trim(),
      meta: _certCredentialIdCtrl.text.trim().isEmpty
          ? null
          : _certCredentialIdCtrl.text.trim(),
    );

    if (_editingIndex != null) {
      provider.updateCustomEntry(
        sectionId: section.id,
        entryIndex: _editingIndex!,
        entry: newEntry,
      );
    } else {
      provider.addCustomEntry(sectionId: section.id, entry: newEntry);
    }
    _resetCertForm();
  }

  Widget _buildInlineCertForm(
    BuildContext context,
    CVBuilderProvider provider,
    CustomSection section,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isEditing = _editingIndex != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isEditing ? l10n.editItem : l10n.addItem,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isEditing)
              TextButton.icon(
                onPressed: _resetCertForm,
                icon: const Icon(Icons.close),
                label: Text(l10n.cancel),
              ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        TextFormField(
          controller: _certNameCtrl,
          decoration: InputDecoration(
            labelText: '${l10n.certificationName} *',
            hintText: l10n.exampleCertName,
            border: InputBorder.none,
          ),
          autovalidateMode: _showValidation
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          validator: (v) =>
              v?.trim().isEmpty == true ? l10n.requiredField : null,
        ),
        const SizedBox(height: AppSizes.md),
        TextFormField(
          controller: _certIssuerCtrl,
          decoration: InputDecoration(
            labelText: l10n.issuerLabel,
            hintText: l10n.exampleIssuer,
            border: InputBorder.none,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        TextFormField(
          controller: _certDateCtrl,
          decoration: InputDecoration(
            labelText: l10n.issueDateLabel,
            hintText: l10n.exampleIssueDate,
            border: InputBorder.none,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        TextFormField(
          controller: _certCredentialIdCtrl,
          decoration: InputDecoration(
            labelText: l10n.credentialIdOptional,
            hintText: l10n.exampleCredentialId,
            border: InputBorder.none,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        ElevatedButton(
          onPressed: () => _saveCertForm(provider, section),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          child: Text(isEditing ? l10n.save : l10n.add),
        ),
      ],
    );
  }
}

Future<void> _showDeleteItemConfirmation(BuildContext context, String title,
    String content, VoidCallback onConfirm) async {
  final l10n = AppLocalizations.of(context)!;
  final shouldDelete = await showModalBottomSheet<bool>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => Container(
          padding: const EdgeInsets.all(AppSizes.lg),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(AppSizes.md)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSizes.md,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Icon(
                Iconsax.trash,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              Column(
                spacing: AppSizes.xs,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              Row(
                spacing: AppSizes.md,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSizes.md),
                      ),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSizes.md),
                        elevation: 0,
                      ),
                      child: Text(l10n.delete),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ) ??
      false;

  if (shouldDelete) {
    onConfirm();
  }
}

class _SkillCategoryCard extends StatelessWidget {
  final String categoryName;
  final List<String> skills;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final AppLocalizations l10n;

  const _SkillCategoryCard({
    required this.categoryName,
    required this.skills,
    required this.onEdit,
    required this.onDelete,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      child: ListTile(
        title: Text(
          categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          skills.join(', '),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Iconsax.edit, size: 20),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Iconsax.trash, size: 20, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

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
                  onPressed: () => _showDeleteItemConfirmation(
                    context,
                    l10n.deleteItem,
                    l10n.deleteItemConfirmation(entry.title),
                    onDelete,
                  ),
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
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                  if (dateStr.isNotEmpty)
                    Text(
                      dateStr,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF9CA3AF)),
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
                        child: Text(b,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF374151))),
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

class _CertEntryCard extends StatelessWidget {
  final CustomEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CertEntryCard({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  onPressed: () => _showDeleteItemConfirmation(
                    context,
                    l10n.deleteItem,
                    l10n.deleteItemConfirmation(entry.title),
                    onDelete,
                  ),
                ),
              ],
            ),
            if (entry.startDate?.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text(
                entry.startDate!,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
            if (entry.meta?.isNotEmpty == true) ...[
              const SizedBox(height: 2),
              Text(
                'ID: ${entry.meta}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
