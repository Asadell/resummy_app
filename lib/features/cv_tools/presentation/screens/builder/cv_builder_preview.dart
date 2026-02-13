import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/utils/cv_pdf_service.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';

@RoutePage()
class CvBuilderPreviewScreen extends StatefulWidget {
  const CvBuilderPreviewScreen({super.key});

  @override
  State<CvBuilderPreviewScreen> createState() => _CvBuilderPreviewScreenState();
}

class _CvBuilderPreviewScreenState extends State<CvBuilderPreviewScreen> {
  bool _isGenerating = false;

  Future<void> _downloadPdf(CVData cv) async {
    setState(() => _isGenerating = true);
    try {
      final service = CvPdfService();
      final path = await service.generateAndSavePDF(cv);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CV saved to $path'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate PDF: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CVBuilderProvider>(
      builder: (context, provider, child) {
        final cv = provider.currentCV;
        if (cv == null) {
          return const Scaffold(
            body: Center(child: Text('No CV Data Found')),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFF525659), // Dark background like PDF viewers
          appBar: AppBar(
            title: const Text('Preview CV'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Iconsax.edit),
                onPressed: () {
                  // Navigate back to edit (e.g., step 1) or stay here
                  context.router.push(const CvBuilderStep1Route());
                },
              ),
            ],
          ),
          body: _isGenerating 
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800), // A4-ish width limit
                      padding: const EdgeInsets.all(32), // Margins
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Center(
                            child: Text(
                              cv.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Contact Info
                          Center(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              alignment: WrapAlignment.center,
                              children: [
                                if (cv.email != null && cv.email!.isNotEmpty) Text(cv.email!),
                                if (cv.email != null && cv.email!.isNotEmpty && cv.phone != null && cv.phone!.isNotEmpty) const Text('|'),
                                if (cv.phone != null && cv.phone!.isNotEmpty) Text(cv.phone!),
                                if (cv.location != null && cv.location!.isNotEmpty) ...[
                                  const Text('|'),
                                  Text(cv.location!),
                                ],
                              ],
                            ),
                          ),
                          Center(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              alignment: WrapAlignment.center,
                              children: [
                                if (cv.linkedin != null && cv.linkedin!.isNotEmpty) 
                                  const Text('LinkedIn', style: TextStyle(color: Colors.blue)),
                                if (cv.portfolio != null && cv.portfolio!.isNotEmpty) 
                                  const Text('Portfolio', style: TextStyle(color: Colors.blue)),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          const Divider(thickness: 1),
                          const SizedBox(height: 16),
                          
                          // Summary
                          if (cv.summary != null && cv.summary!.isNotEmpty) ...[
                            _buildSectionTitle('SUMMARY'),
                            Text(cv.summary!, style: const TextStyle(height: 1.5)),
                            const SizedBox(height: 24),
                          ],
                          
                          // Experience
                          if (cv.workExperience.isNotEmpty) ...[
                            _buildSectionTitle('EXPERIENCE'),
                            ...cv.workExperience.map((work) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        work.jobTitle.toUpperCase(),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${work.startDate.month}/${work.startDate.year} - ${work.isCurrentlyWorking ? "Present" : "${work.endDate?.month}/${work.endDate?.year}"}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${work.companyName}${work.location != null ? ", ${work.location}" : ""}',
                                    style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                                  ),
                                  if (work.responsibilities.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      work.responsibilities,
                                      style: const TextStyle(height: 1.4),
                                    ),
                                  ],
                                ],
                              ),
                            )),
                            const SizedBox(height: 8),
                          ],
                          
                          // Education
                          if (cv.education.isNotEmpty) ...[
                            _buildSectionTitle('EDUCATION'),
                            ...cv.education.map((edu) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        edu.institution.toUpperCase(),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${edu.startYear} - ${edu.isCurrentlyStudying ? "Present" : (edu.endYear ?? "")}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${edu.degree}, ${edu.major}${edu.gpa != null ? " (GPA: ${edu.gpa})" : ""}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            )),
                            const SizedBox(height: 8),
                          ],
                          
                          // Skills
                          if (cv.skills.isNotEmpty) ...[
                            _buildSectionTitle('SKILLS'),
                            Text(
                              cv.skills.join(', '),
                              style: const TextStyle(height: 1.5),
                            ),
                            const SizedBox(height: 24),
                          ],
                          
                          // Certifications
                          if (cv.certifications.isNotEmpty) ...[
                            _buildSectionTitle('CERTIFICATIONS'),
                            ...cv.certifications.map((cert) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                '• ${cert.name} - ${cert.issuingOrganization} (${cert.issueDate.year})',
                                style: const TextStyle(height: 1.4),
                              ),
                            )),
                            const SizedBox(height: 24),
                          ],
                          
                          // Additional Sections
                          if (cv.additionalSections.isNotEmpty) ...[
                             ...cv.additionalSections.entries.map((entry) => Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 _buildSectionTitle(entry.key.toUpperCase()),
                                 Text(entry.value.toString(), style: const TextStyle(height: 1.5)),
                                 const SizedBox(height: 24),
                               ],
                             )),
                          ],
                        ], // Column children
                      ),
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _isGenerating ? null : () => _downloadPdf(cv),
            icon: const Icon(Iconsax.document_download),
            label: const Text('Download PDF'),
            backgroundColor: const Color(0xFF0EA5E9),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: Color(0xFF0EA5E9),
            ),
          ),
          const SizedBox(height: 4),
          const Divider(thickness: 1, height: 1),
        ],
      ),
    );
  }
}
