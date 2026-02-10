import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:resummy_app/core/constants/app_constants.dart';
import 'package:resummy_app/features/cv_tools/data/models/cv_analysis_model.dart';

abstract class CvAnalysisRemoteDataSource {
  Future<CvAnalysisModel> analyze({
    required String cvText,
    required String positionTarget,
    required String language,
  });
}

class CvAnalysisRemoteDataSourceImpl implements CvAnalysisRemoteDataSource {
  @override
  Future<CvAnalysisModel> analyze({
    required String cvText,
    required String positionTarget,
    required String language,
  }) async {
    final response = await Dio().post(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent',
      options: Options(
        headers: {
          'x-goog-api-key': AppConstants.geminiApiKey,
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'contents': [
          {
            'parts': [
              {
                'text': """
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
                    - Teks CV: $cvText

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
                  """,
              },
            ],
          },
        ],
      },
    );

    return CvAnalysisModel.fromJson(jsonDecode(
        response.data['candidates'][0]['content']['parts'][0]['text']));
  }
}
