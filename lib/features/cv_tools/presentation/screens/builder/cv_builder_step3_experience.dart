import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_builder_step_layout.dart';
import 'package:resummy_app/features/cv_tools/presentation/utils/dynamic_cv_steps.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class CvBuilderStep3Screen extends StatefulWidget {
  const CvBuilderStep3Screen({super.key});

  @override
  State<CvBuilderStep3Screen> createState() => _CvBuilderStep3ScreenState();
}

class _CvBuilderStep3ScreenState extends State<CvBuilderStep3Screen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final currentStep = DynamicCvSteps.getStepForSection(context, 'experience');

    return CVBuilderStepLayout(
      title: l10n.cvBuilder,
      currentStep: currentStep,

      onBack: () {
        DynamicCvSteps.navigateToPreviousStep(context, currentStep);
      },
      onNext: () {
        final provider = context.read<CVBuilderProvider>();
        provider.saveCurrentCV();
        DynamicCvSteps.navigateToNextStep(context, currentStep);
      },
      editContent: Consumer<CVBuilderProvider>(
        builder: (context, provider, child) {
          final workList = provider.currentCV?.workExperience ?? [];
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step Header
                Center(
                  child: Consumer<CVBuilderProvider>(
                    builder: (context, provider, _) {
                      final currentStep = DynamicCvSteps.getStepForSection(context, 'experience');
                      final totalSteps = DynamicCvSteps.getTotalSteps(provider.currentCV);
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).primaryColor),
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
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    l10n.experienceHistoryHeader,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    l10n.experienceHistoryDesc,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Empty State
                if (workList.isEmpty)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Iconsax.briefcase,
                            size: 48,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noExperienceData,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.addExperiencePrompt,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                // List of Work Experience
                if (workList.isNotEmpty) ...[
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: workList.length,
                    onReorder: (oldIndex, newIndex) {
                      provider.reorderWorkExperience(oldIndex, newIndex);
                    },
                    itemBuilder: (context, index) {
                      final work = workList[index];
                      final start = '${work.startDate.month}/${work.startDate.year}';
                      final end = work.isCurrentlyWorking 
                          ? l10n.present
                          : '${work.endDate?.month}/${work.endDate?.year}';
                          
                      return Card(
                        key: ValueKey(work.id),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const Icon(Icons.drag_indicator),
                          title: Text(
                            work.jobTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('${work.companyName} • ${work.employmentType}'),
                              const SizedBox(height: 4),
                              Text(
                                '$start - $end',
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 12,
                                ),
                              ),
                              if (work.location != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  work.location!,
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 12,
                                  ),
                                ),
                              ]
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Iconsax.edit, size: 20),
                                onPressed: () => _editWorkExperience(work, index),
                              ),
                              IconButton(
                                icon: const Icon(Iconsax.trash, size: 20, color: Colors.red),
                                onPressed: () => provider.removeWorkExperience(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                ],

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),

                _buildInlineForm(context, provider),
                
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }



  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _jobTitleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _isCurrentlyWorking = false;
  String _employmentType = 'Full-time';
  int? _editingIndex;
  bool _showValidation = false;

  String? _validateStartDate(AppLocalizations l10n) {
    if (_startDate.isAfter(DateTime.now())) {
      return l10n.yearTooHigh; // Reusing yearTooHigh or could add dateTooHigh
    }
    return null;
  }

  String? _validateEndDate(AppLocalizations l10n) {
    if (_isCurrentlyWorking) return null;
    // Removed required check to allow implicit "Currently Working"
    if (_endDate != null && _endDate!.isAfter(DateTime.now())) {
      return l10n.yearTooHigh;
    }
    if (_endDate != null && _endDate!.isBefore(_startDate)) {
      return l10n.dateStartAfterEnd;
    }
    return null;
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _editWorkExperience(WorkExperience work, int index) {
    setState(() {
      _editingIndex = index;
      _jobTitleController.text = work.jobTitle;
      _companyController.text = work.companyName;
      _locationController.text = work.location ?? '';
      _descriptionController.text = work.responsibilities;
      _startDate = work.startDate;
      _endDate = work.endDate;
      _isCurrentlyWorking = work.isCurrentlyWorking;
      _employmentType = work.employmentType;
    });
  }

  void _resetForm() {
    setState(() {
      _editingIndex = null;
      _jobTitleController.clear();
      _companyController.clear();
      _locationController.clear();
      _descriptionController.clear();
      _startDate = DateTime.now();
      _endDate = null;
      _isCurrentlyWorking = false;
      _employmentType = 'Full-time';
      _showValidation = false;
    });
  }
  
  void _saveForm(CVBuilderProvider provider) {
    setState(() => _showValidation = true);
    if (_formKey.currentState!.validate()) {
      if (!_isCurrentlyWorking && _endDate != null && _endDate!.isBefore(_startDate)) {
        // Validation failed for dates
        return;
      }
      if (!_isCurrentlyWorking && _endDate != null && _endDate!.isAfter(DateTime.now())) {
         return;
      }
      if (_startDate.isAfter(DateTime.now())) {
         return;
      }
      // Removed check for null end date as it now implies "Currently Working"

      final work = WorkExperience(
        id: _editingIndex != null 
            ? provider.currentCV!.workExperience[_editingIndex!].id 
            : const Uuid().v4(),
        jobTitle: _jobTitleController.text.trim(),
        companyName: _companyController.text.trim(),
        location: _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : null,
        employmentType: _employmentType,
        startDate: _startDate,
        endDate: _isCurrentlyWorking || _endDate == null ? null : _endDate,
        isCurrentlyWorking: _isCurrentlyWorking || _endDate == null,
        responsibilities: _descriptionController.text.trim(),
      );

      if (_editingIndex != null) {
        provider.updateWorkExperience(_editingIndex!, work);
      } else {
        provider.addWorkExperience(work);
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
        autovalidateMode: _showValidation ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? l10n.editExperience : l10n.addExperience,
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
            const SizedBox(height: 24),
            
            // Job Title
            TextFormField(
              controller: _jobTitleController,
              decoration: InputDecoration(
                labelText: '${l10n.jobTitle} *',
                hintText: l10n.jobTitlePlaceholder,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              validator: (v) => v?.isEmpty == true ? l10n.requiredField : null,
              maxLength: 50,
            ),
            const SizedBox(height: 16),
            
            // Company
            TextFormField(
              controller: _companyController,
              decoration: InputDecoration(
                labelText: '${l10n.companyName} *',
                hintText: l10n.companyPlaceholder,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              validator: (v) => v?.isEmpty == true ? l10n.requiredField : null,
              maxLength: 50,
            ),
            const SizedBox(height: 16),
            
            // Employment Type
            DropdownButtonFormField<String>(
              // ignore: deprecated_member_use
              value: _employmentType,
              decoration: InputDecoration(
                labelText: l10n.employmentTypeLabel,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'Full-time', child: Text(l10n.employmentTypeFullTime)),
                DropdownMenuItem(value: 'Part-time', child: Text(l10n.employmentTypePartTime)),
                DropdownMenuItem(value: 'Contract', child: Text(l10n.employmentTypeContract)),
                DropdownMenuItem(value: 'Freelance', child: Text(l10n.employmentTypeFreelance)),
                DropdownMenuItem(value: 'Internship', child: Text(l10n.employmentTypeInternship)),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _employmentType = val);
              },
            ),
            const SizedBox(height: 16),
            
            // Location
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: '${l10n.location} ${l10n.optionalField}',
                hintText: l10n.locationPlaceholder,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Iconsax.location),
                counterText: '',
              ),
              maxLength: 50,
            ),
            const SizedBox(height: 16),
            
            // Dates
            Row(
              children: [
                Expanded(
                    child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: '${l10n.startDate} *',
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.calendar_today, size: 16),
                        errorText: _showValidation ? _validateStartDate(l10n) : null,
                      ),
                      child: Text('${_startDate.day}/${_startDate.month}/${_startDate.year}'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: _isCurrentlyWorking ? null : () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.endDate,
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.calendar_today, size: 16),
                        enabled: !_isCurrentlyWorking,
                        errorText: _showValidation ? _validateEndDate(l10n) : null,
                      ),
                      child: Text(
                        _isCurrentlyWorking 
                            ? l10n.present 
                            : (_endDate != null 
                                ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                : l10n.selectDate),
                        style: TextStyle(
                          color: _isCurrentlyWorking ? Colors.grey : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            CheckboxListTile(
              value: _isCurrentlyWorking,
              onChanged: (val) {
                setState(() {
                  _isCurrentlyWorking = val ?? false;
                  if (_isCurrentlyWorking) {
                    _endDate = null;
                  }
                });
              },
              title: Text(l10n.currentlyWorking),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            
            const SizedBox(height: 16),
            
            // Description (AI Enhanced)
            Stack(
              children: [
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: l10n.responsibilities,
                    hintText: l10n.responsibilitiesHint,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                    counterText: '',
                  ),
                  maxLength: 1000,
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Tooltip(
                    message: l10n.generateWithAi,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.purple.withValues(alpha: 0.1),
                      child: const Icon(Iconsax.magic_star, size: 16, color: Colors.purple),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
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
              child: Text(isEditing ? l10n.save : l10n.addExperience),
            ),
          ],
        ),
      ),
    );
  }
}
