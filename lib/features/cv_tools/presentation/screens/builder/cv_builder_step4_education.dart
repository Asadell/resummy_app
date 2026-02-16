import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_builder_step_layout.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
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

    return CVBuilderStepLayout(
      title: l10n.cvBuilder,
      currentStep: 4,
      totalSteps: 8,
      onBack: () => context.router.maybePop(),
      onNext: () {
        context.read<CVBuilderProvider>().saveCurrentCV();
        context.router.push(const CvBuilderStep5Route());
      },
      editContent: Consumer<CVBuilderProvider>(
        builder: (context, provider, child) {
          final educationList = provider.currentCV?.education ?? [];
          
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
                      color: Theme.of(context).cardColor,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.stepHeader(4, 8),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    l10n.educationHistoryHeader,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    l10n.educationHistoryDesc,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Empty State
                if (educationList.isEmpty)
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
                            Iconsax.teacher,
                            size: 48,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noEducationData,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                  
                // List of Education
                if (educationList.isNotEmpty) ...[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: educationList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final edu = educationList[index];
                      final period = edu.isCurrentlyStudying 
                          ? '${edu.startYear} - ${l10n.present}'
                          : '${edu.startYear} - ${edu.endYear ?? l10n.present}';
                          
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            edu.institution,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('${edu.degree} - ${edu.major}'),
                              const SizedBox(height: 4),
                              Text(
                                period,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF6B7280),
                                  fontSize: 12,
                                ),
                              ),
                              if (edu.gpa != null && edu.gpa!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'IPK: ${edu.gpa}',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
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
                                icon: const Icon(Iconsax.trash, size: 20, color: Colors.red),
                                onPressed: () => provider.removeEducation(index),
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
        startYear: int.tryParse(_startYearController.text) ?? DateTime.now().year,
        endYear: _isCurrentlyStudying ? null : int.tryParse(_endYearController.text),
        isCurrentlyStudying: _isCurrentlyStudying,
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
        autovalidateMode: _showValidation ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
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
            
            // Institution
            TextFormField(
              controller: _institutionController,
              decoration: InputDecoration(
                labelText: '${l10n.institutionName} *',
                hintText: 'Politeknik Elektronika Negeri Surabaya',
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              validator: (v) => v?.isEmpty == true ? l10n.requiredField : null,
              maxLength: 50,
            ),
            const SizedBox(height: 16),
            
            // Major
            TextFormField(
              controller: _majorController,
              decoration: InputDecoration(
                labelText: '${l10n.major} *',
                hintText: 'Teknik Informatika',
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              validator: (v) => v?.isEmpty == true ? l10n.requiredField : null,
              maxLength: 50,
            ),
            const SizedBox(height: 16),
            
            // Degree
            TextFormField(
              controller: _degreeController,
              decoration: InputDecoration(
                labelText: '${l10n.degree} ${l10n.optionalField}',
                hintText: 'Sarjana (S1)',
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              maxLength: 50,
            ),
            const SizedBox(height: 16),
            
            // Years
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startYearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '${l10n.startYear} *',
                      hintText: '2018',
                      border: const OutlineInputBorder(),
                      counterText: '',
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return l10n.requiredField;
                      final year = int.tryParse(v);
                      if (year == null) return l10n.requiredField;
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
                      hintText: '2022',
                      border: const OutlineInputBorder(),
                      counterText: '',
                    ),
                    validator: _isCurrentlyStudying ? null : (v) {
                      if (v == null || v.isEmpty) return l10n.requiredField;
                      final endYear = int.tryParse(v);
                      if (endYear == null) return l10n.requiredField;
                      
                      if (endYear > DateTime.now().year) return l10n.yearTooHigh;
                      
                      final startYear = int.tryParse(_startYearController.text);
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
            
            // GPA
            TextFormField(
              controller: _gpaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.gpaOptional,
                hintText: '3.85',
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


