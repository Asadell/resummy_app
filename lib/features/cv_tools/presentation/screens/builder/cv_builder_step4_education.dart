import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_builder_step_layout.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/cv_tools/presentation/utils/dynamic_cv_steps.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class CvBuilderStep4Screen extends StatefulWidget {
  const CvBuilderStep4Screen({super.key});

  @override
  State<CvBuilderStep4Screen> createState() => _CvBuilderStep4ScreenState();
}

class _CvBuilderStep4ScreenState extends State<CvBuilderStep4Screen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentStep = DynamicCvSteps.getStepForSection(context, 'education');

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
            DynamicCvSteps.getStepForSection(context, 'education');
        DynamicCvSteps.navigateToNextStep(context, currentStep);
      },
      editContent: Consumer<CVBuilderProvider>(
        builder: (context, provider, child) {
          final educationList = provider.currentCV?.education ?? [];

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
                              context, 'education');
                          final totalSteps =
                              DynamicCvSteps.getTotalSteps(provider.currentCV);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              l10n.stepHeader(currentStep, totalSteps),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                      Text(
                        l10n.educationHistoryHeader,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        l10n.educationHistoryDesc,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                if (educationList.isEmpty)
                  AppSection(
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.xl),
                      child: Column(
                        spacing: AppSizes.sm,
                        children: [
                          Icon(
                            Iconsax.teacher,
                            size: 48,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withValues(alpha: 0.5),
                          ),
                          Text(
                            l10n.noEducationData,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Text(
                            l10n.addEducationPrompt,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
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
                      itemCount: educationList.length,
                      onReorder: (oldIndex, newIndex) {
                        provider.reorderEducation(oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        final edu = educationList[index];
                        final period = edu.isCurrentlyStudying
                            ? '${edu.startYear} - ${l10n.present}'
                            : '${edu.startYear} - ${edu.endYear ?? l10n.present}';

                        return Card(
                          key: ValueKey(edu.id),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: const Icon(Icons.drag_indicator),
                            title: Text(
                              edu.institution,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                    '${edu.degree} ${l10n.educationDegreesConnector} ${edu.major}'),
                                const SizedBox(height: 4),
                                Text(
                                  period,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: const Color(0xFF6B7280),
                                        fontSize: 12,
                                      ),
                                ),
                                if (edu.gpa != null && edu.gpa!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    '${l10n.gpaLabel}: ${edu.gpa}',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Iconsax.edit, size: 20),
                                  onPressed: () => _editEducation(edu, index),
                                ),
                                IconButton(
                                  icon: const Icon(Iconsax.trash,
                                      size: 20, color: Colors.red),
                                  onPressed: () => _showDeleteConfirmation(
                                      context, provider, index),
                                ),
                              ],
                            ),
                          ),
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

  final _formKey = GlobalKey<FormState>();
  final _institutionController = TextEditingController();
  final _majorController = TextEditingController();
  final _degreeController = TextEditingController();
  final _gpaController = TextEditingController();
  final _startYearController = TextEditingController();
  final _endYearController = TextEditingController();
  bool _isCurrentlyStudying = false;
  bool _showValidation = false;
  int? _editingIndex;
  Future<void> _showDeleteConfirmation(
      BuildContext context, CVBuilderProvider provider, int index) async {
    final l10n = AppLocalizations.of(context)!;
    final shouldDelete = await showModalBottomSheet<bool>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
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
                      l10n.deleteEducationTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      l10n.deleteEducationContent,
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
      provider.removeEducation(index);
    }
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _majorController.dispose();
    _degreeController.dispose();
    _gpaController.dispose();
    _startYearController.dispose();
    _endYearController.dispose();
    super.dispose();
  }

  void _editEducation(Education edu, int index) {
    setState(() {
      _editingIndex = index;
      _institutionController.text = edu.institution;
      _majorController.text = edu.major;
      _degreeController.text = edu.degree;
      _gpaController.text = edu.gpa ?? '';
      _startYearController.text = edu.startYear.toString();
      _endYearController.text = edu.endYear?.toString() ?? '';
      _isCurrentlyStudying = edu.isCurrentlyStudying;
    });
  }

  void _resetForm() {
    setState(() {
      _editingIndex = null;
      _showValidation = false;
      _institutionController.clear();
      _majorController.clear();
      _degreeController.clear();
      _gpaController.clear();
      _startYearController.clear();
      _endYearController.clear();
      _isCurrentlyStudying = false;
    });
  }

  void _saveForm(CVBuilderProvider provider) {
    setState(() => _showValidation = true);
    if (_formKey.currentState!.validate()) {
      final edu = Education(
        id: _editingIndex != null
            ? provider.currentCV!.education[_editingIndex!].id
            : const Uuid().v4(),
        institution: _institutionController.text.trim(),
        major: _majorController.text.trim(),
        degree: _degreeController.text.trim(),
        gpa: _gpaController.text.trim(),
        startYear:
            int.tryParse(_startYearController.text) ?? DateTime.now().year,
        endYear: _isCurrentlyStudying || _endYearController.text.isEmpty
            ? null
            : int.tryParse(_endYearController.text),
        isCurrentlyStudying:
            _isCurrentlyStudying || _endYearController.text.isEmpty,
      );

      if (_editingIndex != null) {
        provider.updateEducation(_editingIndex!, edu);
      } else {
        provider.addEducation(edu);
      }

      _resetForm();
    }
  }

  Widget _buildInlineForm(BuildContext context, CVBuilderProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = _editingIndex != null;

    return Form(
      key: _formKey,
      autovalidateMode: _showValidation
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.md,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEditing ? l10n.editEducation : l10n.addEducation,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
            controller: _institutionController,
            decoration: InputDecoration(
              labelText: '${l10n.institutionName} *',
              hintText: l10n.institutionPlaceholder,
              border: InputBorder.none,
              counterText: '',
            ),
            validator: (v) => v?.isEmpty == true ? l10n.requiredField : null,
            maxLength: 50,
          ),
          TextFormField(
            controller: _majorController,
            decoration: InputDecoration(
              labelText: '${l10n.major} *',
              hintText: l10n.majorPlaceholder,
              border: InputBorder.none,
              counterText: '',
            ),
            validator: (v) => v?.isEmpty == true ? l10n.requiredField : null,
            maxLength: 50,
          ),
          TextFormField(
            controller: _degreeController,
            decoration: InputDecoration(
              labelText: '${l10n.degree} ${l10n.optionalField}',
              hintText: l10n.degreePlaceholder,
              border: InputBorder.none,
              counterText: '',
            ),
            maxLength: 50,
          ),
          Row(
            spacing: AppSizes.md,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _startYearController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '${l10n.startYear} *',
                    hintText: l10n.startYearPlaceholder,
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return l10n.requiredField;
                    final year = int.tryParse(v);
                    if (year == null) return l10n.requiredField;
                    if (year < 1945) return l10n.invalidYearMin1945;
                    if (year > DateTime.now().year) return l10n.yearTooHigh;
                    return null;
                  },
                  maxLength: 4,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _endYearController,
                  keyboardType: TextInputType.number,
                  enabled: !_isCurrentlyStudying,
                  decoration: InputDecoration(
                    labelText: _isCurrentlyStudying
                        ? l10n.endYear
                        : '${l10n.endYear} *',
                    hintText: l10n.endYearPlaceholder,
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  validator: _isCurrentlyStudying
                      ? null
                      : (v) {
                          if (v == null || v.isEmpty) return null;

                          final endYear = int.tryParse(v);
                          if (endYear == null) return l10n.requiredField;

                          if (endYear > DateTime.now().year) {
                            return l10n.yearTooHigh;
                          }

                          final startYear =
                              int.tryParse(_startYearController.text);
                          if (startYear != null && endYear < startYear) {
                            return l10n.yearStartAfterEnd;
                          }
                          return null;
                        },
                  maxLength: 4,
                ),
              ),
            ],
          ),
          CheckboxListTile(
            value: _isCurrentlyStudying,
            onChanged: (val) {
              setState(() {
                _isCurrentlyStudying = val ?? false;
                if (_isCurrentlyStudying) {
                  _endYearController.clear();
                }
              });
            },
            title: Text(l10n.currentlyStudying),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          TextFormField(
            controller: _gpaController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.gpaOptional,
              hintText: l10n.gpaPlaceholder,
              border: InputBorder.none,
              counterText: '',
            ),
            maxLength: 5,
          ),
          ElevatedButton(
            onPressed: () => _saveForm(provider),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(isEditing ? l10n.save : l10n.addEducation),
          ),
        ],
      ),
    );
  }

}
