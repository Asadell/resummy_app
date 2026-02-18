import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';

class DynamicCvSteps {
  static int getTotalSteps(CVData? cv) {
    if (cv == null) return 3;

    return 1 + cv.sections.length + 1;
  }

  static int getStepForSection(BuildContext context, String sectionType) {
    final provider = context.read<CVBuilderProvider>();
    final cv = provider.currentCV;
    if (cv == null) return 1;

    final sectionIndex = cv.sections.indexWhere((section) {
      return section.type
          .toString()
          .toLowerCase()
          .contains(sectionType.toLowerCase());
    });

    if (sectionIndex == -1) return 1;

    return sectionIndex + 2;
  }

  static int getStepForSectionIndex(int sectionIndex, CVData cv) {
    return sectionIndex + 2;
  }

  static int getSectionIndexForStep(int step, CVData cv) {
    if (step == 1) return -1;

    final totalSteps = getTotalSteps(cv);
    if (step == totalSteps) return -2;

    return step - 2;
  }

  static String getStepTitle(int step, CVData? cv) {
    if (cv == null) return 'CV Builder';

    if (step == 1) return 'Personal Information';
    if (step == getTotalSteps(cv)) return 'Manage Sections';

    final sectionIndex = step - 2;
    if (sectionIndex >= 0 && sectionIndex < cv.sections.length) {
      return cv.sections[sectionIndex].title;
    }

    return 'CV Builder';
  }

  static void navigateToNextStep(BuildContext context, int currentStep) {
    final provider = context.read<CVBuilderProvider>();
    final cv = provider.currentCV;
    if (cv == null) return;

    final totalSteps = getTotalSteps(cv);
    final nextStep = currentStep + 1;

    if (nextStep > totalSteps) {
      context.router.push(const CvBuilderPreviewRoute());
      return;
    }

    if (currentStep == 1 && cv.sections.isNotEmpty) {
      _navigateToSection(context, cv.sections.first);
      return;
    }

    if (nextStep == totalSteps) {
      context.router.push(const CvBuilderStep8Route());
      return;
    }

    final sectionIndex = nextStep - 2;
    if (sectionIndex >= 0 && sectionIndex < cv.sections.length) {
      _navigateToSection(context, cv.sections[sectionIndex]);
    }
  }

  static void navigateToPreviousStep(BuildContext context, int currentStep) {
    final provider = context.read<CVBuilderProvider>();
    final cv = provider.currentCV;
    if (cv == null) return;

    final prevStep = currentStep - 1;

    if (prevStep < 1) {
      context.router.maybePop();
      return;
    }

    if (prevStep == 1) {
      context.router.push(const CvBuilderStep1Route());
      return;
    }

    final totalSteps = getTotalSteps(cv);

    if (currentStep == totalSteps && prevStep < totalSteps) {
      final lastSectionIndex = cv.sections.length - 1;
      if (lastSectionIndex >= 0) {
        _navigateToSection(context, cv.sections[lastSectionIndex]);
      }
      return;
    }

    final sectionIndex = prevStep - 2;
    if (sectionIndex >= 0 && sectionIndex < cv.sections.length) {
      _navigateToSection(context, cv.sections[sectionIndex]);
    }
  }

  static void _navigateToSection(BuildContext context, SectionData section) {
    if (section is CustomSection) {
      context.router
          .push(CvBuilderCustomSectionStepRoute(sectionId: section.id));
      return;
    }

    switch (section.type) {
      case SectionType.summary:
        context.router.push(const CvBuilderStep2Route());
        break;
      case SectionType.experience:
        context.router.push(const CvBuilderStep3Route());
        break;
      case SectionType.education:
        context.router.push(const CvBuilderStep4Route());
        break;
      case SectionType.organization:
        context.router.push(const CvBuilderStep5Route());
        break;
      case SectionType.skills:
        context.router.push(const CvBuilderStep6Route());
        break;
      case SectionType.certifications:
        context.router.push(const CvBuilderStep7Route());
        break;
      case SectionType.header:
        context.router.push(const CvBuilderStep1Route());
        break;
      case SectionType.custom:
        break;
    }
  }
}
