import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:minio/minio.dart';
import 'package:resummy_app/core/constants/app_constants.dart';

class DOSpacesService {
  late final Minio _client;

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

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final suffixPart = suffix != null ? '_$suffix' : '';
      final objectName = '$userId/${cvId}_$timestamp$suffixPart.pdf';

      debugPrint('📤 Uploading PDF to DO Spaces: $objectName');

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

      final publicUrl = '$cdnEndpoint/$objectName';
      debugPrint('✅ PDF uploaded successfully: $publicUrl');

      return publicUrl;
    } catch (e) {
      debugPrint('❌ Error uploading PDF: $e');
      rethrow;
    }
  }

  Future<void> deletePDF(String pdfUrl) async {
    try {
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

      final stream =
          await _client.getObject(AppConstants.doSpacesBucket, objectName);
      final file = File(localPath);
      await stream.pipe(file.openWrite());

      debugPrint('✅ PDF downloaded successfully to: $localPath');

      return localPath;
    } catch (e) {
      debugPrint('❌ Error downloading PDF: $e');
      rethrow;
    }
  }

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

  String? _extractObjectNameFromUrl(String url) {
    try {
      if (url.startsWith(cdnEndpoint)) {
        return url.replaceFirst('$cdnEndpoint/', '');
      }

      final originEndpoint =
          'https://${AppConstants.doSpacesBucket}.${AppConstants.doSpacesEndpoint}';
      if (url.startsWith(originEndpoint)) {
        return url.replaceFirst('$originEndpoint/', '');
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> listUserPDFs(String userId) async {
    try {
      await _client
          .listObjectsV2(
            AppConstants.doSpacesBucket,
            prefix: '$userId/',
          )
          .toList();

      return [];
    } catch (e) {
      debugPrint('❌ Error listing user PDFs: $e');
      return [];
    }
  }
}
