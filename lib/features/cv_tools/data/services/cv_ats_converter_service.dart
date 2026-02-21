import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:resummy_app/core/constants/app_constants.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';

class CvAtsConverterService {
  final Uuid _uuid = const Uuid();

  Future<CVData> convertFromFile(File file, {String? targetLanguage}) async {
    final bytes = await file.readAsBytes();
    final base64Data = base64Encode(bytes);
    final mimeType = _getMimeType(file.path);

    final Map<String, dynamic> mediaPart = {
      'inline_data': {
        'mime_type': mimeType,
        'data': base64Data,
      },
    };

    final requestBody = {
      'contents': [
        {
          'parts': [
            mediaPart,
            {
              'text': _buildPrompt(targetLanguage: targetLanguage),
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': 1.0,
        'topP': 0.95,
        'maxOutputTokens': 65536,
        'responseMimeType': 'application/json',
      },
    };

    final response = await _postWithRetry(
      'https://generativelanguage.googleapis.com/v1alpha/models/gemini-3-flash-preview:generateContent',
      Options(
        headers: {
          'x-goog-api-key': AppConstants.geminiApiKey21,
          'Content-Type': 'application/json',
        },
        receiveTimeout: const Duration(seconds: 300),
        sendTimeout: const Duration(seconds: 120),
        validateStatus: (status) => true,
      ),
      requestBody,
    );

    if (response.statusCode != 200) {
      final errorBody = response.data?.toString() ?? 'no body';
      throw Exception(
        'Gemini API error ${response.statusCode}: $errorBody',
      );
    }

    final rawJson = _extractJsonFromResponse(response.data);
    return parseCvJson(jsonDecode(rawJson) as Map<String, dynamic>);
  }

  Future<Response> _postWithRetry(
    String url,
    Options options,
    Map<String, dynamic> body, {
    int maxRetry = 3,
  }) async {
    for (int i = 0; i < maxRetry; i++) {
      final response = await Dio().post(url, options: options, data: body);
      final statusCode = response.statusCode ?? 0;

      if ((statusCode == 503 || statusCode == 429) && i < maxRetry - 1) {
        final waitSeconds = 2 * (i + 1);
        await Future.delayed(Duration(seconds: waitSeconds));
        continue;
      }

      return response;
    }
    throw Exception('Gemini API: max retries exceeded');
  }

  String _extractJsonFromResponse(dynamic responseData) {
    try {
      final candidates = responseData['candidates'] as List;
      if (candidates.isEmpty) throw Exception('No candidates in response');

      final content = candidates[0]['content'];
      final parts = content['parts'] as List;
      if (parts.isEmpty) throw Exception('No parts in response');

      String? text;
      for (final part in parts) {
        if (part is Map && part.containsKey('text')) {
          final t = part['text'] as String?;
          if (t != null && t.trim().isNotEmpty) {
            text = t;
            break;
          }
        }
      }

      if (text == null || text.trim().isEmpty) {
        throw Exception('No text content in response parts');
      }

      text = text.trim();
      if (text.startsWith('```')) {
        final lines = text.split('\n');
        if (lines.length > 2) {
          text = lines.sublist(1, lines.length - 1).join('\n');
        }
      }

      return text.trim();
    } catch (e) {
      throw Exception('Failed to extract JSON from response: $e');
    }
  }

  CVData parseCvJson(Map<String, dynamic> data,
      {String source = 'ats_converter'}) {
    final now = DateTime.now();
    final List<SectionData> sections = [];
    final rawSections = data['sections'] as List<dynamic>? ?? [];

    for (final rawSection in rawSections) {
      final section = _parseSection(rawSection as Map<String, dynamic>);
      if (section != null) {
        sections.add(section);
      }
    }

    return CVData(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
      template: 'professional',
      source: source,
      header: HeaderSection(
        id: _uuid.v4(),
        name: data['name'] as String? ?? '',
        email: data['email'] as String?,
        phone: data['phone'] as String?,
        linkedin: data['linkedin'] as String?,
        portfolio: data['portfolio'] as String?,
        github: data['github'] as String?,
        location: data['location'] as String?,
      ),
      sections: sections,
    );
  }

  SectionData? _parseSection(Map<String, dynamic> raw) {
    final type = raw['type'] as String? ?? '';
    final title = raw['title'] as String? ?? '';
    final isVisible = raw['isVisible'] as bool? ?? true;
    final id = _uuid.v4();

    switch (type) {
      case 'summary':
        return SummarySection(
          id: id,
          title: title,
          content: raw['content'] as String? ?? '',
          isVisible: isVisible,
        );

      case 'experience':
        final entries = (raw['entries'] as List<dynamic>? ?? [])
            .map((e) => _parseWorkExperience(e as Map<String, dynamic>))
            .toList();
        return ExperienceSection(
          id: id,
          title: title,
          entries: entries,
          isVisible: isVisible,
        );

      case 'education':
        final entries = (raw['entries'] as List<dynamic>? ?? [])
            .map((e) => _parseEducation(e as Map<String, dynamic>))
            .toList();
        return EducationSection(
          id: id,
          title: title,
          entries: entries,
          isVisible: isVisible,
        );

      case 'organization':
        final entries = (raw['entries'] as List<dynamic>? ?? [])
            .map((e) => _parseOrganization(e as Map<String, dynamic>))
            .toList();
        return OrganizationSection(
          id: id,
          title: title,
          entries: entries,
          isVisible: isVisible,
        );

      case 'skills':
        final rawCategories =
            raw['skillCategories'] as Map<String, dynamic>? ?? {};
        final categories = rawCategories.map(
          (k, v) => MapEntry(k, List<String>.from(v as List? ?? [])),
        );
        return SkillsSection(
          id: id,
          title: title,
          skillCategories: categories,
          isVisible: isVisible,
        );

      case 'certifications':
        final entries = (raw['entries'] as List<dynamic>? ?? [])
            .map((e) => _parseCertification(e as Map<String, dynamic>))
            .toList();
        return CertificationsSection(
          id: id,
          title: title,
          entries: entries,
          isVisible: isVisible,
        );

      case 'custom':
        return _parseCustomSection(id, title, isVisible, raw);

      default:
        return null;
    }
  }

  WorkExperience _parseWorkExperience(Map<String, dynamic> raw) {
    final startStr = raw['startDate'] as String? ?? 'Jan 2020';
    final endStr = raw['endDate'] as String?;
    final isPresent = raw['isPresent'] as bool? ?? false;

    return WorkExperience(
      id: _uuid.v4(),
      companyName: raw['companyName'] as String? ?? '',
      jobTitle: raw['jobTitle'] as String? ?? '',
      location: raw['location'] as String?,
      employmentType: raw['employmentType'] as String? ?? 'Full-time',
      startDate: _parseDate(startStr),
      endDate: isPresent ? null : _parseDate(endStr ?? startStr),
      isCurrentlyWorking: isPresent,
      responsibilities: (raw['bullets'] as List<dynamic>? ?? []).join('\n'),
    );
  }

  Education _parseEducation(Map<String, dynamic> raw) {
    return Education(
      id: _uuid.v4(),
      institution: raw['institution'] as String? ?? '',
      degree: raw['degree'] as String? ?? '',
      major: raw['major'] as String? ?? '',
      startYear: raw['startYear'] as int? ?? 2020,
      endYear: raw['isPresent'] == true ? null : raw['endYear'] as int?,
      isCurrentlyStudying: raw['isPresent'] as bool? ?? false,
      gpa: raw['gpa'] as String?,
      achievements: (raw['bullets'] as List<dynamic>? ?? []).join('\n'),
    );
  }

  OrganizationExperience _parseOrganization(Map<String, dynamic> raw) {
    final startStr = raw['startDate'] as String? ?? 'Jan 2020';
    final endStr = raw['endDate'] as String?;
    final isPresent = raw['isPresent'] as bool? ?? false;

    return OrganizationExperience(
      id: _uuid.v4(),
      organizationName: raw['organizationName'] as String? ?? '',
      role: raw['role'] as String? ?? '',
      location: raw['location'] as String?,
      startDate: _parseDate(startStr),
      endDate: isPresent ? null : _parseDate(endStr ?? startStr),
      isCurrentlyActive: isPresent,
      description: (raw['bullets'] as List<dynamic>? ?? []).join('\n'),
    );
  }

  Certification _parseCertification(Map<String, dynamic> raw) {
    return Certification(
      id: _uuid.v4(),
      name: raw['name'] as String? ?? '',
      issuingOrganization: raw['issuingOrganization'] as String? ?? '',
      issueDate: _parseDate(raw['issueDate'] as String? ?? 'Jan 2020'),
      credentialId: raw['credentialId'] as String?,
      credentialUrl: raw['credentialUrl'] as String?,
    );
  }

  CustomSection _parseCustomSection(
    String id,
    String title,
    bool isVisible,
    Map<String, dynamic> raw,
  ) {
    final templateStr = raw['template'] as String? ?? 'bulletList';
    CustomSectionTemplate template;
    try {
      template = CustomSectionTemplate.values.firstWhere(
        (e) => e.name == templateStr,
        orElse: () => CustomSectionTemplate.bulletList,
      );
    } catch (_) {
      template = CustomSectionTemplate.bulletList;
    }

    if (template == CustomSectionTemplate.skillsLike) {
      final rawCats = raw['skillCategories'] as Map<String, dynamic>? ?? {};
      final cats = rawCats.map(
        (k, v) => MapEntry(k, List<String>.from(v as List? ?? [])),
      );
      return CustomSection(
        id: id,
        title: title,
        isVisible: isVisible,
        template: template,
        skillCategories: cats,
        titleLabel: raw['titleLabel'] as String? ?? 'Title',
        subtitleLabel: raw['subtitleLabel'] as String? ?? 'Subtitle',
        metaLabel: raw['metaLabel'] as String? ?? 'Details',
      );
    }

    if (template == CustomSectionTemplate.experienceLike ||
        template == CustomSectionTemplate.educationLike) {
      final entries = (raw['entries'] as List<dynamic>? ?? []).map((e) {
        final entry = e as Map<String, dynamic>;
        return CustomEntry(
          id: _uuid.v4(),
          title: entry['title'] as String? ?? '',
          subtitle: entry['subtitle'] as String?,
          meta: entry['meta'] as String?,
          startDate: entry['startDate'] as String?,
          endDate:
              entry['isPresent'] == true ? null : entry['endDate'] as String?,
          isPresent: entry['isPresent'] as bool? ?? false,
          bullets: List<String>.from(entry['bullets'] as List? ?? []),
        );
      }).toList();

      return CustomSection(
        id: id,
        title: title,
        isVisible: isVisible,
        template: template,
        entries: entries,
        titleLabel: raw['titleLabel'] as String? ?? 'Title',
        subtitleLabel: raw['subtitleLabel'] as String? ?? 'Subtitle',
        metaLabel: raw['metaLabel'] as String? ?? 'Details',
      );
    }

    return CustomSection(
      id: id,
      title: title,
      isVisible: isVisible,
      template: template,
      content: raw['content'] as String? ?? '',
    );
  }

  DateTime _parseDate(String dateStr) {
    try {
      final months = {
        'jan': 1,
        'feb': 2,
        'mar': 3,
        'apr': 4,
        'may': 5,
        'jun': 6,
        'jul': 7,
        'aug': 8,
        'sep': 9,
        'oct': 10,
        'nov': 11,
        'dec': 12,
        'mei': 5,
        'agu': 8,
        'okt': 10,
        'des': 12,
      };
      final parts = dateStr.trim().split(' ');
      if (parts.length >= 2) {
        final month = months[parts[0].toLowerCase()] ?? 1;
        final year = int.tryParse(parts[1]) ?? DateTime.now().year;
        return DateTime(year, month);
      }
      final year = int.tryParse(dateStr.trim()) ?? DateTime.now().year;
      return DateTime(year);
    } catch (_) {
      return DateTime.now();
    }
  }

  String _getMimeType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.pdf')) return 'application/pdf';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  String _buildPrompt({String? targetLanguage}) => '''
You are an expert CV/Resume parser and ATS specialist.
${targetLanguage != null ? 'CRITICAL: You MUST translate all extracted content into $targetLanguage. The output JSON values must be in $targetLanguage.' : ''}

Extract ALL information from this CV and return ONLY valid JSON matching this exact structure.
No explanation, no markdown, no backticks — pure JSON only.
IMPORTANT: Ensure all strings are properly escaped. DO NOT include literal newlines within string values; use "\\n" instead.

Rules:
- Dates format: "MMM yyyy" e.g. "Jan 2022", "Aug 2024"
- If date says "Present/Sekarang/Now/Current" → isPresent: true, endDate: null
- Extract bullet points as separate array items, strip bullet characters
- Group skills by category if possible
- Preserve the EXACT order of sections as they appear in the CV
- For mixed sections (awards + skills + competition together) → use custom skillsLike
- For experience-style custom sections → use custom experienceLike
- For education-style custom sections → use custom educationLike

Section template selection rules:
- Work Experience / Pengalaman Kerja → type: "experience"
- Education / Pendidikan → type: "education"
- Organization / Organisasi (built-in) → type: "organization"
- Skills / Kemampuan → type: "skills"
- Certifications / Sertifikasi (built-in) → type: "certifications"
- Professional Summary / Ringkasan → type: "summary"
- Projects / Proyek (personal, academic, freelance) → type: "custom", template: "projectsLike"
- Volunteer / Community Organization / Club with roles & dates → type: "custom", template: "organizationLike"
- Extra Certifications / Awards with issuer & date (not fitting built-in certifications) → type: "custom", template: "certificationsLike"
- Mixed awards + skills + competitions in bullet format → type: "custom", template: "skillsLike"
- Volunteer / Projects / Awards with dates → type: "custom", template: "experienceLike"
- Courses / Training with dates → type: "custom", template: "educationLike"
- Simple item list → type: "custom", template: "bulletList"
- Free text → type: "custom", template: "paragraph"

Return this JSON structure:
{
  "name": "string",
  "email": "string|null",
  "phone": "string|null",
  "linkedin": "string|null",
  "portfolio": "string|null",
  "github": "string|null",
  "location": "string|null",
  "sections": [
    {
      "type": "summary",
      "title": "Professional Summary",
      "isVisible": true,
      "content": "string"
    },
    {
      "type": "experience",
      "title": "Work Experience",
      "isVisible": true,
      "entries": [
        {
          "companyName": "string",
          "jobTitle": "string",
          "location": "string|null",
          "startDate": "MMM yyyy",
          "endDate": "MMM yyyy|null",
          "isPresent": false,
          "description": "string|null",
          "bullets": ["bullet 1", "bullet 2"]
        }
      ]
    },
    {
      "type": "education",
      "title": "Education",
      "isVisible": true,
      "entries": [
        {
          "institution": "string",
          "degree": "string",
          "major": "string",
          "startYear": 2020,
          "endYear": 2024,
          "isPresent": false,
          "gpa": "string|null",
          "bullets": ["achievement 1"]
        }
      ]
    },
    {
      "type": "organization",
      "title": "Organization",
      "isVisible": true,
      "entries": [
        {
          "organizationName": "string",
          "role": "string",
          "location": "string|null",
          "startDate": "MMM yyyy",
          "endDate": "MMM yyyy|null",
          "isPresent": false,
          "bullets": ["description 1"]
        }
      ]
    },
    {
      "type": "skills",
      "title": "Skills",
      "isVisible": true,
      "skillCategories": {
        "Programming Languages": ["Python", "Dart"],
        "Frameworks": ["Flutter", "FastAPI"]
      }
    },
    {
      "type": "certifications",
      "title": "Certifications",
      "isVisible": true,
      "entries": [
        {
          "name": "string",
          "issuingOrganization": "string",
          "issueDate": "MMM yyyy",
          "credentialId": "string|null",
          "credentialUrl": "string|null"
        }
      ]
    },
    {
      "type": "custom",
      "template": "organizationLike",
      "title": "Community Involvement",
      "isVisible": true,
      "titleLabel": "Organization",
      "subtitleLabel": "Role",
      "metaLabel": "Location",
      "entries": [
        {
          "title": "string (organization name)",
          "subtitle": "string|null (role)",
          "meta": "string|null (location)",
          "startDate": "MMM yyyy|null",
          "endDate": "MMM yyyy|null",
          "isPresent": false,
          "bullets": ["description"]
        }
      ]
    },
    {
      "type": "custom",
      "template": "certificationsLike",
      "title": "Achievements & Awards",
      "isVisible": true,
      "titleLabel": "Certificate/Award",
      "subtitleLabel": "Issuing Organization",
      "metaLabel": "Credential ID",
      "entries": [
        {
          "title": "string (cert or award name)",
          "subtitle": "string|null (issuing org)",
          "startDate": "MMM yyyy|null (issue date)",
          "endDate": null,
          "isPresent": false,
          "meta": "string|null (credential ID)",
          "bullets": []
        }
      ]
    },
    {
      "type": "custom",
      "template": "projectsLike",
      "title": "Projects",
      "isVisible": true,
      "titleLabel": "Project Name",
      "subtitleLabel": "Tech Stack",
      "metaLabel": "Project Link",
      "entries": [
        {
          "title": "string (project name)",
          "subtitle": "string|null (tech stack / role)",
          "meta": "string|null (project link)",
          "startDate": "MMM yyyy|null",
          "endDate": "MMM yyyy|null",
          "isPresent": false,
          "bullets": ["description bullet"]
        }
      ]
    },
    {
      "type": "custom",
      "template": "skillsLike",
      "title": "Kemampuan & Penghargaan",
      "isVisible": true,
      "titleLabel": "Kategori",
      "subtitleLabel": "Detail",
      "metaLabel": "Tahun",
      "skillCategories": {
        "Kompetisi": ["TOP 5 Marketing Debate 2021"],
        "Kemampuan": ["Negotiating", "Public Speaking"],
        "Penghargaan": ["Foundation Scholarship 2019"]
      }
    },
    {
      "type": "custom",
      "template": "experienceLike",
      "title": "Volunteer Experience",
      "isVisible": true,
      "titleLabel": "Organization",
      "subtitleLabel": "Role",
      "metaLabel": "Location",
      "entries": [
        {
          "title": "string",
          "subtitle": "string|null",
          "meta": "string|null",
          "startDate": "MMM yyyy|null",
          "endDate": "MMM yyyy|null",
          "isPresent": false,
          "bullets": ["description"]
        }
      ]
    },
    {
      "type": "custom",
      "template": "bulletList",
      "title": "Interests",
      "isVisible": true,
      "content": "item1\\nitem2\\nitem3"
    },
    {
      "type": "custom",
      "template": "paragraph",
      "title": "About Me",
      "isVisible": true,
      "content": "free text paragraph here"
    }
  ]
}
''';
}
