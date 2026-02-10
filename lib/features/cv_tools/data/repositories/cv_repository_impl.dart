import 'package:dio/dio.dart';
import 'package:resummy_app/core/errors/exceptions.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/remote/cv_analysis_remote_data_source.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis_entity.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_repository.dart';

class CvRepositoryImpl implements CvRepository {
  final CvAnalysisRemoteDataSource _remoteDataSource;

  CvRepositoryImpl(this._remoteDataSource);

  @override
  Future<CvAnalysisEntity> analyzeCv(
    String cvContent,
    String positionTarget,
    String language,
  ) async {
    try {
      final result = await _remoteDataSource.prompt(text: """
        Kamu adalah sistem pakar ATS (Applicant Tracking System) dan Senior HR Manager profesional. 
        Tugasmu adalah menganalisis teks mentah hasil ekstraksi CV dan membandingkannya dengan TARGET POSISI PEKERJAAN yang diberikan.

        ATURAN UTAMA:
        1. Jika target posisi sangat jauh berbeda dengan isi CV (misal: Supir Truk melamar jadi Dokter Bedah), berikan skor rendah tapi tetap berikan saran pivot karir.
        
        2. 'suggestion' HARUS berupa kalimat revisi utuh yang siap pakai, BUKAN instruksi.

        3. [CRITICAL] TRANSFERABLE SKILLS MAPPING:
          Saat memperbaiki 'weak_bullet_points', kamu WAJIB menghubungkan pengalaman lama dengan TARGET POSISI baru.
          - Contoh Kasus: Frontend Developer -> Melamar jadi Guru.
          - JANGAN TULIS: "Mengoptimalkan performa website React sebesar 30%." (Ini cuma membaguskan skill coding).
          - TAPI TULIS: "Mementori 5 junior developer dalam mempelajari React.js, meningkatkan produktivitas tim sebesar 30% melalui sesi pengajaran kode yang efektif." (Ini menonjolkan skill mengajar/mentoring yang relevan untuk Guru).
          
        4. Cari jembatan antara skill lama dengan target baru. Ubah sudut pandang (angle) pencapaian agar relevan dengan posisi yang dituju.

        Input:
        - Target Posisi: $positionTarget
        - Teks CV: $cvContent

        OUTPUT HARUS DALAM FORMAT JSON MURNI (TANPA MARKDOWN).
        Struktur JSON:
        {
          "overall_score": (integer 0-100),
          "metrics": {
            "keyword_match": (integer 0-100),
            "quantifiable_achievements": (integer 0-100),
            "structure_completeness": (integer 0-100),
            "language_professionalism": (integer 0-100)
          },
          "missing_keywords": ["keyword1", "keyword2"],
          "weak_bullet_points": [
            {
              "title": "Nama Bagian CV",
              "priority": "high/medium/low",
              "original": "Kalimat asli yang kurang relevan/lemah",
              "suggestion": "Kalimat REVISI yang mengubah sudut pandang pengalaman lama agar TERLIHAT RELEVAN dengan '$positionTarget'. Gunakan angka/dampak nyata. Gunakan bahasa yang sama dengan teks CV."
            }
          ],
          "summary_feedback": "Ringkasan analisis 2-3 kalimat yang suportif dalam kode bahasa $language, fokus pada gap antara CV saat ini dengan $positionTarget."
        }
      """);

      return result;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw ConnectionException("Connection timeout. Please check your internet connection.");
      } else if (e.type == DioExceptionType.badResponse) {
        throw ServerException("Server error: ${e.response?.statusCode} ${e.response?.statusMessage}");
      }
      throw ServerException("Unexpected error occurred: ${e.message}");
    } on FormatException catch (e) {
      throw ParsingException("Failed to parse response: $e");
    } catch (e) {
      throw ServerException("Analyzing error: $e");
    }
  }
}
