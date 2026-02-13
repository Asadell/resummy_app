import 'package:flutter/material.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

/// Reusable CV Preview Card Widget
/// Displays CV data in a professional format
class CvPreviewCard extends StatelessWidget {
  final CVData? cvData;

  const CvPreviewCard({
    super.key,
    required this.cvData,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (cvData == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            l10n.noCvData,
            style: const TextStyle(color: Color(0xFF9CA3AF)),
          ),
        ),
      );
    }

    final cv = cvData!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Text(
              cv.name.isNotEmpty ? cv.name.toUpperCase() : l10n.yourNamePlaceholder,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: cv.name.isNotEmpty ? Colors.black : const Color(0xFF9CA3AF),
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
                _buildContactText(cv.email, l10n.userEmail),
                if (cv.email?.isNotEmpty == true || cv.phone?.isNotEmpty == true)
                  const Text('|', style: TextStyle(color: Color(0xFF9CA3AF))),
                _buildContactText(cv.phone, l10n.phoneNumber),
                if (cv.email?.isNotEmpty == true || cv.phone?.isNotEmpty == true || cv.location?.isNotEmpty == true)
                  const Text('|', style: TextStyle(color: Color(0xFF9CA3AF))),
                _buildContactText(cv.location, l10n.location),
              ],
            ),
          ),

          if (cv.linkedin?.isNotEmpty == true || cv.portfolio?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Center(
              child: Wrap(
                spacing: 12,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: [
                  if (cv.linkedin?.isNotEmpty == true)
                    const Text('LinkedIn', style: TextStyle(color: Colors.blue, fontSize: 12)),
                  if (cv.portfolio?.isNotEmpty == true)
                    const Text('Portfolio', style: TextStyle(color: Colors.blue, fontSize: 12)),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),
          const Divider(thickness: 1),
          const SizedBox(height: 16),

          // Professional Summary
          if (cv.professionalSummary?.isNotEmpty == true) ...[
            _buildSectionTitle(l10n.summaryHeader.toUpperCase()),
            Text(
              cv.professionalSummary!,
              style: const TextStyle(height: 1.5, fontSize: 14),
            ),
            const SizedBox(height: 20),
          ],

          // Work Experience
          if (cv.workExperience.isNotEmpty) ...[
            _buildSectionTitle(l10n.experienceHistoryHeader.toUpperCase()),
            ...cv.workExperience.map((work) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          work.jobTitle.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '${work.startDate.month}/${work.startDate.year} - ${work.isCurrentlyWorking ? l10n.present : "${work.endDate?.month}/${work.endDate?.year}"}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${work.companyName}${work.location != null ? ", ${work.location}" : ""}',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  if (work.responsibilities.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      work.responsibilities,
                      style: const TextStyle(height: 1.4, fontSize: 13),
                    ),
                  ],
                ],
              ),
            )),
            const SizedBox(height: 8),
          ],

          // Education
          if (cv.education.isNotEmpty) ...[
            _buildSectionTitle(l10n.educationHistoryHeader.toUpperCase()),
            ...cv.education.map((edu) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          edu.institution.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '${edu.startYear} - ${edu.isCurrentlyStudying ? l10n.present : (edu.endYear ?? "")}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${edu.degree}, ${edu.major}${edu.gpa != null ? " (IPK: ${edu.gpa})" : ""}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 8),
          ],

          // Skills
          if (cv.technicalSkills.isNotEmpty || cv.softSkills.isNotEmpty) ...[
            _buildSectionTitle(l10n.skillsHeader.toUpperCase()),
            if (cv.technicalSkills.isNotEmpty) ...[
              Text(
                '${l10n.labelTechnicalSkills}:',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                cv.technicalSkills.join(', '),
                style: const TextStyle(height: 1.5, fontSize: 13),
              ),
              const SizedBox(height: 8),
            ],
            if (cv.softSkills.isNotEmpty) ...[
              Text(
                '${l10n.labelSoftSkills}:',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                cv.softSkills.join(', '),
                style: const TextStyle(height: 1.5, fontSize: 13),
              ),
            ],
            const SizedBox(height: 20),
          ],

          // Certifications
          if (cv.certifications.isNotEmpty) ...[
            _buildSectionTitle(l10n.certificationHeader.toUpperCase()),
            ...cv.certifications.map((cert) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '• ${cert.name} - ${cert.issuingOrganization} (${cert.issueDate.year})',
                style: const TextStyle(height: 1.4, fontSize: 13),
              ),
            )),
            const SizedBox(height: 20),
          ],

          // Additional Sections
          if (cv.additionalSections.isNotEmpty) ...[
            ...cv.additionalSections.entries.map((entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(entry.key.toUpperCase()),
                Text(
                  entry.value.toString(),
                  style: const TextStyle(height: 1.5, fontSize: 13),
                ),
                const SizedBox(height: 20),
              ],
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildContactText(String? value, String placeholder) {
    return Text(
      value?.isNotEmpty == true ? value! : placeholder,
      style: TextStyle(
        fontSize: 12,
        color: value?.isNotEmpty == true ? const Color(0xFF374151) : const Color(0xFF9CA3AF),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
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
