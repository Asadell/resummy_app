import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'dart:io';

/// Repository interface for CV Conversion operations (ATS Converter)
abstract class CVConversionRepository {
  /// Convert a CV file (PDF/Image) to structured CVData
  Future<CVData> convertFromFile(
    File file, {
    String? targetLanguage,
  });

  /// Save converted CV to storage
  Future<void> saveConvertedCV(CVData cv, String userId);
}
