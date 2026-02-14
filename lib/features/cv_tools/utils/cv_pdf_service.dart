import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:ui' as ui;

class CvPdfService {
  Future<String> generateAndSavePDF(CVData cv) async {
    final PdfDocument document = PdfDocument();
    document.pageSettings.margins.all = 40;
    
    // Fonts
    final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 24, style: PdfFontStyle.bold);
    final PdfFont subtitleFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    final PdfFont sectionFont = PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
    final PdfFont bodyFont = PdfStandardFont(PdfFontFamily.helvetica, 11);
    final PdfFont boldBodyFont = PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold);
    final PdfFont smallFont = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.italic);
    
    // Initial Page
    PdfPage currentPage = document.pages.add();
    final ui.Size pageSize = currentPage.getClientSize();
    double y = 0;
    
    // --- Header ---
    // Name
    currentPage.graphics.drawString(cv.name, titleFont, 
      bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 30),
      format: PdfStringFormat(alignment: PdfTextAlignment.center));
    y += 35;
    
    // Contact Info
    final List<String> contacts = [];
    if (cv.email != null && cv.email!.isNotEmpty) contacts.add(cv.email!);
    if (cv.phone != null && cv.phone!.isNotEmpty) contacts.add(cv.phone!);
    if (cv.location != null && cv.location!.isNotEmpty) contacts.add(cv.location!);
    if (cv.linkedin != null && cv.linkedin!.isNotEmpty) contacts.add('LinkedIn');
    if (cv.portfolio != null && cv.portfolio!.isNotEmpty) contacts.add('Portfolio');
    
    if (contacts.isNotEmpty) {
      currentPage.graphics.drawString(contacts.join(' | '), bodyFont,
        bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 20),
        format: PdfStringFormat(alignment: PdfTextAlignment.center));
      y += 30;
    }
    
    // Draw Divider
    currentPage.graphics.drawLine(PdfPen(PdfColor(200, 200, 200)), ui.Offset(0, y), ui.Offset(pageSize.width, y));
    y += 20;
    
    // --- Professional Summary ---
    if (cv.summary != null && cv.summary!.isNotEmpty) {
      final result = _drawSectionTitle(document, currentPage, 'SUMMARY', sectionFont, y, pageSize.width);
      currentPage = result.page;
      y = result.bounds.bottom + 5;
      
      final contentResult = _drawText(currentPage, cv.summary!, bodyFont, y, pageSize.width);
      currentPage = contentResult.page;
      y = contentResult.bounds.bottom + 20;
    }
    
    // --- Experience ---
    if (cv.workExperience.isNotEmpty) {
      final result = _drawSectionTitle(document, currentPage, 'EXPERIENCE', sectionFont, y, pageSize.width);
      currentPage = result.page;
      y = result.bounds.bottom + 10;
      
      for (var work in cv.workExperience) {
        // Check if we need a new page for the title block (approx 60 height)
        if (y > pageSize.height - 60) {
          currentPage = document.pages.add();
          y = 0;
        }

        // Job Title
        currentPage.graphics.drawString(work.jobTitle.toUpperCase(), boldBodyFont, 
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width - 150, 20));
        
        // Date
        String dateRange = '${_formatDate(work.startDate)} - ${work.isCurrentlyWorking ? "Present" : _formatDate(work.endDate)}';
        currentPage.graphics.drawString(dateRange, bodyFont, 
          bounds: ui.Rect.fromLTWH(pageSize.width - 150, y, 150, 20), 
          format: PdfStringFormat(alignment: PdfTextAlignment.right));
        y += 15;
        
        // Company
        String companyLine = work.companyName;
        if (work.location != null) companyLine += ', ${work.location}';
        currentPage.graphics.drawString(companyLine, smallFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 20));
        y += 20;
        
        // Responsibilities
        if (work.responsibilities.isNotEmpty) {
          final textResult = _drawText(currentPage, work.responsibilities, bodyFont, y, pageSize.width);
          currentPage = textResult.page;
          y = textResult.bounds.bottom + 15;
        } else {
          y += 15;
        }
      }
    }
    
    // --- Education ---
    if (cv.education.isNotEmpty) {
      final result = _drawSectionTitle(document, currentPage, 'EDUCATION', sectionFont, y, pageSize.width);
      currentPage = result.page;
      y = result.bounds.bottom + 10;
      
      for (var edu in cv.education) {
        if (y > pageSize.height - 60) {
          currentPage = document.pages.add();
          y = 0;
        }

        currentPage.graphics.drawString(edu.institution.toUpperCase(), boldBodyFont, 
          bounds: ui.Rect.fromLTWH(0, y, pageSize.width - 150, 20));
        
        String dateRange = '${edu.startYear} - ${edu.isCurrentlyStudying ? "Present" : (edu.endYear ?? "")}';
        currentPage.graphics.drawString(dateRange, bodyFont, 
          bounds: ui.Rect.fromLTWH(pageSize.width - 150, y, 150, 20), 
          format: PdfStringFormat(alignment: PdfTextAlignment.right));
        y += 15;
        
        String degreeLine = '${edu.degree}, ${edu.major}';
        if (edu.gpa != null) degreeLine += ' (GPA: ${edu.gpa})';
        currentPage.graphics.drawString(degreeLine, bodyFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 20));
        y += 20;
      }
      y += 10;
    }
    
    // --- Skills ---
    if (cv.skills.isNotEmpty) {
      final result = _drawSectionTitle(document, currentPage, 'SKILLS', sectionFont, y, pageSize.width);
      currentPage = result.page;
      y = result.bounds.bottom + 5;
      
      final contentResult = _drawText(currentPage, cv.skills.join(', '), bodyFont, y, pageSize.width);
      currentPage = contentResult.page;
      y = contentResult.bounds.bottom + 20;
    }

    // --- Certifications ---
    if (cv.certifications.isNotEmpty) {
       final result = _drawSectionTitle(document, currentPage, 'CERTIFICATIONS', sectionFont, y, pageSize.width);
       currentPage = result.page;
       y = result.bounds.bottom + 10;

       for (var cert in cv.certifications) {
         if (y > pageSize.height - 50) {
           currentPage = document.pages.add();
           y = 0;
         }
         
         String certLine = cert.name;
         if (cert.issuingOrganization.isNotEmpty) certLine += ' - ${cert.issuingOrganization}';
         currentPage.graphics.drawString(certLine, bodyFont, bounds: ui.Rect.fromLTWH(0, y, pageSize.width, 20));
         y += 20;
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
  
  PdfLayoutResult _drawSectionTitle(PdfDocument document, PdfPage page, String title, PdfFont font, double y, double width) {
    if (y + 30 > page.getClientSize().height) {
      page = document.pages.add();
      y = 0;
    }
    final PdfTextElement element = PdfTextElement(text: title, font: font);
    final result = element.draw(
      page: page,
      bounds: ui.Rect.fromLTWH(0, y, width, 20),
    );
    return result!;
  }
  
  PdfLayoutResult _drawText(PdfPage page, String text, PdfFont font, double y, double width) {
    final PdfTextElement element = PdfTextElement(text: text, font: font);
    // Use PdfLayoutFormat to ensure pagination works
    final PdfLayoutFormat format = PdfLayoutFormat(layoutType: PdfLayoutType.paginate);
    
    final PdfLayoutResult? result = element.draw(
      page: page,
      bounds: ui.Rect.fromLTWH(0, y, width, 0),
      format: format,
    );
    
    return result!;
  }
  
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM yyyy').format(date);
  }
}
