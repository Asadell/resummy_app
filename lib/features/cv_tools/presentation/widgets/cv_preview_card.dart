import 'package:flutter/material.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

/// Reusable CV Preview Card Widget
/// Displays CV data in A4 format with professional layout
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
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.noCvData,
            style: const TextStyle(color: Color(0xFF9CA3AF)),
          ),
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AspectRatio(
            aspectRatio: 210 / 297, // A4 aspect ratio
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(40.0), // CV margins (approx 20mm)
                  child: _buildCVContent(context, cvData!, l10n),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCVContent(BuildContext context, CVData cv, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Center(
          child: Text(
            cv.name.isNotEmpty ? cv.name.toUpperCase() : l10n.yourNamePlaceholder,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: cv.name.isNotEmpty ? Colors.black : const Color(0xFF9CA3AF),
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Contact Info
        Center(
          child: Column(
            children: [
              if (cv.email?.isNotEmpty == true || cv.phone?.isNotEmpty == true)
                Wrap(
                  spacing: 8,
                  runSpacing: 2,
                  alignment: WrapAlignment.center,
                  children: [
                    if (cv.email?.isNotEmpty == true)
                      _buildContactText(cv.email, l10n.userEmail),
                    if (cv.email?.isNotEmpty == true && cv.phone?.isNotEmpty == true)
                      const Text('•', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 8)),
                    if (cv.phone?.isNotEmpty == true)
                      _buildContactText(cv.phone, l10n.phoneNumber),
                  ],
                ),
              if (cv.location?.isNotEmpty == true) ...[
                const SizedBox(height: 2),
                _buildContactText(cv.location, l10n.location),
              ],
            ],
          ),
        ),

        if (cv.linkedin?.isNotEmpty == true || cv.portfolio?.isNotEmpty == true) ...[
          const SizedBox(height: 3),
          Center(
            child: Wrap(
              spacing: 10,
              runSpacing: 2,
              alignment: WrapAlignment.center,
              children: [
                if (cv.linkedin?.isNotEmpty == true)
                  const Text('LinkedIn', style: TextStyle(color: Colors.blue, fontSize: 8)),
                if (cv.portfolio?.isNotEmpty == true)
                  const Text('Portfolio', style: TextStyle(color: Colors.blue, fontSize: 8)),
              ],
            ),
          ),
        ],

        const SizedBox(height: 12),
        const Divider(thickness: 1, color: Colors.black),
        const SizedBox(height: 10),

        // Professional Summary
        if (cv.professionalSummary?.isNotEmpty == true) ...[
          _buildSectionTitle(l10n.summaryHeader.toUpperCase()),
          const SizedBox(height: 4),
          Text(
            cv.professionalSummary!,
            style: const TextStyle(height: 1.4, fontSize: 8),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 10),
        ],

        // Work Experience
        if (cv.workExperience.isNotEmpty) ...[
          _buildSectionTitle(l10n.experienceHistoryHeader.toUpperCase()),
          const SizedBox(height: 6),
          ...cv.workExperience.map((work) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        work.jobTitle.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${work.startDate.month}/${work.startDate.year} - ${work.isCurrentlyWorking ? l10n.present : "${work.endDate?.month}/${work.endDate?.year}"}',
                      style: const TextStyle(fontSize: 7, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${work.companyName}${work.location != null ? ", ${work.location}" : ""}',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 8,
                    color: Color(0xFF374151),
                  ),
                ),
                if (work.responsibilities.isNotEmpty) ...[ 
                  const SizedBox(height: 3),
                  Text(
                    work.responsibilities,
                    style: const TextStyle(height: 1.4, fontSize: 7.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ],
            ),
          )),
        ],

        // Education
        if (cv.education.isNotEmpty) ...[
          _buildSectionTitle(l10n.educationHistoryHeader.toUpperCase()),
          const SizedBox(height: 6),
          ...cv.education.map((edu) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        edu.institution.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${edu.startYear} - ${edu.isCurrentlyStudying ? l10n.present : (edu.endYear ?? "")}',
                      style: const TextStyle(fontSize: 7, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${edu.degree}, ${edu.major}${edu.gpa != null ? " (IPK: ${edu.gpa})" : ""}',
                  style: const TextStyle(fontSize: 8),
                ),
              ],
            ),
          )),
        ],

        // Skills
        if (cv.technicalSkills.isNotEmpty || cv.softSkills.isNotEmpty) ...[
          _buildSectionTitle(l10n.skillsHeader.toUpperCase()),
          const SizedBox(height: 6),
          if (cv.technicalSkills.isNotEmpty) ...[
            Text(
              '${l10n.labelTechnicalSkills}:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 8),
            ),
            const SizedBox(height: 2),
            Text(
              cv.technicalSkills.join(', '),
              style: const TextStyle(height: 1.4, fontSize: 7.5),
            ),
            const SizedBox(height: 5),
          ],
          if (cv.softSkills.isNotEmpty) ...[
            Text(
              '${l10n.labelSoftSkills}:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 8),
            ),
            const SizedBox(height: 2),
            Text(
              cv.softSkills.join(', '),
              style: const TextStyle(height: 1.4, fontSize: 7.5),
            ),
            const SizedBox(height: 6),
          ],
        ],

        // Certifications
        if (cv.certifications.isNotEmpty) ...[
          _buildSectionTitle(l10n.certificationHeader.toUpperCase()),
          const SizedBox(height: 6),
          ...cv.certifications.map((cert) => Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              '• ${cert.name} - ${cert.issuingOrganization} (${cert.issueDate.year})',
              style: const TextStyle(height: 1.4, fontSize: 7.5),
            ),
          )),
          const SizedBox(height: 6),
        ],

        // Additional Sections
        if (cv.additionalSections.isNotEmpty) ...[
          ...cv.additionalSections.entries.map((entry) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(entry.key.toUpperCase()),
              const SizedBox(height: 4),
              Text(
                entry.value.toString(),
                style: const TextStyle(height: 1.4, fontSize: 7.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
            ],
          )),
        ],
      ],
    );
  }

  Widget _buildContactText(String? value, String placeholder) {
    return Text(
      value?.isNotEmpty == true ? value! : placeholder,
      style: TextStyle(
        fontSize: 8,
        color: value?.isNotEmpty == true ? const Color(0xFF374151) : const Color(0xFF9CA3AF),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          height: 1.5,
          width: 30,
          color: const Color(0xFF0EA5E9),
        ),
      ],
    );
  }
}
