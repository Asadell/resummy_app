import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_builder_repository.dart';

class CVBuilderProvider extends ChangeNotifier {
  final CVBuilderRepository _repository;
  final Uuid _uuid = const Uuid();

  CVBuilderProvider(this._repository);

  CVData? _currentCV;
  CVData? get currentCV => _currentCV;

  int _currentStep = 0;
  int get currentStep => _currentStep;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<CVData> _savedCVs = [];
  List<CVData> get savedCVs => _savedCVs;

  void startNewCV({
    String? name,
    String? email,
    String? phone,
    String source = 'builder',
  }) {
    final now = DateTime.now();
    final headerId = _uuid.v4();

    _currentCV = CVData(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
      header: HeaderSection(
        id: headerId,
        name: name ?? '',
        email: email,
        phone: phone,
        location: null,
      ),
      sections: [
        SummarySection(
          id: _uuid.v4(),
          title: 'Professional Summary',
          content: '',
          isVisible: true,
        ),
        ExperienceSection(
          id: _uuid.v4(),
          title: 'Work Experience',
          entries: [],
          isVisible: true,
        ),
        EducationSection(
          id: _uuid.v4(),
          title: 'Education',
          entries: [],
          isVisible: true,
        ),
        OrganizationSection(
          id: _uuid.v4(),
          title: 'Organization Experience',
          entries: [],
          isVisible: true,
        ),
        SkillsSection(
          id: _uuid.v4(),
          title: 'Skills',
          skillCategories: {},
          isVisible: true,
        ),
        CertificationsSection(
          id: _uuid.v4(),
          title: 'Certifications & Licenses',
          entries: [],
          isVisible: true,
        ),
      ],
      source: source,
    );
    _currentStep = 1;
    _errorMessage = null;
    notifyListeners();
  }

  void updateCV(CVData updatedCV) {
    _currentCV = updatedCV;
    notifyListeners();
  }

  void loadCvData(CVData cvData) {
    _currentCV = cvData;
    _currentStep = 1;
    _errorMessage = null;
    notifyListeners();
  }

  void updateHeader({
    String? name,
    String? email,
    String? phone,
    String? linkedin,
    String? portfolio,
    String? location,
  }) {
    if (_currentCV == null) return;

    final updatedHeader = _currentCV!.header.copyWith(
      name: name?.trim(),
      email: email?.trim(),
      phone: phone?.trim(),
      linkedin: linkedin?.trim(),
      portfolio: portfolio?.trim(),
      location: location?.trim(),
    );

    _currentCV = _currentCV!.copyWith(
      header: updatedHeader,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void reorderSections(int oldIndex, int newIndex) {
    if (_currentCV == null) return;

    final sections = List<SectionData>.from(_currentCV!.sections);

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final item = sections.removeAt(oldIndex);
    sections.insert(newIndex, item);

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void toggleSectionVisibility(String sectionId) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section.id == sectionId) {
        if (section is SummarySection) {
          return section.copyWith(isVisible: !section.isVisible);
        } else if (section is ExperienceSection) {
          return section.copyWith(isVisible: !section.isVisible);
        } else if (section is EducationSection) {
          return section.copyWith(isVisible: !section.isVisible);
        } else if (section is OrganizationSection) {
          return section.copyWith(isVisible: !section.isVisible);
        } else if (section is SkillsSection) {
          return section.copyWith(isVisible: !section.isVisible);
        } else if (section is CertificationsSection) {
          return section.copyWith(isVisible: !section.isVisible);
        } else if (section is CustomSection) {
          return section.copyWith(isVisible: !section.isVisible);
        }
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void updateSectionTitle(String sectionId, String newTitle) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section.id == sectionId) {
        if (section is SummarySection) {
          return section.copyWith(title: newTitle);
        } else if (section is ExperienceSection) {
          return section.copyWith(title: newTitle);
        } else if (section is EducationSection) {
          return section.copyWith(title: newTitle);
        } else if (section is OrganizationSection) {
          return section.copyWith(title: newTitle);
        } else if (section is SkillsSection) {
          return section.copyWith(title: newTitle);
        } else if (section is CertificationsSection) {
          return section.copyWith(title: newTitle);
        } else if (section is CustomSection) {
          return section.copyWith(title: newTitle);
        }
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void updateSummary(String content) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is SummarySection) {
        return section.copyWith(content: content);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void addWorkExperience(WorkExperience experience) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is ExperienceSection) {
        final entries = List<WorkExperience>.from(section.entries)
          ..add(experience);
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void updateWorkExperience(int index, WorkExperience experience) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is ExperienceSection) {
        if (index >= section.entries.length) return section;
        final entries = List<WorkExperience>.from(section.entries);
        entries[index] = experience;
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void removeWorkExperience(int index) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is ExperienceSection) {
        if (index >= section.entries.length) return section;
        final entries = List<WorkExperience>.from(section.entries)
          ..removeAt(index);
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void reorderWorkExperience(int oldIndex, int newIndex) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is ExperienceSection) {
        final entries = List<WorkExperience>.from(section.entries);
        if (newIndex > oldIndex) newIndex -= 1;
        final item = entries.removeAt(oldIndex);
        entries.insert(newIndex, item);
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void addEducation(Education education) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is EducationSection) {
        final entries = List<Education>.from(section.entries)..add(education);
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void updateEducation(int index, Education education) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is EducationSection) {
        if (index >= section.entries.length) return section;
        final entries = List<Education>.from(section.entries);
        entries[index] = education;
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void removeEducation(int index) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is EducationSection) {
        if (index >= section.entries.length) return section;
        final entries = List<Education>.from(section.entries)..removeAt(index);
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void reorderEducation(int oldIndex, int newIndex) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is EducationSection) {
        final entries = List<Education>.from(section.entries);
        if (newIndex > oldIndex) newIndex -= 1;
        final item = entries.removeAt(oldIndex);
        entries.insert(newIndex, item);
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void addOrganization(OrganizationExperience org) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is OrganizationSection) {
        final entries = List<OrganizationExperience>.from(section.entries)
          ..add(org);
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void updateOrganization(int index, OrganizationExperience org) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is OrganizationSection) {
        if (index >= section.entries.length) return section;
        final entries = List<OrganizationExperience>.from(section.entries);
        entries[index] = org;
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void removeOrganization(int index) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is OrganizationSection) {
        if (index >= section.entries.length) return section;
        final entries = List<OrganizationExperience>.from(section.entries)
          ..removeAt(index);
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void reorderOrganization(int oldIndex, int newIndex) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is OrganizationSection) {
        final entries = List<OrganizationExperience>.from(section.entries);
        if (newIndex > oldIndex) newIndex -= 1;
        final item = entries.removeAt(oldIndex);
        entries.insert(newIndex, item);
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void addSkillToCategory(String category, String skill) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is SkillsSection) {
        final categories =
            Map<String, List<String>>.from(section.skillCategories);
        categories[category] = List.from(categories[category] ?? [])
          ..add(skill);
        return section.copyWith(skillCategories: categories);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void removeSkillFromCategory(String category, String skill) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is SkillsSection) {
        final categories =
            Map<String, List<String>>.from(section.skillCategories);
        categories[category] = List.from(categories[category] ?? [])
          ..remove(skill);
        return section.copyWith(skillCategories: categories);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void addSkillCategory(String categoryName, List<String> skills) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is SkillsSection) {
        final updatedCategories =
            Map<String, List<String>>.from(section.skillCategories);
        updatedCategories[categoryName] = skills;
        return section.copyWith(skillCategories: updatedCategories);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void updateSkillCategory(
      String oldCategory, String newCategory, List<String> skills) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is SkillsSection) {
        final updatedCategories =
            Map<String, List<String>>.from(section.skillCategories);

        if (oldCategory != newCategory) {
          updatedCategories.remove(oldCategory);
        }

        updatedCategories[newCategory] = skills;
        return section.copyWith(skillCategories: updatedCategories);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void removeSkillCategory(String categoryName) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is SkillsSection) {
        final updatedCategories =
            Map<String, List<String>>.from(section.skillCategories);
        updatedCategories.remove(categoryName);
        return section.copyWith(skillCategories: updatedCategories);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void reorderSkillCategories(int oldIndex, int newIndex) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is SkillsSection) {
        final keys = section.skillCategories.keys.toList();
        if (newIndex > oldIndex) newIndex -= 1;
        final key = keys.removeAt(oldIndex);
        keys.insert(newIndex, key);

        final updatedCategories = <String, List<String>>{};
        for (var k in keys) {
          updatedCategories[k] = section.skillCategories[k]!;
        }
        return section.copyWith(skillCategories: updatedCategories);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void addCertification(Certification cert) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is CertificationsSection) {
        final entries = List<Certification>.from(section.entries)..add(cert);
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void updateCertification(int index, Certification cert) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is CertificationsSection) {
        if (index >= section.entries.length) return section;
        final entries = List<Certification>.from(section.entries);
        entries[index] = cert;
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void removeCertification(int index) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is CertificationsSection) {
        if (index >= section.entries.length) return section;
        final entries = List<Certification>.from(section.entries)
          ..removeAt(index);
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void reorderCertifications(int oldIndex, int newIndex) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is CertificationsSection) {
        final entries = List<Certification>.from(section.entries);
        if (newIndex > oldIndex) newIndex -= 1;
        final item = entries.removeAt(oldIndex);
        entries.insert(newIndex, item);
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void addCustomSection(
    String title, {
    CustomSectionTemplate template = CustomSectionTemplate.bulletList,
  }) {
    if (_currentCV == null) return;

    String titleLabel = 'Title';
    String subtitleLabel = 'Subtitle';
    String metaLabel = 'Detail';

    if (template == CustomSectionTemplate.experienceLike) {
      titleLabel = 'Nama Organisasi / Perusahaan';
      subtitleLabel = 'Peran / Posisi';
      metaLabel = 'Lokasi';
    } else if (template == CustomSectionTemplate.educationLike) {
      titleLabel = 'Institusi';
      subtitleLabel = 'Gelar / Program';
      metaLabel = 'GPA / Info Tambahan';
    } else if (template == CustomSectionTemplate.skillsLike) {
      titleLabel = 'Kategori';
      subtitleLabel = 'Skills';
      metaLabel = 'Info Tambahan';
    }

    final newSection = CustomSection(
      id: _uuid.v4(),
      title: title,
      template: template,
      entries: const [],
      content: '',
      skillCategories: const {},
      titleLabel: titleLabel,
      subtitleLabel: subtitleLabel,
      metaLabel: metaLabel,
    );

    final List<SectionData> sections =
        List<SectionData>.from(_currentCV!.sections)..add(newSection);
    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void updateCustomSectionContent({
    required String sectionId,
    required String content,
  }) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section.id == sectionId && section is CustomSection) {
        return section.copyWith(content: content);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void addCustomEntry({
    required String sectionId,
    required CustomEntry entry,
  }) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section.id == sectionId && section is CustomSection) {
        final entries = List<CustomEntry>.from(section.entries)..add(entry);
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void updateCustomEntry({
    required String sectionId,
    required int entryIndex,
    required CustomEntry entry,
  }) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section.id == sectionId && section is CustomSection) {
        if (entryIndex >= section.entries.length) return section;
        final entries = List<CustomEntry>.from(section.entries);
        entries[entryIndex] = entry;
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void removeCustomEntry({
    required String sectionId,
    required int entryIndex,
  }) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section.id == sectionId && section is CustomSection) {
        if (entryIndex >= section.entries.length) return section;
        final entries = List<CustomEntry>.from(section.entries)
          ..removeAt(entryIndex);
        return section.copyWith(entries: entries);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void addCustomSkillCategory({
    required String sectionId,
    required String categoryName,
    required List<String> skills,
  }) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section.id == sectionId && section is CustomSection) {
        final categories =
            Map<String, List<String>>.from(section.skillCategories);
        categories[categoryName] = skills;
        return section.copyWith(skillCategories: categories);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void updateCustomSkillCategory({
    required String sectionId,
    required String oldName,
    required String newName,
    required List<String> skills,
  }) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section.id == sectionId && section is CustomSection) {
        final categories =
            Map<String, List<String>>.from(section.skillCategories);
        categories.remove(oldName);
        categories[newName] = skills;
        return section.copyWith(skillCategories: categories);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void removeCustomSkillCategory({
    required String sectionId,
    required String categoryName,
  }) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section.id == sectionId && section is CustomSection) {
        final categories =
            Map<String, List<String>>.from(section.skillCategories);
        categories.remove(categoryName);
        return section.copyWith(skillCategories: categories);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void updateCustomSection(String sectionId, String content) {
    updateCustomSectionContent(sectionId: sectionId, content: content);
  }

  void deleteCustomSection(String sectionId) {
    if (_currentCV == null) return;

    final List<SectionData> sections = _currentCV!.sections
        .where((section) => section.id != sectionId)
        .toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void updatePersonalInfo({
    String? name,
    String? email,
    String? phone,
    String? linkedin,
    String? portfolio,
    String? location,
  }) {
    updateHeader(
      name: name,
      email: email,
      phone: phone,
      linkedin: linkedin,
      portfolio: portfolio,
      location: location,
    );
  }

  void addSkill(String skill) {
    addSkillToCategory('Technical', skill);
  }

  void removeSkill(String skill) {
    removeSkillFromCategory('Technical', skill);
  }

  void updateProfessionalSummary(String? summary) {
    if (summary != null) {
      updateSummary(summary);
    }
  }

  void updateSkills({List<String>? technicalSkills, List<String>? softSkills}) {
    if (_currentCV == null) return;

    final sections = _currentCV!.sections.map((section) {
      if (section is SkillsSection) {
        final categories =
            Map<String, List<String>>.from(section.skillCategories);
        if (technicalSkills != null) {
          categories['Technical'] = technicalSkills;
        }
        if (softSkills != null) {
          categories['Soft Skills'] = softSkills;
        }
        return section.copyWith(skillCategories: categories);
      }
      return section;
    }).toList();

    _currentCV = _currentCV!.copyWith(sections: sections);
    notifyListeners();
  }

  void updateAdditionalSections(Map<String, dynamic> sections) {}

  void nextStep() {
    if (_currentStep < 7) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 1) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 7) {
      _currentStep = step;
      notifyListeners();
    }
  }

  Future<bool> saveCurrentCV() async {
    if (_currentCV == null || !_currentCV!.isValid) {
      _errorMessage = 'Name is required to save CV';
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedCV = _currentCV!.copyWith(updatedAt: DateTime.now());
      await _repository.saveCV(updatedCV);
      _currentCV = updatedCV;
      await loadAllCVs();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to save CV: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCV(String cvId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cv = await _repository.getCVById(cvId);
      if (cv != null) {
        _currentCV = cv;
        _currentStep = 1;
      } else {
        _errorMessage = 'CV not found';
      }
    } catch (e) {
      _errorMessage = 'Failed to load CV: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAllCVs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _savedCVs = await _repository.getAllCVs();
      _savedCVs.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      _errorMessage = 'Failed to load CVs: $e';
      _savedCVs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCV(String cvId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteCV(cvId);
      await loadAllCVs();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete CV: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearCurrentCV() {
    _currentCV = null;
    _currentStep = 0;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
