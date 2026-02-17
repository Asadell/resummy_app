import 'package:equatable/equatable.dart';

/// Section types available
enum SectionType {
  header,           // Always first, not reorderable
  summary,          // Professional summary
  experience,       // Work experience
  education,        // Education
  organization,     // Organization experience
  skills,           // Technical & soft skills
  certifications,   // Certifications
  custom,           // User-defined custom section
}

/// Template types for sections
/// Template types for sections
enum CustomSectionTemplate {
  experienceLike, // Mirip Work Experience / Organization — ada title, subtitle, date, bullets
  educationLike,  // Mirip Education — ada institution, degree, date, bullets
  skillsLike,     // Mirip Skills — Category: item1, item2, item3
  bulletList,     // Simple bullet list — hanya bullet points
  paragraph,      // Paragraph — satu paragraf panjang
}

// Backward compatibility alias
typedef SectionTemplate = CustomSectionTemplate;

/// Custom entry for structured custom sections
class CustomEntry extends Equatable {
  final String id;
  final String title; // Bold (Company / Organization / etc)
  final String? subtitle; // Italic (Role / Degree / etc)
  final String? meta; // Meta info (Location, GPA, Issuer, etc)
  final String? startDate;
  final String? endDate;
  final bool isPresent;
  final List<String> bullets;

  const CustomEntry({
    required this.id,
    required this.title,
    this.subtitle,
    this.meta,
    this.startDate,
    this.endDate,
    this.isPresent = false,
    this.bullets = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        meta,
        startDate,
        endDate,
        isPresent,
        bullets,
      ];

  CustomEntry copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? meta,
    String? startDate,
    String? endDate,
    bool? isPresent,
    List<String>? bullets,
  }) {
    return CustomEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      meta: meta ?? this.meta,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isPresent: isPresent ?? this.isPresent,
      bullets: bullets ?? this.bullets,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'meta': meta,
        'startDate': startDate,
        'endDate': endDate,
        'isPresent': isPresent,
        'bullets': bullets,
      };

  factory CustomEntry.fromJson(Map<String, dynamic> json) => CustomEntry(
        id: json['id'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String?,
        meta: json['meta'] as String?,
        startDate: json['startDate'] as String?,
        endDate: json['endDate'] as String?,
        isPresent: json['isPresent'] as bool? ?? false,
        bullets: List<String>.from(json['bullets'] as List? ?? []),
      );
}

/// Custom Section
class CustomSection extends SectionData {
  final CustomSectionTemplate template;
  final List<CustomEntry> entries;
  final String content; // For bulletList and paragraph
  final Map<String, List<String>> skillCategories; // Map<CategoryName, List<SkillItem>>
  
  // Label hints
  final String titleLabel;
  final String subtitleLabel;
  final String metaLabel;

  const CustomSection({
    required super.id,
    required super.title,
    super.isVisible = true,
    this.template = CustomSectionTemplate.bulletList,
    this.entries = const [],
    this.content = '',
    this.skillCategories = const {},
    this.titleLabel = 'Title',
    this.subtitleLabel = 'Subtitle',
    this.metaLabel = 'Details',
  }) : super(type: SectionType.custom);

  bool get isEmpty {
    switch (template) {
      case CustomSectionTemplate.experienceLike:
      case CustomSectionTemplate.educationLike:
        return entries.isEmpty;
      case CustomSectionTemplate.skillsLike:
        return skillCategories.isEmpty ||
            skillCategories.values.every((v) => v.isEmpty);
      case CustomSectionTemplate.bulletList:
      case CustomSectionTemplate.paragraph:
        return content.trim().isEmpty;
    }
  }
  
  CustomSection copyWith({
    String? id,
    String? title,
    bool? isVisible,
    CustomSectionTemplate? template,
    List<CustomEntry>? entries,
    String? content,
    Map<String, List<String>>? skillCategories,
    String? titleLabel,
    String? subtitleLabel,
    String? metaLabel,
  }) {
    return CustomSection(
      id: id ?? this.id,
      title: title ?? this.title,
      isVisible: isVisible ?? this.isVisible,
      template: template ?? this.template,
      entries: entries ?? this.entries,
      content: content ?? this.content,
      skillCategories: skillCategories ?? this.skillCategories,
      titleLabel: titleLabel ?? this.titleLabel,
      subtitleLabel: subtitleLabel ?? this.subtitleLabel,
      metaLabel: metaLabel ?? this.metaLabel,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'custom',
      'title': title,
      'isVisible': isVisible,
      'template': template.name,
      'entries': entries.map((e) => e.toJson()).toList(),
      'content': content,
      'skillCategories': skillCategories.map((k, v) => MapEntry(k, v)),
      'titleLabel': titleLabel,
      'subtitleLabel': subtitleLabel,
      'metaLabel': metaLabel,
    };
  }

  factory CustomSection.fromJson(Map<String, dynamic> json) {
    final templateStr = json['template'] as String? ?? 'bulletList';
    CustomSectionTemplate template;
    try {
      template = CustomSectionTemplate.values.firstWhere(
        (e) => e.name == templateStr,
        orElse: () => CustomSectionTemplate.bulletList,
      );
    } catch (_) {
      template = CustomSectionTemplate.bulletList;
    }

    // Parse skillCategories
    Map<String, List<String>> skillCategories = {};
    final rawCategories = json['skillCategories'];
    if (rawCategories is Map) {
      skillCategories = rawCategories.map(
        (k, v) => MapEntry(
          k.toString(),
          (v as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        ),
      );
    }

    return CustomSection(
      id: json['id'] as String,
      title: json['title'] as String,
      isVisible: json['isVisible'] as bool? ?? true,
      template: template,
      entries: (json['entries'] as List<dynamic>?)
              ?.map((e) => CustomEntry.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
      content: json['content'] as String? ?? '',
      skillCategories: skillCategories,
      titleLabel: json['titleLabel'] as String? ?? 'Title',
      subtitleLabel: json['subtitleLabel'] as String? ?? 'Subtitle',
      metaLabel: json['metaLabel'] as String? ?? 'Details',
    );
  }
}

/// Base class for section data
abstract class SectionData {
  final String id;
  final SectionType type;
  final String title;
  final bool isVisible;
  
  const SectionData({
    required this.id,
    required this.type,
    required this.title,
    this.isVisible = true,
  });

  Map<String, dynamic> toJson();
}

/// Education entry for CV
class Education extends Equatable {
  final String id;
  final String degree; // 'Sarjana (S1)', 'Magister (S2)', etc.
  final String major; // Jurusan
  final String institution;
  final int startYear;
  final int? endYear; // null if still studying
  final bool isCurrentlyStudying;
  final String? gpa;
  final String? achievements;

  const Education({
    required this.id,
    required this.degree,
    required this.major,
    required this.institution,
    required this.startYear,
    this.endYear,
    this.isCurrentlyStudying = false,
    this.gpa,
    this.achievements,
  });

  @override
  List<Object?> get props => [
        id,
        degree,
        major,
        institution,
        startYear,
        endYear,
        isCurrentlyStudying,
        gpa,
        achievements,
      ];

  Education copyWith({
    String? id,
    String? degree,
    String? major,
    String? institution,
    int? startYear,
    int? endYear,
    bool? isCurrentlyStudying,
    String? gpa,
    String? achievements,
  }) {
    return Education(
      id: id ?? this.id,
      degree: degree ?? this.degree,
      major: major ?? this.major,
      institution: institution ?? this.institution,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      isCurrentlyStudying: isCurrentlyStudying ?? this.isCurrentlyStudying,
      gpa: gpa ?? this.gpa,
      achievements: achievements ?? this.achievements,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'degree': degree,
      'major': major,
      'institution': institution,
      'startYear': startYear,
      'endYear': endYear,
      'isCurrentlyStudying': isCurrentlyStudying,
      'gpa': gpa,
      'achievements': achievements,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] as String,
      degree: json['degree'] as String,
      major: json['major'] as String,
      institution: json['institution'] as String,
      startYear: json['startYear'] as int,
      endYear: json['endYear'] as int?,
      isCurrentlyStudying: json['isCurrentlyStudying'] as bool? ?? false,
      gpa: json['gpa'] as String?,
      achievements: json['achievements'] as String?,
    );
  }
}

/// Work experience entry for CV
class WorkExperience extends Equatable {
  final String id;
  final String jobTitle;
  final String companyName;
  final String? location;
  final String employmentType; // 'Full-time', 'Part-time', 'Freelance', 'Internship'
  final DateTime startDate;
  final DateTime? endDate; // null if currently working
  final bool isCurrentlyWorking;
  final String responsibilities; // Bullet points of responsibilities and achievements

  const WorkExperience({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    this.location,
    required this.employmentType,
    required this.startDate,
    this.endDate,
    this.isCurrentlyWorking = false,
    required this.responsibilities,
  });

  @override
  List<Object?> get props => [
        id,
        jobTitle,
        companyName,
        location,
        employmentType,
        startDate,
        endDate,
        isCurrentlyWorking,
        responsibilities,
      ];

  WorkExperience copyWith({
    String? id,
    String? jobTitle,
    String? companyName,
    String? location,
    String? employmentType,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCurrentlyWorking,
    String? responsibilities,
  }) {
    return WorkExperience(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      location: location ?? this.location,
      employmentType: employmentType ?? this.employmentType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrentlyWorking: isCurrentlyWorking ?? this.isCurrentlyWorking,
      responsibilities: responsibilities ?? this.responsibilities,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'location': location,
      'employmentType': employmentType,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCurrentlyWorking': isCurrentlyWorking,
      'responsibilities': responsibilities,
    };
  }

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      id: json['id'] as String,
      jobTitle: json['jobTitle'] as String,
      companyName: json['companyName'] as String,
      location: json['location'] as String?,
      employmentType: json['employmentType'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      isCurrentlyWorking: json['isCurrentlyWorking'] as bool? ?? false,
      responsibilities: json['responsibilities'] as String,
    );
  }
}

/// Certification entry for CV
class Certification extends Equatable {
  final String id;
  final String name;
  final String issuingOrganization;
  final DateTime issueDate;
  final DateTime? expirationDate; // null if doesn't expire
  final bool doesNotExpire;
  final String? credentialId;
  final String? credentialUrl;

  const Certification({
    required this.id,
    required this.name,
    required this.issuingOrganization,
    required this.issueDate,
    this.expirationDate,
    this.doesNotExpire = false,
    this.credentialId,
    this.credentialUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        issuingOrganization,
        issueDate,
        expirationDate,
        doesNotExpire,
        credentialId,
        credentialUrl,
      ];

  Certification copyWith({
    String? id,
    String? name,
    String? issuingOrganization,
    DateTime? issueDate,
    DateTime? expirationDate,
    bool? doesNotExpire,
    String? credentialId,
    String? credentialUrl,
  }) {
    return Certification(
      id: id ?? this.id,
      name: name ?? this.name,
      issuingOrganization: issuingOrganization ?? this.issuingOrganization,
      issueDate: issueDate ?? this.issueDate,
      expirationDate: expirationDate ?? this.expirationDate,
      doesNotExpire: doesNotExpire ?? this.doesNotExpire,
      credentialId: credentialId ?? this.credentialId,
      credentialUrl: credentialUrl ?? this.credentialUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'issuingOrganization': issuingOrganization,
      'issueDate': issueDate.toIso8601String(),
      'expirationDate': expirationDate?.toIso8601String(),
      'doesNotExpire': doesNotExpire,
      'credentialId': credentialId,
      'credentialUrl': credentialUrl,
    };
  }

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['id'] as String,
      name: json['name'] as String,
      issuingOrganization: json['issuingOrganization'] as String,
      issueDate: DateTime.parse(json['issueDate'] as String),
      expirationDate: json['expirationDate'] != null 
          ? DateTime.parse(json['expirationDate'] as String) 
          : null,
      doesNotExpire: json['doesNotExpire'] as bool? ?? false,
      credentialId: json['credentialId'] as String?,
      credentialUrl: json['credentialUrl'] as String?,
    );
  }
}

/// Organization experience entry
class OrganizationExperience extends Equatable {
  final String id;
  final String organizationName;
  final String role;
  final String? location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrentlyActive;
  final String description;

  const OrganizationExperience({
    required this.id,
    required this.organizationName,
    required this.role,
    this.location,
    required this.startDate,
    this.endDate,
    this.isCurrentlyActive = false,
    required this.description,
  });

  @override
  List<Object?> get props => [
        id,
        organizationName,
        role,
        location,
        startDate,
        endDate,
        isCurrentlyActive,
        description,
      ];

  OrganizationExperience copyWith({
    String? organizationName,
    String? role,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCurrentlyActive,
    String? description,
  }) {
    return OrganizationExperience(
      id: id,
      organizationName: organizationName ?? this.organizationName,
      role: role ?? this.role,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrentlyActive: isCurrentlyActive ?? this.isCurrentlyActive,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organizationName': organizationName,
      'role': role,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCurrentlyActive': isCurrentlyActive,
      'description': description,
    };
  }

  factory OrganizationExperience.fromJson(Map<String, dynamic> json) {
    return OrganizationExperience(
      id: json['id'] as String,
      organizationName: json['organizationName'] as String,
      role: json['role'] as String,
      location: json['location'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      isCurrentlyActive: json['isCurrentlyActive'] as bool? ?? false,
      description: json['description'] as String,
    );
  }
}

/// Header Section (Personal Info)
class HeaderSection extends SectionData {
  final String name;
  final String? email;
  final String? phone;
  final String? linkedin;
  final String? portfolio;
  final String? location;
  
  const HeaderSection({
    required super.id,
    required this.name,
    this.email,
    this.phone,
    this.linkedin,
    this.portfolio,
    this.location,
  }) : super(
    type: SectionType.header,
    title: 'Personal Information',
  );
  
  HeaderSection copyWith({
    String? name,
    String? email,
    String? phone,
    String? linkedin,
    String? portfolio,
    String? location,
  }) {
    return HeaderSection(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      linkedin: linkedin ?? this.linkedin,
      portfolio: portfolio ?? this.portfolio,
      location: location ?? this.location,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'header',
      'title': title,
      'isVisible': isVisible,
      'name': name,
      'email': email,
      'phone': phone,
      'linkedin': linkedin,
      'portfolio': portfolio,
      'location': location,
    };
  }

  factory HeaderSection.fromJson(Map<String, dynamic> json) {
    return HeaderSection(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      linkedin: json['linkedin'] as String?,
      portfolio: json['portfolio'] as String?,
      location: json['location'] as String?,
    );
  }
}

/// Summary Section
class SummarySection extends SectionData {
  final String content;
  
  const SummarySection({
    required super.id,
    required super.title,
    required this.content,
    super.isVisible,
  }) : super(type: SectionType.summary);
  
  SummarySection copyWith({
    String? title,
    String? content,
    bool? isVisible,
  }) {
    return SummarySection(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'summary',
      'title': title,
      'isVisible': isVisible,
      'content': content,
    };
  }

  factory SummarySection.fromJson(Map<String, dynamic> json) {
    return SummarySection(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      isVisible: json['isVisible'] as bool? ?? true,
    );
  }
}

/// Experience Section
class ExperienceSection extends SectionData {
  final List<WorkExperience> entries;
  
  const ExperienceSection({
    required super.id,
    required super.title,
    required this.entries,
    super.isVisible,
  }) : super(type: SectionType.experience);
  
  ExperienceSection copyWith({
    String? title,
    List<WorkExperience>? entries,
    bool? isVisible,
  }) {
    return ExperienceSection(
      id: id,
      title: title ?? this.title,
      entries: entries ?? this.entries,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'experience',
      'title': title,
      'isVisible': isVisible,
      'entries': entries.map((e) => e.toJson()).toList(),
    };
  }

  factory ExperienceSection.fromJson(Map<String, dynamic> json) {
    return ExperienceSection(
      id: json['id'] as String,
      title: json['title'] as String,
      entries: (json['entries'] as List<dynamic>?)
              ?.map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isVisible: json['isVisible'] as bool? ?? true,
    );
  }
}

/// Education Section
class EducationSection extends SectionData {
  final List<Education> entries;
  
  const EducationSection({
    required super.id,
    required super.title,
    required this.entries,
    super.isVisible,
  }) : super(type: SectionType.education);
  
  EducationSection copyWith({
    String? title,
    List<Education>? entries,
    bool? isVisible,
  }) {
    return EducationSection(
      id: id,
      title: title ?? this.title,
      entries: entries ?? this.entries,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'education',
      'title': title,
      'isVisible': isVisible,
      'entries': entries.map((e) => e.toJson()).toList(),
    };
  }

  factory EducationSection.fromJson(Map<String, dynamic> json) {
    return EducationSection(
      id: json['id'] as String,
      title: json['title'] as String,
      entries: (json['entries'] as List<dynamic>?)
              ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isVisible: json['isVisible'] as bool? ?? true,
    );
  }
}

/// Organization Section
class OrganizationSection extends SectionData {
  final List<OrganizationExperience> entries;
  
  const OrganizationSection({
    required super.id,
    required super.title,
    required this.entries,
    super.isVisible,
  }) : super(type: SectionType.organization);
  
  OrganizationSection copyWith({
    String? title,
    List<OrganizationExperience>? entries,
    bool? isVisible,
  }) {
    return OrganizationSection(
      id: id,
      title: title ?? this.title,
      entries: entries ?? this.entries,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'organization',
      'title': title,
      'isVisible': isVisible,
      'entries': entries.map((e) => e.toJson()).toList(),
    };
  }

  factory OrganizationSection.fromJson(Map<String, dynamic> json) {
    return OrganizationSection(
      id: json['id'] as String,
      title: json['title'] as String,
      entries: (json['entries'] as List<dynamic>?)
              ?.map((e) => OrganizationExperience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isVisible: json['isVisible'] as bool? ?? true,
    );
  }
}

/// Skills Section
class SkillsSection extends SectionData {
  final Map<String, List<String>> skillCategories; // e.g., {"Programming": ["Node.js", "Python"]}
  
  const SkillsSection({
    required super.id,
    required super.title,
    required this.skillCategories,
    super.isVisible,
  }) : super(type: SectionType.skills);
  
  SkillsSection copyWith({
    String? title,
    Map<String, List<String>>? skillCategories,
    bool? isVisible,
  }) {
    return SkillsSection(
      id: id,
      title: title ?? this.title,
      skillCategories: skillCategories ?? this.skillCategories,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'skills',
      'title': title,
      'isVisible': isVisible,
      'skillCategories': skillCategories,
    };
  }

  factory SkillsSection.fromJson(Map<String, dynamic> json) {
    return SkillsSection(
      id: json['id'] as String,
      title: json['title'] as String,
      skillCategories: (json['skillCategories'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              (value as List<dynamic>).map((e) => e as String).toList(),
            ),
          ) ??
          {},
      isVisible: json['isVisible'] as bool? ?? true,
    );
  }
}

/// Certifications Section
class CertificationsSection extends SectionData {
  final List<Certification> entries;
  
  const CertificationsSection({
    required super.id,
    required super.title,
    required this.entries,
    super.isVisible,
  }) : super(type: SectionType.certifications);
  
  CertificationsSection copyWith({
    String? title,
    List<Certification>? entries,
    bool? isVisible,
  }) {
    return CertificationsSection(
      id: id,
      title: title ?? this.title,
      entries: entries ?? this.entries,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'certifications',
      'title': title,
      'isVisible': isVisible,
      'entries': entries.map((e) => e.toJson()).toList(),
    };
  }

  factory CertificationsSection.fromJson(Map<String, dynamic> json) {
    return CertificationsSection(
      id: json['id'] as String,
      title: json['title'] as String,
      entries: (json['entries'] as List<dynamic>?)
              ?.map((e) => Certification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isVisible: json['isVisible'] as bool? ?? true,
    );
  }
}



/// Main CV Data with ordered sections
class CVData extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Header is always first
  final HeaderSection header;
  
  // Ordered sections (can be reordered)
  final List<SectionData> sections;

  // Template selection
  final String template; // 'classic', 'modern', 'minimalist'

  const CVData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.header,
    required this.sections,
    this.template = 'classic',
  });

  // Validation
  bool get isValid => header.name.isNotEmpty;

  // Helper getters
  String get name => header.name;
  String? get email => header.email;
  String? get phone => header.phone;
  String? get location => header.location;
  String? get linkedin => header.linkedin;
  String? get portfolio => header.portfolio;

  // Get specific sections
  SummarySection? get summarySection => sections
      .whereType<SummarySection>()
      .firstOrNull;
      
  ExperienceSection? get experienceSection => sections
      .whereType<ExperienceSection>()
      .firstOrNull;
      
  EducationSection? get educationSection => sections
      .whereType<EducationSection>()
      .firstOrNull;
      
  OrganizationSection? get organizationSection => sections
      .whereType<OrganizationSection>()
      .firstOrNull;
      
  SkillsSection? get skillsSection => sections
      .whereType<SkillsSection>()
      .firstOrNull;
      
  CertificationsSection? get certificationsSection => sections
      .whereType<CertificationsSection>()
      .firstOrNull;

  // Backwards compatibility getters (untuk migration dari code lama)
  String? get summary => summarySection?.content;
  List<WorkExperience> get workExperience => experienceSection?.entries ?? [];
  List<Education> get education => educationSection?.entries ?? [];
  List<Certification> get certifications => certificationsSection?.entries ?? [];
  List<String> get skills => skillsSection?.skillCategories.values
      .expand((skills) => skills)
      .toList() ?? [];
  List<String> get technicalSkills => skillsSection?.skillCategories['Technical'] ?? [];
  List<String> get softSkills => skillsSection?.skillCategories['Soft Skills'] ?? [];
  Map<String, dynamic> get additionalSections => {};
  String? get professionalSummary => summary;

  @override
  List<Object?> get props => [id, createdAt, updatedAt, header, sections, template];

  CVData copyWith({
    DateTime? updatedAt,
    HeaderSection? header,
    List<SectionData>? sections,
    String? template,
  }) {
    return CVData(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      header: header ?? this.header,
      sections: sections ?? this.sections,
      template: template ?? this.template,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'header': header.toJson(),
      'sections': sections.map((s) => s.toJson()).toList(),
      'template': template,
    };
  }

  factory CVData.fromJson(Map<String, dynamic> json) {
    final sectionsJson = json['sections'] as List<dynamic>?;
    final sections = <SectionData>[];
    
    if (sectionsJson != null) {
      for (final sectionJson in sectionsJson) {
        final type = sectionJson['type'] as String;
        switch (type) {
          case 'summary':
            sections.add(SummarySection.fromJson(sectionJson));
            break;
          case 'experience':
            sections.add(ExperienceSection.fromJson(sectionJson));
            break;
          case 'education':
            sections.add(EducationSection.fromJson(sectionJson));
            break;
          case 'organization':
            sections.add(OrganizationSection.fromJson(sectionJson));
            break;
          case 'skills':
            sections.add(SkillsSection.fromJson(sectionJson));
            break;
          case 'certifications':
            sections.add(CertificationsSection.fromJson(sectionJson));
            break;
          case 'custom':
            sections.add(CustomSection.fromJson(sectionJson));
            break;
        }
      }
    }

    return CVData(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      header: HeaderSection.fromJson(json['header'] as Map<String, dynamic>),
      sections: sections,
      template: json['template'] as String? ?? 'classic',
    );
  }
}

// Extension for List<T>
extension ListExtensions<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
