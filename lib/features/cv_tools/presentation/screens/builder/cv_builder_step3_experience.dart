import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
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
    
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text(l10n.experienceHistoryHeader),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '3/7',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: 3 / 7,
            backgroundColor: const Color(0xFFE5E7EB),
            color: const Color(0xFF0EA5E9),
            minHeight: 4,
          ),
          
          Expanded(
            child: Consumer<CVBuilderProvider>(
              builder: (context, provider, child) {
                final workList = provider.currentCV?.workExperience ?? [];
                
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
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFF0EA5E9)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            l10n.stepHeader(3, 7),
                            style: const TextStyle(
                              color: Color(0xFF0EA5E9),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          l10n.experienceHistoryHeader,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          l10n.experienceHistoryDesc,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
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
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF374151),
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
                                const SizedBox(height: 24),
                                OutlinedButton.icon(
                                  onPressed: () => _showWorkForm(context),
                                  icon: const Icon(Iconsax.add),
                                  label: Text(l10n.addExperience),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                      // List of Work Experience
                      if (workList.isNotEmpty) ...[
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: workList.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final work = workList[index];
                            final start = '${work.startDate.month}/${work.startDate.year}';
                            final end = work.isCurrentlyWorking 
                                ? l10n.present
                                : '${work.endDate?.month}/${work.endDate?.year}';
                                
                            return Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
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
                                      onPressed: () => _showWorkForm(context, work: work, index: index),
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
                        
                        OutlinedButton.icon(
                          onPressed: () => _showWorkForm(context),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            side: const BorderSide(color: Color(0xFF0EA5E9)),
                          ),
                          icon: const Icon(Iconsax.add),
                          label: Text(l10n.addAnotherExperience),
                        ),
                      ],
                      
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -4),
              blurRadius: 16,
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.router.maybePop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(l10n.goBack),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Save and next
                    context.read<CVBuilderProvider>().saveCurrentCV();
                    context.router.push(const CvBuilderStep4Route());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('${l10n.next} →'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWorkForm(BuildContext context, {WorkExperience? work, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _WorkExperienceForm(work: work, index: index),
    );
  }
}

class _WorkExperienceForm extends StatefulWidget {
  final WorkExperience? work;
  final int? index;

  const _WorkExperienceForm({this.work, this.index});

  @override
  State<_WorkExperienceForm> createState() => _WorkExperienceFormState();
}

class _WorkExperienceFormState extends State<_WorkExperienceForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _isCurrentlyWorking = false;
  String _employmentType = 'Full-time';

  @override
  void initState() {
    super.initState();
    _jobTitleController = TextEditingController(text: widget.work?.jobTitle);
    _companyController = TextEditingController(text: widget.work?.companyName);
    _locationController = TextEditingController(text: widget.work?.location);
    _descriptionController = TextEditingController(text: widget.work?.responsibilities);
    
    if (widget.work != null) {
      _startDate = widget.work!.startDate;
      _endDate = widget.work!.endDate;
      _isCurrentlyWorking = widget.work!.isCurrentlyWorking;
      _employmentType = widget.work!.employmentType;
    }
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (_endDate == null && !_isCurrentlyWorking) {
        // Show error for end date if not currently working
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(AppLocalizations.of(context)!.endDateError)),
        );
        return;
      }

      final provider = context.read<CVBuilderProvider>();
      final work = WorkExperience(
        id: widget.work?.id ?? const Uuid().v4(),
        jobTitle: _jobTitleController.text.trim(),
        companyName: _companyController.text.trim(),
        location: _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : null,
        employmentType: _employmentType,
        startDate: _startDate,
        endDate: _isCurrentlyWorking ? null : _endDate,
        isCurrentlyWorking: _isCurrentlyWorking,
        responsibilities: _descriptionController.text.trim(),
      );

      if (widget.index != null) {
        provider.updateWorkExperience(widget.index!, work);
      } else {
        provider.addWorkExperience(work);
      }
      
      Navigator.pop(context);
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

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.work != null ? l10n.editExperience : l10n.addExperience,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Job Title
                TextFormField(
                  controller: _jobTitleController,
                  decoration: InputDecoration(
                    labelText: '${l10n.jobTitle} *',
                    hintText: 'Software Engineer',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) => v?.isEmpty == true ? l10n.requiredField : null,
                ),
                const SizedBox(height: 16),
                
                // Company
                TextFormField(
                  controller: _companyController,
                  decoration: InputDecoration(
                    labelText: '${l10n.companyName} *',
                    hintText: 'Google Inc.',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) => v?.isEmpty == true ? l10n.requiredField : null,
                ),
                const SizedBox(height: 16),
                
                // Employment Type
                DropdownButtonFormField<String>(
                  value: _employmentType,
                  decoration: const InputDecoration(
                    labelText: 'Tipe Pekerjaan',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Full-time', child: Text('Full-time')),
                    DropdownMenuItem(value: 'Part-time', child: Text('Part-time')),
                    DropdownMenuItem(value: 'Contract', child: Text('Contract')),
                    DropdownMenuItem(value: 'Freelance', child: Text('Freelance')),
                    DropdownMenuItem(value: 'Internship', child: Text('Internship')),
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
                    hintText: 'Jakarta, Indonesia',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Iconsax.location),
                  ),
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
                          ),
                          child: Text(
                            _isCurrentlyWorking 
                                ? l10n.present 
                                : (_endDate != null 
                                    ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                    : l10n.selectDate),
                            style: TextStyle(
                              color: _isCurrentlyWorking ? Colors.grey : Colors.black,
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
                      ),
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
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(l10n.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
