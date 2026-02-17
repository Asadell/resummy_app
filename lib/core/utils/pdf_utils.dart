import 'dart:io';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfUtils {
  Future<String> extractText(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    final document = PdfDocument(inputBytes: bytes);
    
    // Check page count limit
    if (document.pages.count > 5) {
      document.dispose();
      throw Exception('MAX_PAGES_EXCEEDED');
    }
    
    String text = PdfTextExtractor(document).extractText();
    document.dispose();

    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
