import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class CvBuilderStep2Screen extends StatefulWidget {
  const CvBuilderStep2Screen({super.key});

  @override
  State<CvBuilderStep2Screen> createState() => _CvBuilderStep2ScreenState();
}

class _CvBuilderStep2ScreenState extends State<CvBuilderStep2Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Pendidikan'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '2/7',
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
            value: 2 / 7,
            backgroundColor: const Color(0xFFE5E7EB),
            color: const Color(0xFF0EA5E9),
            minHeight: 4,
          ),
          
          Expanded(
            child: Consumer<CVBuilderProvider>(
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
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFF0EA5E9)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Step 2/7',
                            style: TextStyle(
                              color: Color(0xFF0EA5E9),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          '2. Riwayat Pendidikan',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Center(
                        child: Text(
                          'Tambahkan pendidikan formal/non-formal',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Iconsax.teacher,
                                  size: 48,
                                  color: Color(0xFF9CA3AF),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Belum ada data pendidikan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Tambahkan riwayat pendidikanmu agar CV terlihat lebih profesional.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                OutlinedButton.icon(
                                  onPressed: () => _showEducationForm(context),
                                  icon: const Icon(Iconsax.add),
                                  label: const Text('Tambah Pendidikan'),
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
                                ? '${edu.startYear} - Sekarang'
                                : '${edu.startYear} - ${edu.endYear ?? "Terkini"}';
                                
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
                                      style: const TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (edu.gpa != null && edu.gpa!.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'IPK: ${edu.gpa}',
                                        style: const TextStyle(
                                          color: Color(0xFF0EA5E9),
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
                                      onPressed: () => _showEducationForm(context, education: edu, index: index),
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
                        
                        OutlinedButton.icon(
                          onPressed: () => _showEducationForm(context),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            side: const BorderSide(color: Color(0xFF0EA5E9)),
                          ),
                          icon: const Icon(Iconsax.add),
                          label: const Text('Tambah Pendidikan Lainnya'),
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
                  child: const Text('Kembali'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Save and next
                    context.read<CVBuilderProvider>().saveCurrentCV();
                    context.router.push(const CvBuilderStep3Route());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Lanjut →'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEducationForm(BuildContext context, {Education? education, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EducationForm(education: education, index: index),
    );
  }
}

class _EducationForm extends StatefulWidget {
  final Education? education;
  final int? index;

  const _EducationForm({this.education, this.index});

  @override
  State<_EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<_EducationForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _institutionController;
  late TextEditingController _majorController;
  late TextEditingController _degreeController;
  late TextEditingController _gpaController;
  late TextEditingController _startYearController;
  late TextEditingController _endYearController;
  bool _isCurrentlyStudying = false;

  @override
  void initState() {
    super.initState();
    _institutionController = TextEditingController(text: widget.education?.institution);
    _majorController = TextEditingController(text: widget.education?.major);
    _degreeController = TextEditingController(text: widget.education?.degree);
    _gpaController = TextEditingController(text: widget.education?.gpa);
    _startYearController = TextEditingController(text: widget.education?.startYear.toString());
    _endYearController = TextEditingController(text: widget.education?.endYear?.toString());
    _isCurrentlyStudying = widget.education?.isCurrentlyStudying ?? false;
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

  void _save() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<CVBuilderProvider>();
      final edu = Education(
        id: widget.education?.id ?? const Uuid().v4(),
        institution: _institutionController.text.trim(),
        major: _majorController.text.trim(),
        degree: _degreeController.text.trim(),
        gpa: _gpaController.text.trim(),
        startYear: int.tryParse(_startYearController.text) ?? DateTime.now().year,
        endYear: _isCurrentlyStudying ? null : int.tryParse(_endYearController.text),
        isCurrentlyStudying: _isCurrentlyStudying,
      );

      if (widget.index != null) {
        provider.updateEducation(widget.index!, edu);
      } else {
        provider.addEducation(edu);
      }
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      widget.education != null ? 'Edit Pendidikan' : 'Tambah Pendidikan',
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
                
                // Institution
                TextFormField(
                  controller: _institutionController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Institusi *',
                    hintText: 'Universitas Indonesia',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                
                // Major
                TextFormField(
                  controller: _majorController,
                  decoration: const InputDecoration(
                    labelText: 'Jurusan *',
                    hintText: 'Teknik Informatika',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                
                // Degree
                TextFormField(
                  controller: _degreeController,
                  decoration: const InputDecoration(
                    labelText: 'Gelar *',
                    hintText: 'Sarjana (S1)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                
                // Years
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _startYearController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Tahun Mulai *',
                          hintText: '2018',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v?.isEmpty == true ? 'Wajib diisi' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _endYearController,
                        keyboardType: TextInputType.number,
                        enabled: !_isCurrentlyStudying,
                        decoration: const InputDecoration(
                          labelText: 'Tahun Selesai',
                          hintText: '2022',
                          border: OutlineInputBorder(),
                        ),
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
                  title: const Text('Masih belajar di sini'),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                
                const SizedBox(height: 8),
                
                // GPA
                TextFormField(
                  controller: _gpaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'IPK / Nilai Akhir (Opsional)',
                    hintText: '3.85',
                    border: OutlineInputBorder(),
                  ),
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
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
