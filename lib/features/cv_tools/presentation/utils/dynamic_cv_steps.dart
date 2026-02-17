import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';

/// Utility class for managing dynamic CV builder steps based on section order
class DynamicCvSteps {
  /// Calculate total number of steps: Header + Sections + Manager
  static int getTotalSteps(CVData? cv) {
    if (cv == null) return 3; // Minimum: Header + 1 section + Manager
    // 1 (Header) + number of sections + 1 (Manager)
    return 1 + cv.sections.length + 1;
  }

  /// Get the step number for a specific section by its type
  static int getStepForSection(BuildContext context, String sectionType) {
    final provider = context.read<CVBuilderProvider>();
    final cv = provider.currentCV;
    if (cv == null) return 1;

    // Step 1 is always the header
    // Find the section index by type
    final sectionIndex = cv.sections.indexWhere((section) {
      return section.type.toString().toLowerCase().contains(sectionType.toLowerCase());
    });

    if (sectionIndex == -1) return 1;
    
    // Step number = 1 (header) + section position + 1
    return sectionIndex + 2;
  }

  /// Get the step number for a section by its index in the sections list
  static int getStepForSectionIndex(int sectionIndex, CVData cv) {
    // Step 1 is header, sections start at step 2
    return sectionIndex + 2;
  }

  /// Get the section index for a given step number
  /// Returns -1 for header step, -2 for manager step, or section index
  static int getSectionIndexForStep(int step, CVData cv) {
    if (step == 1) return -1; // Header step
    
    final totalSteps = getTotalSteps(cv);
    if (step == totalSteps) return -2; // Manager step
    
    // Section index = step - 2 (accounting for header)
    return step - 2;
  }

  /// Get section title for step
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

  /// Navigate to the next step based on current step number
  static void navigateToNextStep(BuildContext context, int currentStep) {
    final provider = context.read<CVBuilderProvider>();
    final cv = provider.currentCV;
    if (cv == null) return;

    final totalSteps = getTotalSteps(cv);
    final nextStep = currentStep + 1;

    if (nextStep > totalSteps) {
      // Go to preview
      context.router.push(const CvBuilderPreviewRoute());
      return;
    }

    // Step 1 = Header → go to first section
    if (currentStep == 1 && cv.sections.isNotEmpty) {
      _navigateToSection(context, cv.sections.first);
      return;
    }

    // Last step before manager
    if (nextStep == totalSteps) {
      context.router.push(const CvBuilderStep8Route());
      return;
    }

    // Navigate to section based on order
    final sectionIndex = nextStep - 2; // -2 because step 1 is header
    if (sectionIndex >= 0 && sectionIndex < cv.sections.length) {
      _navigateToSection(context, cv.sections[sectionIndex]);
    }
  }

  /// Navigate to the previous step based on current step number
  static void navigateToPreviousStep(BuildContext context, int currentStep) {
    final provider = context.read<CVBuilderProvider>();
    final cv = provider.currentCV;
    if (cv == null) return;

    final prevStep = currentStep - 1;

    if (prevStep < 1) {
      context.router.maybePop();
      return;
    }

    // Go to header
    if (prevStep == 1) {
      context.router.push(const CvBuilderStep1Route());
      return;
    }

    final totalSteps = getTotalSteps(cv);
    
    // Coming from manager (last step)
    if (currentStep == totalSteps && prevStep < totalSteps) {
      // Go to last section
      final lastSectionIndex = cv.sections.length - 1;
      if (lastSectionIndex >= 0) {
        _navigateToSection(context, cv.sections[lastSectionIndex]);
      }
      return;
    }

    // Go to section
    final sectionIndex = prevStep - 2;
    if (sectionIndex >= 0 && sectionIndex < cv.sections.length) {
      _navigateToSection(context, cv.sections[sectionIndex]);
    }
  }


  /// Navigate to a specific section based on its type
  static void _navigateToSection(BuildContext context, SectionData section) {
    if (section is CustomSection) {
      context.router.push(CvBuilderCustomSectionStepRoute(sectionId: section.id));
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
        // Already handled above
        break;
    }
  }
}
