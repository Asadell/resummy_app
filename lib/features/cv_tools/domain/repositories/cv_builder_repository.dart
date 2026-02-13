import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';

/// Repository interface for CV Builder operations
abstract class CVBuilderRepository {
  /// Get all saved CVs
  Future<List<CVData>> getAllCVs();

  /// Get a specific CV by ID
  Future<CVData?> getCVById(String id);

  /// Save a new CV or update existing one
  Future<void> saveCV(CVData cv);

  /// Delete a CV by ID
  Future<void> deleteCV(String id);

  /// Clear all CVs
  Future<void> clearAllCVs();
}
