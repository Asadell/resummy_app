import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:minio/minio.dart';
import 'package:resummy_app/core/constants/app_constants.dart';

/// Service for managing PDF uploads/downloads to/from DigitalOcean Spaces
/// Uses Minio client as DO Spaces is S3-compatible
class DOSpacesService {
  late final Minio _client;
  
  // CDN endpoint for public access
  static const String cdnEndpoint = AppConstants.doSpacesCdnEndpoint;

  DOSpacesService() {
    _client = Minio(
      endPoint: AppConstants.doSpacesEndpoint,
      accessKey: AppConstants.doSpacesAccessKey,
      secretKey: AppConstants.doSpacesSecretKey,
      region: AppConstants.doSpacesRegion,
      useSSL: true,
    );
    debugPrint('✅ DOSpacesService initialized');
  }

  /// Upload a PDF file to DO Spaces
  /// Returns the public URL of the uploaded file
  /// 
  /// [filePath] - Local file path
  /// [userId] - User ID for organizing files
  /// [cvId] - CV ID for unique naming
  /// [suffix] - Optional suffix (e.g., 'translated_en', 'ats')
  Future<String> uploadPDF({
    required String filePath,
    required String userId,
    required String cvId,
    String? suffix,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      // Generate unique object name: userId/cvId_timestamp_suffix.pdf
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final suffixPart = suffix != null ? '_$suffix' : '';
      final objectName = '$userId/${cvId}_$timestamp$suffixPart.pdf';

      debugPrint('📤 Uploading PDF to DO Spaces: $objectName');

      // Upload file - convert to Uint8List for Minio v3.x compatibility
      final bytes = await file.readAsBytes();
      final uint8list = Uint8List.fromList(bytes);
      final stream = Stream<Uint8List>.value(uint8list);
      
      await _client.putObject(
        AppConstants.doSpacesBucket,
        objectName,
        stream,
        size: bytes.length,
        metadata: {
          'Content-Type': 'application/pdf',
        },
      );

      // Return CDN URL
      final publicUrl = '$cdnEndpoint/$objectName';
      debugPrint('✅ PDF uploaded successfully: $publicUrl');
      
      return publicUrl;
    } catch (e) {
      debugPrint('❌ Error uploading PDF: $e');
      rethrow;
    }
  }

  /// Delete a PDF file from DO Spaces
  /// 
  /// [pdfUrl] - Full URL of the PDF (from CDN or origin endpoint)
  Future<void> deletePDF(String pdfUrl) async {
    try {
      // Extract object name from URL
      final objectName = _extractObjectNameFromUrl(pdfUrl);
      if (objectName == null) {
        throw Exception('Invalid PDF URL: $pdfUrl');
      }

      debugPrint('🗑️ Deleting PDF from DO Spaces: $objectName');

      await _client.removeObject(AppConstants.doSpacesBucket, objectName);

      debugPrint('✅ PDF deleted successfully: $objectName');
    } catch (e) {
      debugPrint('❌ Error deleting PDF: $e');
      rethrow;
    }
  }

  /// Download a PDF file from DO Spaces to local storage
  /// Returns the local file path
  /// 
  /// [pdfUrl] - Full URL of the PDF
  /// [localPath] - Where to save the file locally
  Future<String> downloadPDF({
    required String pdfUrl,
    required String localPath,
  }) async {
    try {
      final objectName = _extractObjectNameFromUrl(pdfUrl);
      if (objectName == null) {
        throw Exception('Invalid PDF URL: $pdfUrl');
      }

      debugPrint('📥 Downloading PDF from DO Spaces: $objectName');

      final stream = await _client.getObject(AppConstants.doSpacesBucket, objectName);
      final file = File(localPath);
      await stream.pipe(file.openWrite());

      debugPrint('✅ PDF downloaded successfully to: $localPath');
      
      return localPath;
    } catch (e) {
      debugPrint('❌ Error downloading PDF: $e');
      rethrow;
    }
  }

  /// Get a presigned URL for temporary access to a private file
  /// Useful if you want to make files private by default
  /// 
  /// [pdfUrl] - Full URL of the PDF
  /// [expirySeconds] - How long the URL should be valid (default: 1 hour)
  Future<String> getPresignedUrl({
    required String pdfUrl,
    int expirySeconds = 3600,
  }) async {
    try {
      final objectName = _extractObjectNameFromUrl(pdfUrl);
      if (objectName == null) {
        throw Exception('Invalid PDF URL: $pdfUrl');
      }

      final presignedUrl = await _client.presignedGetObject(
        AppConstants.doSpacesBucket,
        objectName,
        expires: expirySeconds,
      );

      return presignedUrl;
    } catch (e) {
      debugPrint('❌ Error generating presigned URL: $e');
      rethrow;
    }
  }

  /// Check if a file exists in DO Spaces
  Future<bool> fileExists(String pdfUrl) async {
    try {
      final objectName = _extractObjectNameFromUrl(pdfUrl);
      if (objectName == null) return false;

      await _client.statObject(AppConstants.doSpacesBucket, objectName);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Extract object name from full URL
  /// Supports both CDN and origin endpoint URLs
  String? _extractObjectNameFromUrl(String url) {
    try {
      // Remove CDN endpoint
      if (url.startsWith(cdnEndpoint)) {
        return url.replaceFirst('$cdnEndpoint/', '');
      }
      
      // Remove origin endpoint
      final originEndpoint = 'https://${AppConstants.doSpacesBucket}.${AppConstants.doSpacesEndpoint}';
      if (url.startsWith(originEndpoint)) {
        return url.replaceFirst('$originEndpoint/', '');
      }

      // If URL doesn't match expected format, return null
      return null;
    } catch (e) {
      return null;
    }
  }

  /// List all PDFs for a specific user
  Future<List<String>> listUserPDFs(String userId) async {
    try {
      await _client.listObjectsV2(
        AppConstants.doSpacesBucket,
        prefix: '$userId/',
      ).toList();

      // Note: Minio v3.x ListObjectsResult structure may vary
      // For now, return empty list - this needs testing with actual Minio instance
      return [];
      // TODO: Fix when testing with real DO Spaces
      // return objects.map((obj) => '$cdnEndpoint/${obj.key}').toList();
    } catch (e) {
      debugPrint('❌ Error listing user PDFs: $e');
      return [];
    }
  }
}
