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
            child: AppSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Consumer<CVBuilderProvider>(
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
                  ),
                  const SizedBox(height: AppSizes.md),
                  Center(
                    child: Text(
                      l10n.educationHistoryHeader,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Center(
                    child: Text(
                      l10n.educationHistoryDesc,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withValues(alpha: 0.7),
                          ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl),
                  if (educationList.isEmpty)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Iconsax.teacher,
                              size: 48,
                              color: Color(0xFF9CA3AF),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noEducationData,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.addEducationPrompt,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (educationList.isNotEmpty) ...[
                    ReorderableListView.builder(
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
                                  onPressed: () =>
                                      provider.removeEducation(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSizes.xl),
                  ],
                  const SizedBox(height: AppSizes.xl),
                  const Divider(),
                  const SizedBox(height: AppSizes.xl),
                  _buildInlineForm(context, provider),
                  const SizedBox(height: 80),
                ],
              ),
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

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
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
            const SizedBox(height: 16),
            TextFormField(
              controller: _institutionController,
              decoration: InputDecoration(
                labelText: '${l10n.institutionName} *',
                hintText: l10n.institutionPlaceholder,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              validator: (v) => v?.isEmpty == true ? l10n.requiredField : null,
              maxLength: 50,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _majorController,
              decoration: InputDecoration(
                labelText: '${l10n.major} *',
                hintText: l10n.majorPlaceholder,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              validator: (v) => v?.isEmpty == true ? l10n.requiredField : null,
              maxLength: 50,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _degreeController,
              decoration: InputDecoration(
                labelText: '${l10n.degree} ${l10n.optionalField}',
                hintText: l10n.degreePlaceholder,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              maxLength: 50,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startYearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '${l10n.startYear} *',
                      hintText: l10n.startYearPlaceholder,
                      border: const OutlineInputBorder(),
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
                const SizedBox(width: 16),
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
                      border: const OutlineInputBorder(),
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
            const SizedBox(height: 8),
            TextFormField(
              controller: _gpaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.gpaOptional,
                hintText: l10n.gpaPlaceholder,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              maxLength: 5,
            ),
            const SizedBox(height: 24),
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
      ),
    );
  }
}
