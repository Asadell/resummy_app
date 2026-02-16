import 'package:flutter/material.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

/// Reusable CV Preview Card Widget with ATS-friendly formatting
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
        // Header (Personal Info) - Always shown
        _buildHeader(cv, l10n),
        
        const SizedBox(height: 16),
        
        // Render sections in user-defined order
        ...cv.sections.where((s) => s.isVisible).map((section) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildSection(section, l10n),
          );
        }).toList(),
      ],
    );
  }

  // ATS-friendly header
  Widget _buildHeader(CVData cv, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name - ATS prefers left-aligned, simple formatting
        Text(
          cv.name.isNotEmpty ? cv.name.toUpperCase() : l10n.yourNamePlaceholder,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            height: 1.2,
            color: cv.name.isNotEmpty ? Colors.black : const Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 8),

        // Contact Info - Simple, scannable format
        if (cv.email?.isNotEmpty == true)
          _buildContactLine('Email', cv.email!),
        if (cv.phone?.isNotEmpty == true)
          _buildContactLine('Phone', cv.phone!),
        if (cv.location?.isNotEmpty == true)
          _buildContactLine('Location', cv.location!),
        if (cv.linkedin?.isNotEmpty == true)
          _buildContactLine('LinkedIn', cv.linkedin!),
        if (cv.portfolio?.isNotEmpty == true)
          _buildContactLine('Portfolio', cv.portfolio!),
      ],
    );
  }

  Widget _buildContactLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 10,
          height: 1.4,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Build section based on type
  Widget _buildSection(SectionData section, AppLocalizations l10n) {
    if (section is SummarySection) {
      return _buildSummarySection(section);
    } else if (section is ExperienceSection) {
      return _buildExperienceSection(section);
    } else if (section is EducationSection) {
      return _buildEducationSection(section);
    } else if (section is OrganizationSection) {
      return _buildOrganizationSection(section);
    } else if (section is SkillsSection) {
      return _buildSkillsSection(section);
    } else if (section is CertificationsSection) {
      return _buildCertificationsSection(section);
    } else if (section is CustomSection) {
      return _buildCustomSection(section);
    }
    return const SizedBox.shrink();
  }

  // ATS-friendly section header
  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          height: 1,
          color: Colors.black,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSummarySection(SummarySection section) {
    if (section.content.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(section.title),
        Text(
          section.content,
          style: const TextStyle(
            fontSize: 10,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceSection(ExperienceSection section) {
    if (section.entries.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(section.title),
        ...section.entries.map((exp) => _buildExperienceEntry(exp)).toList(),
      ],
    );
  }

  Widget _buildExperienceEntry(WorkExperience exp) {
    final dateFormat = DateFormat('MMM yyyy');
    final startDate = dateFormat.format(exp.startDate);
    final endDate = exp.isCurrentlyWorking ? 'Present' : dateFormat.format(exp.endDate!);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Title
          Text(
            exp.jobTitle,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 2),
          
          // Company & Date
          Text(
            '${exp.companyName} | $startDate - $endDate',
            style: const TextStyle(
              fontSize: 10,
              height: 1.3,
              color: Colors.black87,
            ),
          ),
          
          if (exp.location?.isNotEmpty == true) ...[
            const SizedBox(height: 1),
            Text(
              exp.location!,
              style: const TextStyle(
                fontSize: 9,
                height: 1.3,
                color: Colors.black54,
              ),
            ),
          ],
          
          const SizedBox(height: 4),
          
          // Responsibilities
          ...exp.responsibilities.split('\n').where((r) => r.trim().isNotEmpty).map((resp) {
            return Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 10)),
                  Expanded(
                    child: Text(
                      resp.trim(),
                      style: const TextStyle(
                        fontSize: 10,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildEducationSection(EducationSection section) {
    if (section.entries.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(section.title),
        ...section.entries.map((edu) => _buildEducationEntry(edu)).toList(),
      ],
    );
  }

  Widget _buildEducationEntry(Education edu) {
    final endYear = edu.isCurrentlyStudying ? 'Present' : edu.endYear?.toString() ?? '';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Degree & Major
          Text(
            '${edu.degree} in ${edu.major}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 2),
          
          // Institution & Year
          Text(
            '${edu.institution} | ${edu.startYear} - $endYear',
            style: const TextStyle(
              fontSize: 10,
              height: 1.3,
              color: Colors.black87,
            ),
          ),
          
          if (edu.gpa?.isNotEmpty == true) ...[
            const SizedBox(height: 2),
            Text(
              'GPA: ${edu.gpa}',
              style: const TextStyle(
                fontSize: 10,
                height: 1.3,
                color: Colors.black87,
              ),
            ),
          ],
          
          if (edu.achievements?.isNotEmpty == true) ...[
            const SizedBox(height: 3),
            ...edu.achievements!.split('\n').where((a) => a.trim().isNotEmpty).map((achievement) {
              return Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 10)),
                    Expanded(
                      child: Text(
                        achievement.trim(),
                        style: const TextStyle(
                          fontSize: 10,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildOrganizationSection(OrganizationSection section) {
    if (section.entries.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(section.title),
        ...section.entries.map((org) => _buildOrganizationEntry(org)).toList(),
      ],
    );
  }

  Widget _buildOrganizationEntry(OrganizationExperience org) {
    final dateFormat = DateFormat('MMM yyyy');
    final startDate = dateFormat.format(org.startDate);
    final endDate = org.isCurrentlyActive ? 'Present' : dateFormat.format(org.endDate!);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role
          Text(
            org.role,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 2),
          
          // Organization & Date
          Text(
            '${org.organizationName} | $startDate - $endDate',
            style: const TextStyle(
              fontSize: 10,
              height: 1.3,
              color: Colors.black87,
            ),
          ),
          
          if (org.location?.isNotEmpty == true) ...[
            const SizedBox(height: 1),
            Text(
              org.location!,
              style: const TextStyle(
                fontSize: 9,
                height: 1.3,
                color: Colors.black54,
              ),
            ),
          ],
          
          const SizedBox(height: 3),
          
          // Description
          ...org.description.split('\n').where((d) => d.trim().isNotEmpty).map((desc) {
            return Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 10)),
                  Expanded(
                    child: Text(
                      desc.trim(),
                      style: const TextStyle(
                        fontSize: 10,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(SkillsSection section) {
    if (section.skillCategories.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(section.title),
        ...section.skillCategories.entries.where((e) => e.value.isNotEmpty).map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    '${entry.key}:',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    entry.value.join(', '),
                    style: const TextStyle(
                      fontSize: 10,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCertificationsSection(CertificationsSection section) {
    if (section.entries.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(section.title),
        ...section.entries.map((cert) => _buildCertificationEntry(cert)).toList(),
      ],
    );
  }

  Widget _buildCertificationEntry(Certification cert) {
    final dateFormat = DateFormat('MMM yyyy');
    final issueDate = dateFormat.format(cert.issueDate);
    final expiryInfo = cert.doesNotExpire 
        ? 'No Expiration' 
        : cert.expirationDate != null 
            ? 'Expires: ${dateFormat.format(cert.expirationDate!)}'
            : '';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Certification Name
          Text(
            cert.name,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 2),
          
          // Issuing Organization & Date
          Text(
            '${cert.issuingOrganization} | Issued: $issueDate',
            style: const TextStyle(
              fontSize: 10,
              height: 1.3,
              color: Colors.black87,
            ),
          ),
          
          if (expiryInfo.isNotEmpty) ...[
            const SizedBox(height: 1),
            Text(
              expiryInfo,
              style: const TextStyle(
                fontSize: 9,
                height: 1.3,
                color: Colors.black54,
              ),
            ),
          ],
          
          if (cert.credentialId?.isNotEmpty == true) ...[
            const SizedBox(height: 1),
            Text(
              'Credential ID: ${cert.credentialId}',
              style: const TextStyle(
                fontSize: 9,
                height: 1.3,
                color: Colors.black54,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomSection(CustomSection section) {
    if (section.content.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(section.title),
        
        // Render based on template
        if (section.template == SectionTemplate.paragraph)
          Text(
            section.content,
            style: const TextStyle(
              fontSize: 10,
              height: 1.5,
              color: Colors.black87,
            ),
          )
        else
          // Bullet list or simple list
          ...section.content.split('\n').where((line) => line.trim().isNotEmpty).map((line) {
            return Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 10)),
                  Expanded(
                    child: Text(
                      line.trim(),
                      style: const TextStyle(
                        fontSize: 10,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      ],
    );
  }
}
