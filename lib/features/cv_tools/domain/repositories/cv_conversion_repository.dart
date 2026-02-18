import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'dart:io';

abstract class CVConversionRepository {
  Future<CVData> convertFromFile(
    File file, {
    String? targetLanguage,
  });

  Future<void> saveConvertedCV(CVData cv, String userId);
}
