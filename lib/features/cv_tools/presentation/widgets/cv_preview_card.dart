import 'package:flutter/material.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

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

    return Container(
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(cvData!),
                  const SizedBox(height: 24),
                  ...cvData!.sections
                      .where((s) => s.isVisible)
                      .map((section) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _buildSection(section),
                          )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(CVData cv) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cv.name.toUpperCase(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            height: 1.2,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        _buildContactLine(cv),
        if (cv.linkedin?.isNotEmpty == true ||
            cv.portfolio?.isNotEmpty == true) ...[
          const SizedBox(height: 4),
          _buildLinksLine(cv),
        ],
      ],
    );
  }

  Widget _buildContactLine(CVData cv) {
    final List<String> contacts = [];

    if (cv.email?.isNotEmpty == true) contacts.add(cv.email!);
    if (cv.phone?.isNotEmpty == true) contacts.add(cv.phone!);
    if (cv.location?.isNotEmpty == true) contacts.add(cv.location!);

    if (contacts.isEmpty) return const SizedBox.shrink();

    return Text(
      contacts.join(' | '),
      style: const TextStyle(
        fontSize: 11,
        height: 1.5,
        color: Color(0xFF374151),
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildLinksLine(CVData cv) {
    final List<String> links = [];

    if (cv.linkedin?.isNotEmpty == true) links.add('LinkedIn: ${cv.linkedin}');
    if (cv.portfolio?.isNotEmpty == true)
      links.add('Portfolio: ${cv.portfolio}');

    if (links.isEmpty) return const SizedBox.shrink();

    return Text(
      links.join(' | '),
      style: const TextStyle(
        fontSize: 10,
        height: 1.5,
        color: Color(0xFF6B7280),
      ),
    );
  }

  Widget _buildSection(SectionData section) {
    if (section is SummarySection) return _buildSummarySection(section);
    if (section is ExperienceSection) return _buildExperienceSection(section);
    if (section is EducationSection) return _buildEducationSection(section);
    if (section is OrganizationSection)
      return _buildOrganizationSection(section);
    if (section is SkillsSection) return _buildSkillsSection(section);
    if (section is CertificationsSection)
      return _buildCertificationsSection(section);
    if (section is CustomSection) return _buildCustomSection(section);
    return const SizedBox.shrink();
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: Color(0xFF0EA5E9),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 1.5,
          width: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF0EA5E9),
                const Color(0xFF0EA5E9).withValues(alpha: 0.3),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
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
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 11,
            height: 1.6,
            color: Color(0xFF374151),
            letterSpacing: 0.1,
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
        ...section.entries.map((exp) => _buildExperienceEntry(exp)),
      ],
    );
  }

  Widget _buildExperienceEntry(WorkExperience exp) {
    final dateFormat = DateFormat('MMM yyyy');
    final startDate = dateFormat.format(exp.startDate);
    final endDate =
        exp.isCurrentlyWorking ? 'Present' : dateFormat.format(exp.endDate!);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  exp.companyName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '$startDate - $endDate',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF6B7280),
                  height: 1.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            exp.jobTitle,
            style: const TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              height: 1.3,
              color: Color(0xFF374151),
            ),
          ),
          if (exp.location?.isNotEmpty == true) ...[
            const SizedBox(height: 2),
            Text(
              exp.location!,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF9CA3AF),
                height: 1.3,
              ),
            ),
          ],
          const SizedBox(height: 6),
          ...exp.responsibilities
              .split('\n')
              .where((r) => r.trim().isNotEmpty)
              .map((resp) => Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(fontSize: 11, height: 1.5),
                        ),
                        Expanded(
                          child: Text(
                            resp.trim(),
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 11,
                              height: 1.5,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
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
        ...section.entries.map((edu) => _buildEducationEntry(edu)),
      ],
    );
  }

  Widget _buildEducationEntry(Education edu) {
    final endYear =
        edu.isCurrentlyStudying ? 'Present' : edu.endYear?.toString() ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  edu.institution,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${edu.startYear} - $endYear',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF6B7280),
                  height: 1.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            '${edu.degree} in ${edu.major}',
            style: const TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              height: 1.3,
              color: Color(0xFF374151),
            ),
          ),
          if (edu.gpa?.isNotEmpty == true) ...[
            const SizedBox(height: 2),
            Text(
              'GPA: ${edu.gpa}',
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF6B7280),
                height: 1.3,
              ),
            ),
          ],
          if (edu.achievements?.isNotEmpty == true) ...[
            const SizedBox(height: 6),
            ...edu.achievements!
                .split('\n')
                .where((a) => a.trim().isNotEmpty)
                .map((achievement) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ',
                              style: TextStyle(fontSize: 11, height: 1.4)),
                          Expanded(
                            child: Text(
                              achievement.trim(),
                              style: const TextStyle(
                                fontSize: 11,
                                height: 1.4,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
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
        ...section.entries.map((org) => _buildOrganizationEntry(org)),
      ],
    );
  }

  Widget _buildOrganizationEntry(OrganizationExperience org) {
    final dateFormat = DateFormat('MMM yyyy');
    final startDate = dateFormat.format(org.startDate);
    final endDate =
        org.isCurrentlyActive ? 'Present' : dateFormat.format(org.endDate!);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  org.organizationName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '$startDate - $endDate',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF6B7280),
                  height: 1.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            org.role,
            style: const TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              height: 1.3,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 6),
          ...org.description
              .split('\n')
              .where((d) => d.trim().isNotEmpty)
              .map((desc) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(fontSize: 11, height: 1.5)),
                        Expanded(
                          child: Text(
                            desc.trim(),
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontSize: 11,
                              height: 1.5,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
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
        ...section.skillCategories.entries
            .where((e) => e.value.isNotEmpty)
            .map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        color: Color(0xFF374151),
                      ),
                      children: [
                        TextSpan(
                          text: '${entry.key}: ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: entry.value.join(', '),
                        ),
                      ],
                    ),
                  ),
                ))
      ],
    );
  }

  Widget _buildCertificationsSection(CertificationsSection section) {
    if (section.entries.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(section.title),
        ...section.entries.map((cert) => _buildCertificationEntry(cert)),
      ],
    );
  }

  Widget _buildCertificationEntry(Certification cert) {
    final dateFormat = DateFormat('MMM yyyy');
    final issueDate = dateFormat.format(cert.issueDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  cert.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                issueDate,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF6B7280),
                  height: 1.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            cert.issuingOrganization,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF6B7280),
              height: 1.3,
            ),
          ),
          if (cert.credentialId?.isNotEmpty == true) ...[
            const SizedBox(height: 2),
            Text(
              'ID: ${cert.credentialId}',
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF9CA3AF),
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomSection(CustomSection section) {
    if (section.template == CustomSectionTemplate.paragraph) {
      if (section.content.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(section.title),
          Text(
            section.content,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 11,
              height: 1.6,
              color: Color(0xFF374151),
            ),
          ),
        ],
      );
    }

    if (section.template == CustomSectionTemplate.bulletList) {
      final lines = section.content
          .split('\n')
          .where((l) => l.trim().isNotEmpty)
          .toList();
      if (lines.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(section.title),
          ...lines.map((line) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(fontSize: 11, height: 1.5)),
                    Expanded(
                      child: Text(
                        line.trim(),
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      );
    }

    if (section.template == CustomSectionTemplate.skillsLike) {
      if (section.skillCategories.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(section.title),
          ...section.skillCategories.entries.map((category) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.5,
                      color: Color(0xFF374151),
                    ),
                    children: [
                      TextSpan(
                        text: '${category.key}: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: category.value.join(', ')),
                    ],
                  ),
                ),
              )),
        ],
      );
    }

    if (section.entries.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(section.title),
        ...section.entries.map((entry) {
          final dateStr = entry.startDate != null
              ? '${entry.startDate} - ${entry.isPresent ? "Present" : (entry.endDate ?? "")}'
              : '';

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        entry.title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (dateStr.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6B7280),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
                if (entry.subtitle?.isNotEmpty == true) ...[
                  const SizedBox(height: 2),
                  Text(
                    entry.subtitle!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      height: 1.3,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
                if (entry.meta?.isNotEmpty == true) ...[
                  const SizedBox(height: 2),
                  Text(
                    entry.meta!,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF9CA3AF),
                      height: 1.3,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                ...entry.bullets.map((bullet) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ',
                              style: TextStyle(fontSize: 11, height: 1.5)),
                          Expanded(
                            child: Text(
                              bullet,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontSize: 11,
                                height: 1.5,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          );
        }),
      ],
    );
  }
}
