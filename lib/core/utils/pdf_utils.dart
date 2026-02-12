import 'dart:io';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfUtils {
  Future<String> extractText(String filePath) async {
    final document =
        PdfDocument(inputBytes: await File(filePath).readAsBytes());
    String text = PdfTextExtractor(document).extractText();
    document.dispose();

    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
