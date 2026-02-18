import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/cv_tools/presentation/utils/dynamic_cv_steps.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_builder_step_layout.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class CvBuilderStep5Screen extends StatefulWidget {
  const CvBuilderStep5Screen({super.key});

  @override
  State<CvBuilderStep5Screen> createState() => _CvBuilderStep5ScreenState();
}

class _CvBuilderStep5ScreenState extends State<CvBuilderStep5Screen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _isCurrentlyActive = false;
  int? _editingIndex;
  bool _showValidation = false;

  String? _validateStartDate(AppLocalizations l10n) {
    if (_startDate.isAfter(DateTime.now())) {
      return l10n.yearTooHigh;
    }
    return null;
  }

  String? _validateEndDate(AppLocalizations l10n) {
    if (_isCurrentlyActive || _endDate == null) return null;
    if (_endDate!.isAfter(DateTime.now())) {
      return l10n.yearTooHigh;
    }
    if (_endDate!.isBefore(_startDate)) {
      return l10n.dateStartAfterEnd;
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _editOrganization(OrganizationExperience org, int index) {
    setState(() {
      _editingIndex = index;
      _nameController.text = org.organizationName;
      _roleController.text = org.role;
      _descController.text = org.description;
      _startDate = org.startDate;
      _endDate = org.endDate;
      _isCurrentlyActive = org.isCurrentlyActive;
    });
  }

  void _resetForm() {
    setState(() {
      _editingIndex = null;
      _nameController.clear();
      _roleController.clear();
      _descController.clear();
      _startDate = DateTime.now();
      _endDate = null;
      _isCurrentlyActive = false;
      _showValidation = false;
    });
  }

  void _saveForm(CVBuilderProvider provider) {
    setState(() => _showValidation = true);
    if (_formKey.currentState!.validate()) {
      if (_endDate == null) {
        _isCurrentlyActive = true;
      }

      if (!_isCurrentlyActive &&
          (_endDate == null || _endDate!.isBefore(_startDate))) {
        return;
      }
      if (!_isCurrentlyActive && _endDate!.isAfter(DateTime.now())) {
        return;
      }
      if (_startDate.isAfter(DateTime.now())) {
        return;
      }
      final org = OrganizationExperience(
        id: _editingIndex != null
            ? provider
                .currentCV!.organizationSection!.entries[_editingIndex!].id
            : const Uuid().v4(),
        organizationName: _nameController.text.trim(),
        role: _roleController.text.trim(),
        startDate: _startDate,
        endDate: _isCurrentlyActive ? null : _endDate,
        isCurrentlyActive: _isCurrentlyActive,
        description: _descController.text.trim(),
      );

      if (_editingIndex != null) {
        provider.updateOrganization(_editingIndex!, org);
      } else {
        provider.addOrganization(org);
      }

      _resetForm();
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : (_endDate ?? DateTime.now()),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentStep =
        DynamicCvSteps.getStepForSection(context, 'organization');

    return CVBuilderStepLayout(
      title: l10n.cvBuilder,
      currentStep: currentStep,
      onBack: () {
        DynamicCvSteps.navigateToPreviousStep(context, currentStep);
      },
      onNext: () {
        final provider = context.read<CVBuilderProvider>();
        provider.saveCurrentCV();
        final currentStep =
            DynamicCvSteps.getStepForSection(context, 'organization');
        DynamicCvSteps.navigateToNextStep(context, currentStep);
      },
      editContent: Consumer<CVBuilderProvider>(
        builder: (context, provider, child) {
          final organizationEntries =
              provider.currentCV?.organizationSection?.entries ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSection(
                  child: Column(
                    spacing: AppSizes.sm,
                    children: [
                      Consumer<CVBuilderProvider>(
                        builder: (context, provider, _) {
                          final currentStep = DynamicCvSteps.getStepForSection(
                              context, 'organization');
                          final totalSteps =
                              DynamicCvSteps.getTotalSteps(provider.currentCV);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              border: Border.all(color: theme.primaryColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              l10n.stepHeader(currentStep, totalSteps),
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                      Text(
                        l10n.organizationHistoryHeader,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        l10n.organizationHistoryDesc,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                if (organizationEntries.isEmpty)
                  AppSection(
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.xl),
                      child: Column(
                        spacing: AppSizes.sm,
                        children: [
                          Icon(
                            Iconsax.people,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                          ),
                          Text(
                            l10n.noOrganizationData,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            l10n.addOrganization,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  AppSection(
                    child: ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: organizationEntries.length,
                      onReorder: (oldIndex, newIndex) {
                        provider.reorderOrganization(oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        final item = organizationEntries[index];
                        return _OrganizationCard(
                          key: ValueKey(item.id),
                          entry: item,
                          onEdit: () => _editOrganization(item, index),
                          onDelete: () =>
                              _showDeleteConfirmation(context, provider, index),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: AppSizes.sm),
                AppSection(
                  child: _buildInlineForm(context, provider),
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInlineForm(BuildContext context, CVBuilderProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isEditing = _editingIndex != null;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidateMode: _showValidation
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? l10n.editOrganization : l10n.addOrganization,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isEditing)
                  TextButton.icon(
                    onPressed: _resetForm,
                    icon: const Icon(Icons.close),
                    label: Text(l10n.cancel),
                  ),
              ],
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '${l10n.organizationName} *',
                hintText: l10n.organizationPlaceholder,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              validator: (v) =>
                  v?.trim().isEmpty == true ? l10n.requiredField : null,
              maxLength: 50,
            ),
            TextFormField(
              controller: _roleController,
              decoration: InputDecoration(
                labelText: '${l10n.organizationRole} *',
                hintText: l10n.rolePlaceholder,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              validator: (v) =>
                  v?.trim().isEmpty == true ? l10n.requiredField : null,
              maxLength: 50,
            ),
            Row(
              spacing: AppSizes.md,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: '${l10n.startYear} *',
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.calendar_today, size: 16),
                        errorText:
                            _showValidation ? _validateStartDate(l10n) : null,
                      ),
                      child: Text(DateFormat('MMM yyyy').format(_startDate)),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: _isCurrentlyActive
                        ? null
                        : () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.endYear,
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.calendar_today, size: 16),
                        enabled: !_isCurrentlyActive,
                        errorText:
                            _showValidation ? _validateEndDate(l10n) : null,
                      ),
                      child: Text(
                        _isCurrentlyActive
                            ? l10n.present
                            : (_endDate != null
                                ? DateFormat('MMM yyyy').format(_endDate!)
                                : l10n.selectDate),
                        style: TextStyle(
                          color: _isCurrentlyActive
                              ? theme.disabledColor
                              : theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CheckboxListTile(
              title: Text(l10n.currentlyWorking),
              value: _isCurrentlyActive,
              onChanged: (val) {
                setState(() {
                  _isCurrentlyActive = val ?? false;
                  if (_isCurrentlyActive) _endDate = null;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            TextFormField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: l10n.responsibilities,
                alignLabelWithHint: true,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              maxLength: 500,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _saveForm(provider),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(isEditing ? l10n.save : l10n.addOrganization),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context, CVBuilderProvider provider, int index) async {
    final l10n = AppLocalizations.of(context)!;
    final shouldDelete = await showModalBottomSheet<bool>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSizes.md)),
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
                      l10n.deleteItem,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      l10n.deleteItemConfirmation(provider
                          .currentCV!.organizationSection!.entries[index].role),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
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
                          foregroundColor:
                              Theme.of(context).colorScheme.onError,
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

    if (shouldDelete && context.mounted) {
      provider.removeOrganization(index);
    }
  }
}

class _OrganizationCard extends StatelessWidget {
  final OrganizationExperience entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _OrganizationCard({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM yyyy');

    String dateRange;
    if (entry.isCurrentlyActive) {
      dateRange =
          '${dateFormat.format(entry.startDate)} - ${AppLocalizations.of(context)!.present}';
    } else if (entry.endDate != null) {
      dateRange =
          '${dateFormat.format(entry.startDate)} - ${dateFormat.format(entry.endDate!)}';
    } else {
      dateRange = dateFormat.format(entry.startDate);
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    entry.role,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.edit, size: 20),
                  onPressed: onEdit,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Iconsax.trash, size: 20, color: Colors.red),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              entry.organizationName,
              style: TextStyle(
                fontSize: 14,
                color: theme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Iconsax.calendar_1, size: 16, color: theme.disabledColor),
                const SizedBox(width: 8),
                Text(
                  dateRange,
                  style: TextStyle(fontSize: 12, color: theme.disabledColor),
                ),
              ],
            ),
            if (entry.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                entry.description,
                style: const TextStyle(fontSize: 13),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
