import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';

abstract class CVBuilderRepository {
  Future<List<CVData>> getAllCVs();

  Future<CVData?> getCVById(String id);

  Future<void> saveCV(CVData cv);

  Future<void> deleteCV(String id);

  Future<void> clearAllCVs();
}
