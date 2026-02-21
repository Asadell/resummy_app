import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';

class CvPdfService {
  late PdfFont _nameFont;
  late PdfFont _sectionHeaderFont;
  late PdfFont _entryTitleFont;
  late PdfFont _entrySubtitleFont;
  late PdfFont _bodyFont;
  late PdfFont _smallFont;
  late PdfFont _dateFont;
  late PdfFont _contactFont;
  late PdfColor _primaryColor;
  late PdfColor _textColor;
  late PdfColor _lightTextColor;

  void _initFonts() {
    _nameFont = PdfStandardFont(PdfFontFamily.helvetica, 28, style: PdfFontStyle.bold);
    _sectionHeaderFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    _entryTitleFont = PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);
    _entrySubtitleFont = PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.italic);
    _bodyFont = PdfStandardFont(PdfFontFamily.helvetica, 11);
    _smallFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
    _dateFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
    _contactFont = PdfStandardFont(PdfFontFamily.helvetica, 11);
    _primaryColor = PdfColor(0, 0, 0);
    _textColor = PdfColor(0, 0, 0);
    _lightTextColor = PdfColor(50, 50, 50);
  }

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
      _initFonts();
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


  PdfTextElement _createSafeTextElement({
    required String text,
    required PdfFont font,
    PdfBrush? brush,
  }) {
    return PdfTextElement(
          text: text.trim().isEmpty ? ' ' : text,
      font: font,
      brush: brush,
    );
  }

  ({PdfPage page, double y}) _drawHeader(
      PdfPage page, CVData cv, double y, double width) {
    if (cv.name.isNotEmpty) {
      final nameElement = _createSafeTextElement(
          text: cv.name.toUpperCase(),
          font: _nameFont,
          brush: PdfBrushes.black);
      final layoutResult = nameElement.draw(
          page: page,
          bounds: ui.Rect.fromLTWH(0, y, width, 0));
      y = (layoutResult?.bounds.bottom ?? y) + 6;
    }

    final contacts = <String>[];
    if (cv.phone?.isNotEmpty == true) contacts.add(cv.phone!);
    if (cv.email?.isNotEmpty == true) contacts.add(cv.email!);
    if (cv.linkedin?.isNotEmpty == true) contacts.add('${cv.linkedin}');
    if (cv.portfolio?.isNotEmpty == true) contacts.add('${cv.portfolio}');
    if (cv.location?.isNotEmpty == true) contacts.add(cv.location!);

    if (contacts.isNotEmpty) {
      final contactElement = _createSafeTextElement(
          text: contacts.join(' | '),
          font: _contactFont,
          brush: PdfSolidBrush(_textColor));
      final layoutResult = contactElement.draw(
          page: page,
          bounds: ui.Rect.fromLTWH(0, y, width, 0));
      y = (layoutResult?.bounds.bottom ?? y) + 6;
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

    final headerElement = _createSafeTextElement(
        text: title.toUpperCase(),
        font: _sectionHeaderFont,
        brush: PdfSolidBrush(_primaryColor));
    final layoutResult = headerElement.draw(
        page: page,
        bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 0));
    y = (layoutResult?.bounds.bottom ?? y) + 2;

    page.graphics.drawLine(
      PdfPen(_primaryColor, width: 1.5),
      ui.Offset(0, y),
      ui.Offset(pageSize.width, y),
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

      final titleText = exp.companyName;
      final titleSize = _entryTitleFont.measureString(titleText);
      
      final titleElement = _createSafeTextElement(
          text: titleText,
          font: _entryTitleFont,
          brush: PdfSolidBrush(_primaryColor));
      final layoutResultTitle = titleElement.draw(
          page: page,
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width - 150, 0));

      if (exp.location?.isNotEmpty == true) {
        final locationText = ' - ${exp.location}';
        final locationElement = _createSafeTextElement(
            text: locationText,
            font: _bodyFont,
            brush: PdfSolidBrush(_lightTextColor));
        locationElement.draw(
            page: page,
            bounds: ui.Rect.fromLTWH(titleSize.width, y, pageSize.width - titleSize.width - 100, 0));
      }

      final dateText = '$startDate - $endDate';
      final dateElement = _createSafeTextElement(
          text: dateText,
          font: _dateFont,
          brush: PdfSolidBrush(_primaryColor));
      dateElement.stringFormat = PdfStringFormat(alignment: PdfTextAlignment.right);
      dateElement.draw(
          page: page,
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 0));

      y = (layoutResultTitle?.bounds.bottom ?? y) + 2;

      final subtitleElement = _createSafeTextElement(
          text: exp.jobTitle,
          font: _entrySubtitleFont,
          brush: PdfSolidBrush(_textColor));
      final layoutResultSubtitle = subtitleElement.draw(
          page: page,
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 0));
      y = (layoutResultSubtitle?.bounds.bottom ?? y) + 2;

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

      final titleText = edu.institution;

      final titleElement = _createSafeTextElement(
          text: titleText,
          font: _entryTitleFont,
          brush: PdfSolidBrush(_primaryColor));
      final layoutResultTitle = titleElement.draw(
          page: page,
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width - 150, 0));

      final yearText = '${edu.startYear} - $endYear';
      final yearElement = _createSafeTextElement(
          text: yearText,
          font: _dateFont,
          brush: PdfSolidBrush(_primaryColor));
      yearElement.stringFormat = PdfStringFormat(alignment: PdfTextAlignment.right);
      yearElement.draw(
          page: page,
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 0));

      y = (layoutResultTitle?.bounds.bottom ?? y) + 2;

      final subtitleElement = _createSafeTextElement(
          text: '${edu.degree} in ${edu.major}',
          font: _entrySubtitleFont,
          brush: PdfSolidBrush(_textColor));
      final layoutResultSubtitle = subtitleElement.draw(
          page: page,
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 0));
      y = (layoutResultSubtitle?.bounds.bottom ?? y) + 2;

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

      final titleText = org.organizationName;
      final titleSize = _entryTitleFont.measureString(titleText);

      final titleElement = _createSafeTextElement(
          text: titleText,
          font: _entryTitleFont,
          brush: PdfSolidBrush(_primaryColor));
      final layoutResultTitle = titleElement.draw(
          page: page,
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width - 150, 0));

      if (org.location?.isNotEmpty == true) {
        final locationText = ' - ${org.location}';
        final locationElement = _createSafeTextElement(
            text: locationText,
            font: _bodyFont,
            brush: PdfSolidBrush(_lightTextColor));
        locationElement.draw(
            page: page,
            bounds: ui.Rect.fromLTWH(titleSize.width, y, pageSize.width - titleSize.width - 100, 0));
      }

      final dateText = '$startDate - $endDate';
      final dateElement = _createSafeTextElement(
          text: dateText,
          font: _dateFont,
          brush: PdfSolidBrush(_primaryColor));
      dateElement.stringFormat = PdfStringFormat(alignment: PdfTextAlignment.right);
      dateElement.draw(
          page: page,
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 0));

      y = (layoutResultTitle?.bounds.bottom ?? y) + 2;

      final subtitleElement = _createSafeTextElement(
          text: org.role,
          font: _entrySubtitleFont,
          brush: PdfSolidBrush(_textColor));
      final layoutResultSubtitle = subtitleElement.draw(
          page: page,
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 0));
      y = (layoutResultSubtitle?.bounds.bottom ?? y) + 2;

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

    final double categoryColumnWidth = 85;
    final double colonWidth = 10;
    final double spacing = 5;
    final double skillsColumnWidth = pageSize.width - categoryColumnWidth - colonWidth - spacing;

    for (final entry
        in section.skillCategories.entries.where((e) => e.value.isNotEmpty)) {
      if (y + 20 > pageSize.height) {
        page = document.pages.add();
        y = 0;
      }

      // Remove any trailing colons the user might have accidentally typed
      final categoryText = entry.key.replaceAll(RegExp(r':\s*$'), '').trim();
      final skillsText = entry.value.join(', ');

      final categoryBoldFont = PdfStandardFont(PdfFontFamily.helvetica, 11,
          style: PdfFontStyle.bold);

      final categoryElement = _createSafeTextElement(
        text: categoryText,
        font: categoryBoldFont,
        brush: PdfBrushes.black,
      );
      final layoutResultCategory = categoryElement.draw(
        page: page,
        bounds: ui.Rect.fromLTWH(0, y, categoryColumnWidth, 0),
      );

      final colonElement = _createSafeTextElement(
        text: ':',
        font: categoryBoldFont,
        brush: PdfBrushes.black,
      );
      colonElement.draw(
        page: page,
        bounds: ui.Rect.fromLTWH(categoryColumnWidth, y, colonWidth, 0),
      );

      final skillsElement = _createSafeTextElement(
        text: skillsText,
        font: _bodyFont,
        brush: PdfSolidBrush(_textColor),
      );
      final layoutResultSkills = skillsElement.draw(
        page: page,
        bounds: ui.Rect.fromLTWH(
            categoryColumnWidth + colonWidth + spacing, y, skillsColumnWidth, 0),
      );

      final categoryBottom = layoutResultCategory?.bounds.bottom ?? y;
      final skillsBottom = layoutResultSkills?.bounds.bottom ?? y;
      y = [categoryBottom, skillsBottom].reduce((a, b) => a > b ? a : b) + 8;
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

      final titleElement = _createSafeTextElement(
          text: cert.name,
          font: _entryTitleFont,
          brush: PdfBrushes.black);
      final layoutResultTitle = titleElement.draw(
          page: page,
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width - 80, 0));

      final dateSize = _smallFont.measureString(issueDate);
      page.graphics.drawString(
        issueDate,
        _smallFont,
        bounds: ui.Rect.fromLTWH(
            pageSize.width - dateSize.width, y, dateSize.width, 12),
        brush: PdfSolidBrush(_lightTextColor),
      );
      y = (layoutResultTitle?.bounds.bottom ?? y) + 2;

      final subtitleElement = _createSafeTextElement(
          text: cert.issuingOrganization,
          font: _smallFont,
          brush: PdfSolidBrush(_lightTextColor));
      final layoutResultSubtitle = subtitleElement.draw(
          page: page,
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 0));
      y = (layoutResultSubtitle?.bounds.bottom ?? y) + 2;

      if (cert.credentialId?.isNotEmpty == true) {
        final idElement = _createSafeTextElement(
            text: 'ID: ${cert.credentialId}',
            font: _smallFont,
            brush: PdfSolidBrush(_lightTextColor));
        final layoutResultId = idElement.draw(
            page: page,
            bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 0));
        y = (layoutResultId?.bounds.bottom ?? y) + 2;
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
    } else if (section.template == CustomSectionTemplate.certificationsLike) {
      for (final entry in section.entries) {
        if (y + 45 > pageSize.height) {
          page = document.pages.add();
          y = 0;
        }

        final titleElement = _createSafeTextElement(
            text: entry.title,
            font: _entryTitleFont,
            brush: PdfBrushes.black);
        final layoutResultTitle = titleElement.draw(
            page: page,
            bounds: ui.Rect.fromLTWH(0, y, pageSize.width - 80, 0));

        if (entry.startDate?.isNotEmpty == true) {
          final dateSize = _smallFont.measureString(entry.startDate!);
          page.graphics.drawString(
            entry.startDate!,
            _smallFont,
            bounds: ui.Rect.fromLTWH(
                pageSize.width - dateSize.width, y, dateSize.width, 12),
            brush: PdfSolidBrush(_lightTextColor),
          );
        }
        y = (layoutResultTitle?.bounds.bottom ?? y) + 2;

        if (entry.subtitle?.isNotEmpty == true) {
          final subtitleElement = _createSafeTextElement(
              text: entry.subtitle!,
              font: _smallFont,
              brush: PdfSolidBrush(_lightTextColor));
          final layoutResultSubtitle = subtitleElement.draw(
              page: page,
              bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 0));
          y = (layoutResultSubtitle?.bounds.bottom ?? y) + 2;
        }

        if (entry.meta?.isNotEmpty == true) {
          final idElement = _createSafeTextElement(
              text: 'ID: ${entry.meta}',
              font: _smallFont,
              brush: PdfSolidBrush(_lightTextColor));
          final layoutResultId = idElement.draw(
              page: page,
              bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 0));
          y = (layoutResultId?.bounds.bottom ?? y) + 2;
        }

        y += 8;
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

        final titleElement = _createSafeTextElement(
            text: entry.title,
            font: _entryTitleFont,
            brush: PdfBrushes.black);
        final layoutResultTitle = titleElement.draw(
            page: page,
            bounds: ui.Rect.fromLTWH(0, y, titleWidth, 0));

        if (dateStr.isNotEmpty) {
          page.graphics.drawString(
            dateStr,
            _smallFont,
            bounds: ui.Rect.fromLTWH(
                pageSize.width - dateSize.width, y, dateSize.width, 12),
            brush: PdfSolidBrush(_lightTextColor),
          );
        }
        y = (layoutResultTitle?.bounds.bottom ?? y) + 2;

        if (entry.subtitle?.isNotEmpty == true) {
          final subtitleElement = _createSafeTextElement(
              text: entry.subtitle ?? '',
              font: _entrySubtitleFont,
              brush: PdfSolidBrush(_textColor));
          final layoutResultSubtitle = subtitleElement.draw(
              page: page,
              bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 0));
          y = (layoutResultSubtitle?.bounds.bottom ?? y) + 2;
        }

        if (entry.meta?.isNotEmpty == true) {
          final linkElement = _createSafeTextElement(
              text: entry.meta ?? '',
              font: _smallFont,
              brush: PdfSolidBrush(_lightTextColor));
          final layoutResultLink = linkElement.draw(
              page: page,
              bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 0));
          y = (layoutResultLink?.bounds.bottom ?? y) + 2;
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
    final element = _createSafeTextElement(
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

    if (result == null) throw Exception('PDF layout failed: draw() returned null');
    return result;
  }

  PdfLayoutResult _drawJustifiedBullet(
    PdfDocument document,
    PdfPage page,
    String text,
    double y,
    double width,
  ) {
    final bulletElement = _createSafeTextElement(
      text: '•',
      font: _bodyFont,
      brush: PdfSolidBrush(_textColor),
    );
    bulletElement.draw(
      page: page,
      bounds: ui.Rect.fromLTWH(0, y, 15, 0),
    );

    final element = _createSafeTextElement(
      text: text,
      font: _bodyFont,
      brush: PdfSolidBrush(_textColor),
    );

    final format = PdfLayoutFormat(
      layoutType: PdfLayoutType.paginate,
    );

    final result = element.draw(
      page: page,
      bounds: ui.Rect.fromLTWH(15, y, width - 15, 0),
      format: format,
    );

    if (result == null) throw Exception('PDF layout failed: draw() returned null');
    return result;
  }

  PdfLayoutResult _drawBulletPoint(
    PdfDocument document,
    PdfPage page,
    String text,
    double y,
    double width,
  ) {
    final bulletElement = _createSafeTextElement(
      text: '•',
      font: _bodyFont,
      brush: PdfSolidBrush(_textColor),
    );
    bulletElement.draw(
      page: page,
      bounds: ui.Rect.fromLTWH(0, y, 15, 0),
    );

    final element = _createSafeTextElement(
      text: text,
      font: _bodyFont,
      brush: PdfSolidBrush(_textColor),
    );

    final format = PdfLayoutFormat(
      layoutType: PdfLayoutType.paginate,
    );

    final result = element.draw(
      page: page,
      bounds: ui.Rect.fromLTWH(15, y, width - 15, 0),
      format: format,
    );

    if (result == null) throw Exception('PDF layout failed: draw() returned null');
    return result;
  }
}
