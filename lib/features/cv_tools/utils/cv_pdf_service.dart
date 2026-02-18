import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';

class CvPdfService {
  static final PdfFont _nameFont = PdfStandardFont(
    PdfFontFamily.helvetica,
    28,
    style: PdfFontStyle.bold,
  );

  static final PdfFont _sectionHeaderFont = PdfStandardFont(
    PdfFontFamily.helvetica,
    14,
    style: PdfFontStyle.bold,
  );

  static final PdfFont _entryTitleFont = PdfStandardFont(
    PdfFontFamily.helvetica,
    12,
    style: PdfFontStyle.bold,
  );

  static final PdfFont _entrySubtitleFont = PdfStandardFont(
    PdfFontFamily.helvetica,
    11,
    style: PdfFontStyle.italic,
  );

  static final PdfFont _bodyFont = PdfStandardFont(
    PdfFontFamily.helvetica,
    11,
  );

  static final PdfFont _smallFont = PdfStandardFont(
    PdfFontFamily.helvetica,
    10,
  );

  static final PdfFont _contactFont = PdfStandardFont(
    PdfFontFamily.helvetica,
    11,
  );

  static final PdfColor _primaryColor = PdfColor(14, 165, 233);
  static final PdfColor _textColor = PdfColor(55, 65, 81);
  static final PdfColor _lightTextColor = PdfColor(107, 114, 128);

  Future<String> generateAndSavePDF(CVData cv) async {
    final bytes = await generatePDFBytes(cv);

    final directory = await getApplicationDocumentsDirectory();
    final sanitizedName =
        cv.name.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '_');
    final fileName = '${sanitizedName}_CV.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);

    return file.path;
  }

  Future<String> saveToDownloads(CVData cv) async {
    final bytes = await generatePDFBytes(cv);

    final sanitizedName =
        cv.name.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '_');
    final fileName = '${sanitizedName}_CV.pdf';

    Directory? directory;

    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final file = File('${directory!.path}/$fileName');
    await file.writeAsBytes(bytes);

    return file.path;
  }

  Future<void> sharePdf(CVData cv) async {
    final bytes = await generatePDFBytes(cv);

    final sanitizedName =
        cv.name.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '_');
    final fileName = '${sanitizedName}_CV.pdf';

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'CV - ${cv.name}',
      text: 'Sharing my CV',
    );
  }

  Future<Uint8List> generatePDFBytes(CVData cv) async {
    try {
      final PdfDocument document = PdfDocument();
      document.pageSettings.margins.all = 48;

      PdfPage currentPage = document.pages.add();
      final ui.Size pageSize = currentPage.getClientSize();
      double y = 0;

      try {
        final headerResult = _drawHeader(currentPage, cv, y, pageSize.width);
        currentPage = headerResult.page;
        y = headerResult.y + 24;
      } catch (e) {
        throw Exception('Error drawing header: $e');
      }

      for (final section in cv.sections.where((s) => s.isVisible)) {
        try {
          if (y + 60 > pageSize.height) {
            currentPage = document.pages.add();
            y = 0;
          }

          if (section is SummarySection && section.content.isNotEmpty) {
            final result = _drawSummarySection(
                document, currentPage, section, y, pageSize);
            currentPage = result.page;
            y = result.y + 20;
          } else if (section is ExperienceSection &&
              section.entries.isNotEmpty) {
            final result = _drawExperienceSection(
                document, currentPage, section, y, pageSize);
            currentPage = result.page;
            y = result.y + 20;
          } else if (section is EducationSection &&
              section.entries.isNotEmpty) {
            final result = _drawEducationSection(
                document, currentPage, section, y, pageSize);
            currentPage = result.page;
            y = result.y + 20;
          } else if (section is OrganizationSection &&
              section.entries.isNotEmpty) {
            final result = _drawOrganizationSection(
                document, currentPage, section, y, pageSize);
            currentPage = result.page;
            y = result.y + 20;
          } else if (section is SkillsSection &&
              section.skillCategories.isNotEmpty) {
            final result =
                _drawSkillsSection(document, currentPage, section, y, pageSize);
            currentPage = result.page;
            y = result.y + 20;
          } else if (section is CertificationsSection &&
              section.entries.isNotEmpty) {
            final result = _drawCertificationsSection(
                document, currentPage, section, y, pageSize);
            currentPage = result.page;
            y = result.y + 20;
          } else if (section is CustomSection && !section.isEmpty) {
            final result =
                _drawCustomSection(document, currentPage, section, y, pageSize);
            currentPage = result.page;
            y = result.y + 20;
          }
        } catch (e) {
          throw Exception(
              'Error drawing section "${section.title}" (${section.type}): $e');
        }
      }

      final List<int> bytes = await document.save();
      document.dispose();

      return Uint8List.fromList(bytes);
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }

  ({PdfPage page, double y}) _drawHeader(
      PdfPage page, CVData cv, double y, double width) {
    page.graphics.drawString(
      cv.name.toUpperCase(),
      _nameFont,
      bounds: ui.Rect.fromLTWH(0, y, width, 30),
      brush: PdfBrushes.black,
    );
    y += 36;

    final contacts = <String>[];
    if (cv.email?.isNotEmpty == true) contacts.add(cv.email!);
    if (cv.phone?.isNotEmpty == true) contacts.add(cv.phone!);
    if (cv.location?.isNotEmpty == true) contacts.add(cv.location!);

    if (contacts.isNotEmpty) {
      page.graphics.drawString(
        contacts.join(' | '),
        _contactFont,
        bounds: ui.Rect.fromLTWH(0, y, width, 14),
        brush: PdfSolidBrush(_textColor),
      );
      y += 16;
    }

    final links = <String>[];
    if (cv.linkedin?.isNotEmpty == true) links.add('LinkedIn: ${cv.linkedin}');
    if (cv.portfolio?.isNotEmpty == true)
      links.add('Portfolio: ${cv.portfolio}');

    if (links.isNotEmpty) {
      page.graphics.drawString(
        links.join(' | '),
        _smallFont,
        bounds: ui.Rect.fromLTWH(0, y, width, 12),
        brush: PdfSolidBrush(_lightTextColor),
      );
      y += 14;
    }

    return (page: page, y: y);
  }

  ({PdfPage page, double y}) _drawSectionHeader(
    PdfDocument document,
    PdfPage page,
    String title,
    double y,
    ui.Size pageSize,
  ) {
    if (y + 40 > pageSize.height) {
      page = document.pages.add();
      y = 0;
    }

    page.graphics.drawString(
      title.toUpperCase(),
      _sectionHeaderFont,
      bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 16),
      brush: PdfSolidBrush(_primaryColor),
    );
    y += 18;

    page.graphics.drawLine(
      PdfPen(_primaryColor, width: 1.5),
      ui.Offset(0, y),
      ui.Offset(50, y),
    );
    y += 12;

    return (page: page, y: y);
  }

  ({PdfPage page, double y}) _drawSummarySection(
    PdfDocument document,
    PdfPage page,
    SummarySection section,
    double y,
    ui.Size pageSize,
  ) {
    final headerResult =
        _drawSectionHeader(document, page, section.title, y, pageSize);
    page = headerResult.page;
    y = headerResult.y;

    final textResult = _drawJustifiedParagraph(
        document, page, section.content, y, pageSize.width);
    return (page: textResult.page, y: textResult.bounds.bottom);
  }

  ({PdfPage page, double y}) _drawExperienceSection(
    PdfDocument document,
    PdfPage page,
    ExperienceSection section,
    double y,
    ui.Size pageSize,
  ) {
    final headerResult =
        _drawSectionHeader(document, page, section.title, y, pageSize);
    page = headerResult.page;
    y = headerResult.y;

    for (final exp in section.entries) {
      if (y + 70 > pageSize.height) {
        page = document.pages.add();
        y = 0;
      }

      final dateFormat = DateFormat('MMM yyyy');
      final startDate = dateFormat.format(exp.startDate);
      final endDate = exp.isCurrentlyWorking
          ? 'Present'
          : (exp.endDate != null ? dateFormat.format(exp.endDate!) : 'Present');

      page.graphics.drawString(
        exp.companyName,
        _entryTitleFont,
        bounds: ui.Rect.fromLTWH(0, y, pageSize.width - 100, 14),
        brush: PdfBrushes.black,
      );

      final dateText = '$startDate - $endDate';
      final dateSize = _smallFont.measureString(dateText);
      page.graphics.drawString(
        dateText,
        _smallFont,
        bounds: ui.Rect.fromLTWH(
            pageSize.width - dateSize.width, y, dateSize.width, 12),
        brush: PdfSolidBrush(_lightTextColor),
      );
      y += 16;

      page.graphics.drawString(
        exp.jobTitle,
        _entrySubtitleFont,
        bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 13),
        brush: PdfSolidBrush(_textColor),
      );
      y += 15;

      if (exp.location?.isNotEmpty == true) {
        page.graphics.drawString(
          exp.location ?? '',
          _smallFont,
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 11),
          brush: PdfSolidBrush(_lightTextColor),
        );
        y += 13;
      }

      y += 4;

      final responsibilities = exp.responsibilities
          .split('\n')
          .where((r) => r.trim().isNotEmpty)
          .toList();
      for (final resp in responsibilities) {
        if (y + 25 > pageSize.height) {
          page = document.pages.add();
          y = 0;
        }

        final bulletResult = _drawJustifiedBullet(
            document, page, resp.trim(), y, pageSize.width);
        page = bulletResult.page;
        y = bulletResult.bounds.bottom + 4;
      }

      y += 10;
    }

    return (page: page, y: y);
  }

  ({PdfPage page, double y}) _drawEducationSection(
    PdfDocument document,
    PdfPage page,
    EducationSection section,
    double y,
    ui.Size pageSize,
  ) {
    final headerResult =
        _drawSectionHeader(document, page, section.title, y, pageSize);
    page = headerResult.page;
    y = headerResult.y;

    for (final edu in section.entries) {
      if (y + 60 > pageSize.height) {
        page = document.pages.add();
        y = 0;
      }

      final endYear =
          edu.isCurrentlyStudying ? 'Present' : edu.endYear?.toString() ?? '';

      page.graphics.drawString(
        edu.institution,
        _entryTitleFont,
        bounds: ui.Rect.fromLTWH(0, y, pageSize.width - 100, 14),
        brush: PdfBrushes.black,
      );

      final yearText = '${edu.startYear} - $endYear';
      final yearSize = _smallFont.measureString(yearText);
      page.graphics.drawString(
        yearText,
        _smallFont,
        bounds: ui.Rect.fromLTWH(
            pageSize.width - yearSize.width, y, yearSize.width, 12),
        brush: PdfSolidBrush(_lightTextColor),
      );
      y += 16;

      page.graphics.drawString(
        '${edu.degree} in ${edu.major}',
        _entrySubtitleFont,
        bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 13),
        brush: PdfSolidBrush(_textColor),
      );
      y += 15;

      if (edu.gpa?.isNotEmpty == true) {
        page.graphics.drawString(
          'GPA: ${edu.gpa}',
          _smallFont,
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 11),
          brush: PdfSolidBrush(_lightTextColor),
        );
        y += 13;
      }

      y += 4;

      if (edu.achievements?.isNotEmpty == true) {
        final achievements = (edu.achievements ?? '')
            .split('\n')
            .where((a) => a.trim().isNotEmpty)
            .toList();
        for (final achievement in achievements) {
          if (y + 20 > pageSize.height) {
            page = document.pages.add();
            y = 0;
          }

          final bulletResult = _drawBulletPoint(
              document, page, achievement.trim(), y, pageSize.width);
          page = bulletResult.page;
          y = bulletResult.bounds.bottom + 3;
        }
      }

      y += 10;
    }

    return (page: page, y: y);
  }

  ({PdfPage page, double y}) _drawOrganizationSection(
    PdfDocument document,
    PdfPage page,
    OrganizationSection section,
    double y,
    ui.Size pageSize,
  ) {
    final headerResult =
        _drawSectionHeader(document, page, section.title, y, pageSize);
    page = headerResult.page;
    y = headerResult.y;

    for (final org in section.entries) {
      if (y + 60 > pageSize.height) {
        page = document.pages.add();
        y = 0;
      }

      final dateFormat = DateFormat('MMM yyyy');
      final startDate = dateFormat.format(org.startDate);
      final endDate = org.isCurrentlyActive
          ? 'Present'
          : (org.endDate != null ? dateFormat.format(org.endDate!) : 'Present');

      page.graphics.drawString(
        org.organizationName,
        _entryTitleFont,
        bounds: ui.Rect.fromLTWH(0, y, pageSize.width - 100, 14),
        brush: PdfBrushes.black,
      );

      final dateText = '$startDate - $endDate';
      final dateSize = _smallFont.measureString(dateText);
      page.graphics.drawString(
        dateText,
        _smallFont,
        bounds: ui.Rect.fromLTWH(
            pageSize.width - dateSize.width, y, dateSize.width, 12),
        brush: PdfSolidBrush(_lightTextColor),
      );
      y += 16;

      page.graphics.drawString(
        org.role,
        _entrySubtitleFont,
        bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 13),
        brush: PdfSolidBrush(_textColor),
      );
      y += 15;

      y += 4;

      final descriptions = org.description
          .split('\n')
          .where((d) => d.trim().isNotEmpty)
          .toList();
      for (final desc in descriptions) {
        if (y + 20 > pageSize.height) {
          page = document.pages.add();
          y = 0;
        }

        final bulletResult = _drawJustifiedBullet(
            document, page, desc.trim(), y, pageSize.width);
        page = bulletResult.page;
        y = bulletResult.bounds.bottom + 4;
      }

      y += 10;
    }

    return (page: page, y: y);
  }

  ({PdfPage page, double y}) _drawSkillsSection(
    PdfDocument document,
    PdfPage page,
    SkillsSection section,
    double y,
    ui.Size pageSize,
  ) {
    final headerResult =
        _drawSectionHeader(document, page, section.title, y, pageSize);
    page = headerResult.page;
    y = headerResult.y;

    for (final entry
        in section.skillCategories.entries.where((e) => e.value.isNotEmpty)) {
      if (y + 20 > pageSize.height) {
        page = document.pages.add();
        y = 0;
      }

      final categoryText = '${entry.key}: ';
      final skillsText = entry.value.join(', ');

      final categorySize = _bodyFont.measureString(categoryText);
      final categoryBoldFont = PdfStandardFont(PdfFontFamily.helvetica, 11,
          style: PdfFontStyle.bold);
      page.graphics.drawString(
        categoryText,
        categoryBoldFont,
        bounds: ui.Rect.fromLTWH(0, y, categorySize.width, 14),
        brush: PdfBrushes.black,
      );

      page.graphics.drawString(
        skillsText,
        _bodyFont,
        bounds: ui.Rect.fromLTWH(
            categorySize.width, y, pageSize.width - categorySize.width, 14),
        brush: PdfSolidBrush(_textColor),
      );

      y += 16;
    }

    return (page: page, y: y);
  }

  ({PdfPage page, double y}) _drawCertificationsSection(
    PdfDocument document,
    PdfPage page,
    CertificationsSection section,
    double y,
    ui.Size pageSize,
  ) {
    final headerResult =
        _drawSectionHeader(document, page, section.title, y, pageSize);
    page = headerResult.page;
    y = headerResult.y;

    for (final cert in section.entries) {
      if (y + 45 > pageSize.height) {
        page = document.pages.add();
        y = 0;
      }

      final dateFormat = DateFormat('MMM yyyy');
      final issueDate = dateFormat.format(cert.issueDate);

      page.graphics.drawString(
        cert.name,
        _entryTitleFont,
        bounds: ui.Rect.fromLTWH(0, y, pageSize.width - 80, 14),
        brush: PdfBrushes.black,
      );

      final dateSize = _smallFont.measureString(issueDate);
      page.graphics.drawString(
        issueDate,
        _smallFont,
        bounds: ui.Rect.fromLTWH(
            pageSize.width - dateSize.width, y, dateSize.width, 12),
        brush: PdfSolidBrush(_lightTextColor),
      );
      y += 15;

      page.graphics.drawString(
        cert.issuingOrganization,
        _smallFont,
        bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 11),
        brush: PdfSolidBrush(_lightTextColor),
      );
      y += 13;

      if (cert.credentialId?.isNotEmpty == true) {
        page.graphics.drawString(
          'ID: ${cert.credentialId}',
          _smallFont,
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 11),
          brush: PdfSolidBrush(_lightTextColor),
        );
        y += 13;
      }

      y += 8;
    }

    return (page: page, y: y);
  }

  ({PdfPage page, double y}) _drawCustomSection(
    PdfDocument document,
    PdfPage page,
    CustomSection section,
    double y,
    ui.Size pageSize,
  ) {
    final headerResult =
        _drawSectionHeader(document, page, section.title, y, pageSize);
    page = headerResult.page;
    y = headerResult.y;

    if (section.template == CustomSectionTemplate.paragraph) {
      final textResult = _drawJustifiedParagraph(
          document, page, section.content, y, pageSize.width);
      return (page: textResult.page, y: textResult.bounds.bottom);
    } else if (section.template == CustomSectionTemplate.bulletList) {
      final lines = section.content
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .toList();
      for (final line in lines) {
        if (y + 20 > pageSize.height) {
          page = document.pages.add();
          y = 0;
        }
        final bulletResult =
            _drawBulletPoint(document, page, line.trim(), y, pageSize.width);
        page = bulletResult.page;
        y = bulletResult.bounds.bottom + 4;
      }
      return (page: page, y: y);
    } else if (section.template == CustomSectionTemplate.skillsLike) {
      final categoryBoldFont = PdfStandardFont(PdfFontFamily.helvetica, 11,
          style: PdfFontStyle.bold);
      for (final category in section.skillCategories.entries) {
        if (y + 20 > pageSize.height) {
          page = document.pages.add();
          y = 0;
        }

        final categoryText = '${category.key}: ';
        final skillsText = category.value.join(', ');

        final categorySize = categoryBoldFont.measureString(categoryText);
        page.graphics.drawString(
          categoryText,
          categoryBoldFont,
          bounds: ui.Rect.fromLTWH(0, y, categorySize.width, 14),
          brush: PdfBrushes.black,
        );

        page.graphics.drawString(
          skillsText,
          _bodyFont,
          bounds: ui.Rect.fromLTWH(
              categorySize.width, y, pageSize.width - categorySize.width, 14),
          brush: PdfSolidBrush(_textColor),
        );

        y += 16;
      }
      return (page: page, y: y);
    } else {
      for (final entry in section.entries) {
        if (y + 60 > pageSize.height) {
          page = document.pages.add();
          y = 0;
        }

        final dateStr = entry.startDate != null
            ? '${entry.startDate} - ${entry.isPresent ? "Present" : (entry.endDate ?? "")}'
            : '';

        final dateSize = _smallFont.measureString(dateStr);
        final titleWidth = pageSize.width - dateSize.width - 20;

        page.graphics.drawString(
          entry.title,
          _entryTitleFont,
          bounds: ui.Rect.fromLTWH(0, y, titleWidth, 14),
          brush: PdfBrushes.black,
        );

        if (dateStr.isNotEmpty) {
          page.graphics.drawString(
            dateStr,
            _smallFont,
            bounds: ui.Rect.fromLTWH(
                pageSize.width - dateSize.width, y, dateSize.width, 12),
            brush: PdfSolidBrush(_lightTextColor),
          );
        }
        y += 16;

        if (entry.subtitle?.isNotEmpty == true) {
          page.graphics.drawString(
            entry.subtitle ?? '',
            _entrySubtitleFont,
            bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 13),
            brush: PdfSolidBrush(_textColor),
          );
          y += 15;
        }

        if (entry.meta?.isNotEmpty == true) {
          page.graphics.drawString(
            entry.meta ?? '',
            _smallFont,
            bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 11),
            brush: PdfSolidBrush(_lightTextColor),
          );
          y += 13;
        }

        y += 4;

        for (final bullet in entry.bullets) {
          if (y + 20 > pageSize.height) {
            page = document.pages.add();
            y = 0;
          }
          final bulletResult =
              _drawJustifiedBullet(document, page, bullet, y, pageSize.width);
          page = bulletResult.page;
          y = bulletResult.bounds.bottom + 4;
        }

        y += 10;
      }
      return (page: page, y: y);
    }
  }

  PdfLayoutResult _drawJustifiedParagraph(
    PdfDocument document,
    PdfPage page,
    String text,
    double y,
    double width,
  ) {
    final element = PdfTextElement(
      text: text,
      font: _bodyFont,
      brush: PdfSolidBrush(_textColor),
    );

    final format = PdfLayoutFormat(
      layoutType: PdfLayoutType.paginate,
    );

    final result = element.draw(
      page: page,
      bounds: ui.Rect.fromLTWH(0, y, width, 0),
      format: format,
    );

    return result!;
  }

  PdfLayoutResult _drawJustifiedBullet(
    PdfDocument document,
    PdfPage page,
    String text,
    double y,
    double width,
  ) {
    final bulletText = '• $text';
    final element = PdfTextElement(
      text: bulletText,
      font: _bodyFont,
      brush: PdfSolidBrush(_textColor),
    );

    final format = PdfLayoutFormat(
      layoutType: PdfLayoutType.paginate,
    );

    final result = element.draw(
      page: page,
      bounds: ui.Rect.fromLTWH(0, y, width, 0),
      format: format,
    );

    return result!;
  }

  PdfLayoutResult _drawBulletPoint(
    PdfDocument document,
    PdfPage page,
    String text,
    double y,
    double width,
  ) {
    final bulletText = '• $text';
    final element = PdfTextElement(
      text: bulletText,
      font: _bodyFont,
      brush: PdfSolidBrush(_textColor),
    );

    final format = PdfLayoutFormat(
      layoutType: PdfLayoutType.paginate,
    );

    final result = element.draw(
      page: page,
      bounds: ui.Rect.fromLTWH(0, y, width, 0),
      format: format,
    );

    return result!;
  }
}
