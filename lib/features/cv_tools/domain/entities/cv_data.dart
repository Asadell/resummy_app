import 'package:equatable/equatable.dart';

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

/// Main CV Data entity
class CVData extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Step 1: Personal Info (only name is required)
  final String name;
  final String? email;
  final String? phone;
  final String? linkedin;
  final String? portfolio;
  final String? location;

  // Step 2: Education (optional)
  final List<Education> education;

  // Step 3: Work Experience (optional)
  final List<WorkExperience> workExperience;

  // Step 4: Certifications (optional)
  final List<Certification> certifications;

  // Step 5: Skills (optional)
  final List<String> technicalSkills;
  final List<String> softSkills;

  // Step 6: Professional Summary (optional)
  final String? professionalSummary;

  // Step 7: Additional Sections (optional)
  final Map<String, dynamic> additionalSections;

  // Template selection
  final String template; // 'classic', 'modern', 'minimalist'

  const CVData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    this.email,
    this.phone,
    this.linkedin,
    this.portfolio,
    this.location,
    this.education = const [],
    this.workExperience = const [],
    this.certifications = const [],
    this.technicalSkills = const [],
    this.softSkills = const [],
    this.professionalSummary,
    this.additionalSections = const {},
    this.template = 'classic',
  });

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        name,
        email,
        phone,
        linkedin,
        portfolio,
        location,
        education,
        workExperience,
        certifications,
        technicalSkills,
        softSkills,
        professionalSummary,
        additionalSections,
        template,
      ];

  CVData copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? email,
    String? phone,
    String? linkedin,
    String? portfolio,
    String? location,
    List<Education>? education,
    List<WorkExperience>? workExperience,
    List<Certification>? certifications,
    List<String>? technicalSkills,
    List<String>? softSkills,
    String? professionalSummary,
    Map<String, dynamic>? additionalSections,
    String? template,
  }) {
    return CVData(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      linkedin: linkedin ?? this.linkedin,
      portfolio: portfolio ?? this.portfolio,
      location: location ?? this.location,
      education: education ?? this.education,
      workExperience: workExperience ?? this.workExperience,
      certifications: certifications ?? this.certifications,
      technicalSkills: technicalSkills ?? this.technicalSkills,
      softSkills: softSkills ?? this.softSkills,
      professionalSummary: professionalSummary ?? this.professionalSummary,
      additionalSections: additionalSections ?? this.additionalSections,
      template: template ?? this.template,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'name': name,
      'email': email,
      'phone': phone,
      'linkedin': linkedin,
      'portfolio': portfolio,
      'location': location,
      'education': education.map((e) => e.toJson()).toList(),
      'workExperience': workExperience.map((e) => e.toJson()).toList(),
      'certifications': certifications.map((e) => e.toJson()).toList(),
      'technicalSkills': technicalSkills,
      'softSkills': softSkills,
      'professionalSummary': professionalSummary,
      'additionalSections': additionalSections,
      'template': template,
    };
  }

  factory CVData.fromJson(Map<String, dynamic> json) {
    return CVData(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      linkedin: json['linkedin'] as String?,
      portfolio: json['portfolio'] as String?,
      location: json['location'] as String?,
      education: (json['education'] as List<dynamic>?)
              ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      workExperience: (json['workExperience'] as List<dynamic>?)
              ?.map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => Certification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      technicalSkills: (json['technicalSkills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      softSkills: (json['softSkills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      professionalSummary: json['professionalSummary'] as String?,
      additionalSections: json['additionalSections'] as Map<String, dynamic>? ?? {},
      template: json['template'] as String? ?? 'classic',
    );
  }

  /// Validation: Only name is required
  bool get isValid => name.trim().isNotEmpty;

  // Getters for compatibility with UI
  List<String> get skills => technicalSkills;
  String? get summary => professionalSummary;
}
