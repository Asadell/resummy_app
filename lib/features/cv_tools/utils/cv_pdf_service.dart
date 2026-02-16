import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:ui' as ui; 
import 'dart:typed_data';

/// Service for generating ATS-friendly PDF from CV data
class CvPdfService {
  // ATS-friendly fonts and sizes
  static final PdfFont _nameFont = PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold);
  static final PdfFont _sectionHeaderFont = PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);
  static final PdfFont _entryTitleFont = PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold);
  static final PdfFont _bodyFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
  static final PdfFont _smallFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

  Future<String> generateAndSavePDF(CVData cv) async {
    final PdfDocument document = PdfDocument();
    document.pageSettings.margins.all = 40; // ~20mm margins for ATS
    
    PdfPage currentPage = document.pages.add();
    final ui.Size pageSize = currentPage.getClientSize();
    double y = 0;
    
    // Header (Personal Info)
    final headerResult = _drawHeader(currentPage, cv, y, pageSize.width);
    currentPage = headerResult.page;
    y = headerResult.y + 16;
    
    // Render sections in user-defined order
    for (final section in cv.sections.where((s) => s.isVisible)) {
      if (section is SummarySection && section.content.isNotEmpty) {
        final result = _drawSummarySection(document, currentPage, section, y, pageSize);
        currentPage = result.page;
        y = result.y + 12;
      } else if (section is ExperienceSection && section.entries.isNotEmpty) {
        final result = _drawExperienceSection(document, currentPage, section, y, pageSize);
        currentPage = result.page;
        y = result.y + 12;
      } else if (section is EducationSection && section.entries.isNotEmpty) {
        final result = _drawEducationSection(document, currentPage, section, y, pageSize);
        currentPage = result.page;
        y = result.y + 12;
      } else if (section is OrganizationSection && section.entries.isNotEmpty) {
        final result = _drawOrganizationSection(document, currentPage, section, y, pageSize);
        currentPage = result.page;
        y = result.y + 12;
      } else if (section is SkillsSection && section.skillCategories.isNotEmpty) {
        final result = _drawSkillsSection(document, currentPage, section, y, pageSize);
        currentPage = result.page;
        y = result.y + 12;
      } else if (section is CertificationsSection && section.entries.isNotEmpty) {
        final result = _drawCertificationsSection(document, currentPage, section, y, pageSize);
        currentPage = result.page;
        y = result.y + 12;
      } else if (section is CustomSection && section.content.isNotEmpty) {
        final result = _drawCustomSection(document, currentPage, section, y, pageSize);
        currentPage = result.page;
        y = result.y + 12;
      }
    }
    
    // Save document
    final List<int> bytes = await document.save();
    document.dispose();
    
    // Write to file
    final directory = await getApplicationDocumentsDirectory();
    final sanitizedName = cv.name.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '_');
    final fileName = '${sanitizedName}_CV.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    
    return file.path;
  }

  Future<Uint8List> generatePDFBytes(CVData cv) async {
    final PdfDocument document = PdfDocument();
    document.pageSettings.margins.all = 40; // ~20mm margins for ATS
    
    PdfPage currentPage = document.pages.add();
    final ui.Size pageSize = currentPage.getClientSize();
    double y = 0;
    
    // Header (Personal Info)
    final headerResult = _drawHeader(currentPage, cv, y, pageSize.width);
    currentPage = headerResult.page;
    y = headerResult.y + 16;
    
    // Render sections in user-defined order
    for (final section in cv.sections.where((s) => s.isVisible)) {
      if (section is SummarySection && section.content.isNotEmpty) {
        final result = _drawSummarySection(document, currentPage, section, y, pageSize);
        currentPage = result.page;
        y = result.y + 12;
      } else if (section is ExperienceSection && section.entries.isNotEmpty) {
        final result = _drawExperienceSection(document, currentPage, section, y, pageSize);
        currentPage = result.page;
        y = result.y + 12;
      } else if (section is EducationSection && section.entries.isNotEmpty) {
        final result = _drawEducationSection(document, currentPage, section, y, pageSize);
        currentPage = result.page;
        y = result.y + 12;
      } else if (section is OrganizationSection && section.entries.isNotEmpty) {
        final result = _drawOrganizationSection(document, currentPage, section, y, pageSize);
        currentPage = result.page;
        y = result.y + 12;
      } else if (section is SkillsSection && section.skillCategories.isNotEmpty) {
        final result = _drawSkillsSection(document, currentPage, section, y, pageSize);
        currentPage = result.page;
        y = result.y + 12;
      } else if (section is CertificationsSection && section.entries.isNotEmpty) {
        final result = _drawCertificationsSection(document, currentPage, section, y, pageSize);
        currentPage = result.page;
        y = result.y + 12;
      } else if (section is CustomSection && section.content.isNotEmpty) {
        final result = _drawCustomSection(document, currentPage, section, y, pageSize);
        currentPage = result.page;
        y = result.y + 12;
      }
    }
    
    // Save document to memory
    final List<int> bytes = await document.save();
    document.dispose();
    
    return Uint8List.fromList(bytes);
  }

  // Draw header with personal info
  ({PdfPage page, double y}) _drawHeader(PdfPage page, CVData cv, double y, double width) {
    // Name - left-aligned for ATS
    page.graphics.drawString(
      cv.name.toUpperCase(),
      _nameFont,
      bounds: ui.Rect.fromLTWH(0, y, width, 20),
    );
    y += 24;
    
    // Contact info - simple, scannable format
    if (cv.email?.isNotEmpty == true) {
      page.graphics.drawString('Email: ${cv.email}', _bodyFont, bounds: ui.Rect.fromLTWH(0, y, width, 12));
      y += 14;
    }
    if (cv.phone?.isNotEmpty == true) {
      page.graphics.drawString('Phone: ${cv.phone}', _bodyFont, bounds: ui.Rect.fromLTWH(0, y, width, 12));
      y += 14;
    }
    if (cv.location?.isNotEmpty == true) {
      page.graphics.drawString('Location: ${cv.location}', _bodyFont, bounds: ui.Rect.fromLTWH(0, y, width, 12));
      y += 14;
    }
    if (cv.linkedin?.isNotEmpty == true) {
      page.graphics.drawString('LinkedIn: ${cv.linkedin}', _bodyFont, bounds: ui.Rect.fromLTWH(0, y, width, 12));
      y += 14;
    }
    if (cv.portfolio?.isNotEmpty == true) {
      page.graphics.drawString('Portfolio: ${cv.portfolio}', _bodyFont, bounds: ui.Rect.fromLTWH(0, y, width, 12));
      y += 14;
    }
    
    return (page: page, y: y);
  }

  // Draw section header with underline
  ({PdfPage page, double y}) _drawSectionHeader(PdfDocument document, PdfPage page, String title, double y, ui.Size pageSize) {
    if (y + 30 > pageSize.height) {
      page = document.pages.add();
      y = 0;
    }
    
    page.graphics.drawString(
      title.toUpperCase(),
      _sectionHeaderFont,
      bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 15),
    );
    y += 14;
    
    // Underline
    page.graphics.drawLine(
      PdfPen(PdfColor(0, 0, 0)),
      ui.Offset(0, y),
      ui.Offset(pageSize.width, y),
    );
    y += 8;
    
    return (page: page, y: y);
  }

  // Draw summary section
  ({PdfPage page, double y}) _drawSummarySection(PdfDocument document, PdfPage page, SummarySection section, double y, ui.Size pageSize) {
    final headerResult = _drawSectionHeader(document, page, section.title, y, pageSize);
    page = headerResult.page;
    y = headerResult.y;
    
    final textResult = _drawParagraph(document, page, section.content, y, pageSize.width);
    return (page: textResult.page, y: textResult.bounds.bottom);
  }

  // Draw experience section
  ({PdfPage page, double y}) _drawExperienceSection(PdfDocument document, PdfPage page, ExperienceSection section, double y, ui.Size pageSize) {
    final headerResult = _drawSectionHeader(document, page, section.title, y, pageSize);
    page = headerResult.page;
    y = headerResult.y;
    
    for (final exp in section.entries) {
      if (y + 60 > pageSize.height) {
        page = document.pages.add();
        y = 0;
      }
      
      // Job title
      page.graphics.drawString(exp.jobTitle, _entryTitleFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 13));
      y += 15;
      
      // Company & date
      final dateFormat = DateFormat('MMM yyyy');
      final startDate = dateFormat.format(exp.startDate);
      final endDate = exp.isCurrentlyWorking ? 'Present' : dateFormat.format(exp.endDate!);
      final companyLine = '${exp.companyName} | $startDate - $endDate';
      page.graphics.drawString(companyLine, _bodyFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 12));
      y += 14;
      
      // Location
      if (exp.location?.isNotEmpty == true) {
        page.graphics.drawString(exp.location!, _smallFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 11));
        y += 13;
      }
      
      // Responsibilities
      final responsibilities = exp.responsibilities.split('\n').where((r) => r.trim().isNotEmpty).toList();
      for (final resp in responsibilities) {
        if (y + 20 > pageSize.height) {
          page = document.pages.add();
          y = 0;
        }
        
        final bulletResult = _drawBulletPoint(document, page, resp.trim(), y, pageSize.width);
        page = bulletResult.page;
        y = bulletResult.bounds.bottom + 3;
      }
      
      y += 7; // Space between entries
    }
    
    return (page: page, y: y);
  }

  // Draw education section
  ({PdfPage page, double y}) _drawEducationSection(PdfDocument document, PdfPage page, EducationSection section, double y, ui.Size pageSize) {
    final headerResult = _drawSectionHeader(document, page, section.title, y, pageSize);
    page = headerResult.page;
    y = headerResult.y;
    
    for (final edu in section.entries) {
      if (y + 50 > pageSize.height) {
        page = document.pages.add();
        y = 0;
      }
      
      // Degree & major
      page.graphics.drawString('${edu.degree} in ${edu.major}', _entryTitleFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 13));
      y += 15;
      
      // Institution & year
      final endYear = edu.isCurrentlyStudying ? 'Present' : edu.endYear?.toString() ?? '';
      final institutionLine = '${edu.institution} | ${edu.startYear} - $endYear';
      page.graphics.drawString(institutionLine, _bodyFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 12));
      y += 14;
      
      // GPA
      if (edu.gpa?.isNotEmpty == true) {
        page.graphics.drawString('GPA: ${edu.gpa}', _bodyFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 12));
        y += 14;
      }
      
      // Achievements
      if (edu.achievements?.isNotEmpty == true) {
        final achievements = edu.achievements!.split('\n').where((a) => a.trim().isNotEmpty).toList();
        for (final achievement in achievements) {
          if (y + 20 > pageSize.height) {
            page = document.pages.add();
            y = 0;
          }
          
          final bulletResult = _drawBulletPoint(document, page, achievement.trim(), y, pageSize.width);
          page = bulletResult.page;
          y = bulletResult.bounds.bottom + 3;
        }
      }
      
      y += 6; // Space between entries
    }
    
    return (page: page, y: y);
  }

  // Draw organization section
  ({PdfPage page, double y}) _drawOrganizationSection(PdfDocument document, PdfPage page, OrganizationSection section, double y, ui.Size pageSize) {
    final headerResult = _drawSectionHeader(document, page, section.title, y, pageSize);
    page = headerResult.page;
    y = headerResult.y;
    
    for (final org in section.entries) {
      if (y + 50 > pageSize.height) {
        page = document.pages.add();
        y = 0;
      }
      
      // Role
      page.graphics.drawString(org.role, _entryTitleFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 13));
      y += 15;
      
      // Organization & date
      final dateFormat = DateFormat('MMM yyyy');
      final startDate = dateFormat.format(org.startDate);
      final endDate = org.isCurrentlyActive ? 'Present' : dateFormat.format(org.endDate!);
      final orgLine = '${org.organizationName} | $startDate - $endDate';
      page.graphics.drawString(orgLine, _bodyFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 12));
      y += 14;
      
      // Location
      if (org.location?.isNotEmpty == true) {
        page.graphics.drawString(org.location!, _smallFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 11));
        y += 13;
      }
      
      // Description
      final descriptions = org.description.split('\n').where((d) => d.trim().isNotEmpty).toList();
      for (final desc in descriptions) {
        if (y + 20 > pageSize.height) {
          page = document.pages.add();
          y = 0;
        }
        
        final bulletResult = _drawBulletPoint(document, page, desc.trim(), y, pageSize.width);
        page = bulletResult.page;
        y = bulletResult.bounds.bottom + 3;
      }
      
      y += 6; // Space between entries
    }
    
    return (page: page, y: y);
  }

  // Draw skills section
  ({PdfPage page, double y}) _drawSkillsSection(PdfDocument document, PdfPage page, SkillsSection section, double y, ui.Size pageSize) {
    final headerResult = _drawSectionHeader(document, page, section.title, y, pageSize);
    page = headerResult.page;
    y = headerResult.y;
    
    for (final entry in section.skillCategories.entries.where((e) => e.value.isNotEmpty)) {
      if (y + 20 > pageSize.height) {
        page = document.pages.add();
        y = 0;
      }
      
      final skillLine = '${entry.key}: ${entry.value.join(', ')}';
      final textResult = _drawParagraph(document, page, skillLine, y, pageSize.width);
      page = textResult.page;
      y = textResult.bounds.bottom + 4;
    }
    
    return (page: page, y: y);
  }

  // Draw certifications section
  ({PdfPage page, double y}) _drawCertificationsSection(PdfDocument document, PdfPage page, CertificationsSection section, double y, ui.Size pageSize) {
    final headerResult = _drawSectionHeader(document, page, section.title, y, pageSize);
    page = headerResult.page;
    y = headerResult.y;
    
    for (final cert in section.entries) {
      if (y + 40 > pageSize.height) {
        page = document.pages.add();
        y = 0;
      }
      
      // Certification name
      page.graphics.drawString(cert.name, _entryTitleFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 13));
      y += 15;
      
      // Issuing organization & date
      final dateFormat = DateFormat('MMM yyyy');
      final issueDate = dateFormat.format(cert.issueDate);
      final certLine = '${cert.issuingOrganization} | Issued: $issueDate';
      page.graphics.drawString(certLine, _bodyFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 12));
      y += 14;
      
      // Expiration
      if (!cert.doesNotExpire && cert.expirationDate != null) {
        final expiryDate = dateFormat.format(cert.expirationDate!);
        page.graphics.drawString('Expires: $expiryDate', _smallFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 11));
        y += 13;
      } else if (cert.doesNotExpire) {
        page.graphics.drawString('No Expiration', _smallFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 11));
        y += 13;
      }
      
      // Credential ID
      if (cert.credentialId?.isNotEmpty == true) {
        page.graphics.drawString('Credential ID: ${cert.credentialId}', _smallFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 11));
        y += 13;
      }
      
      y += 6; // Space between entries
    }
    
    return (page: page, y: y);
  }

  // Draw custom section
  ({PdfPage page, double y}) _drawCustomSection(PdfDocument document, PdfPage page, CustomSection section, double y, ui.Size pageSize) {
    final headerResult = _drawSectionHeader(document, page, section.title, y, pageSize);
    page = headerResult.page;
    y = headerResult.y;
    
    if (section.template == SectionTemplate.paragraph) {
      final textResult = _drawParagraph(document, page, section.content, y, pageSize.width);
      return (page: textResult.page, y: textResult.bounds.bottom);
    } else {
      // Bullet list
      final lines = section.content.split('\n').where((line) => line.trim().isNotEmpty).toList();
      for (final line in lines) {
        if (y + 20 > pageSize.height) {
          page = document.pages.add();
          y = 0;
        }
        
        final bulletResult = _drawBulletPoint(document, page, line.trim(), y, pageSize.width);
        page = bulletResult.page;
        y = bulletResult.bounds.bottom + 3;
      }
      
      return (page: page, y: y);
    }
  }

  // Helper: Draw paragraph with pagination
  PdfLayoutResult _drawParagraph(PdfDocument document, PdfPage page, String text, double y, double width) {
    final PdfTextElement element = PdfTextElement(text: text, font: _bodyFont);
    final PdfLayoutFormat format = PdfLayoutFormat(layoutType: PdfLayoutType.paginate);
    
    final PdfLayoutResult? result = element.draw(
      page: page,
      bounds: ui.Rect.fromLTWH(0, y, width, 0),
      format: format,
    );
    
    return result!;
  }

  // Helper: Draw bullet point with pagination
  PdfLayoutResult _drawBulletPoint(PdfDocument document, PdfPage page, String text, double y, double width) {
    final bulletText = '• $text';
    final PdfTextElement element = PdfTextElement(text: bulletText, font: _bodyFont);
    final PdfLayoutFormat format = PdfLayoutFormat(layoutType: PdfLayoutType.paginate);
    
    final PdfLayoutResult? result = element.draw(
      page: page,
      bounds: ui.Rect.fromLTWH(12, y, width - 12, 0),
      format: format,
    );
    
    return result!;
  }
}
