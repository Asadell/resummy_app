import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:resummy_app/core/constants/app_constants.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis_entity.dart';

class AnalyzeCvUseCase {
  Future<CvAnalysisEntity> call(String role, String cvText) async {
    final prompt = """
      Kamu adalah sistem pakar ATS (Applicant Tracking System) dan Senior HR Manager profesional. 
      Tugasmu adalah menganalisis teks mentah hasil ekstraksi CV dan membandingkannya dengan target posisi pekerjaan yang diberikan.

      ATURAN UTAMA:
      1. Jika target posisi tidak sesuai dengan teks CV, berikan skor 0 di semua metrik dan jelaskan ketidakrelevanannya di 'summary_feedback'.
      2. Gunakan bahasa yang sama dengan teks CV (Indonesia jika CV Indonesia, Inggris jika CV Inggris).
      3. Pada bagian 'weak_bullet_points.suggestion', kamu dilarang memberikan instruksi atau penjelasan (Misal: "Coba tambahkan angka" atau "Gunakan kata kerja aktif"). 
      4. 'suggestion' HARUS berisi kalimat revisi utuh yang sudah diperbaiki, profesional, terukur (quantifiable), dan siap digunakan langsung oleh pengguna untuk mengganti kalimat aslinya.

      Kriteria Penilaian:
      1. Keyword Match: Kesesuaian hard skills dan tools dengan target posisi.
      2. Quantifiable Achievements: Penggunaan angka/persentase untuk dampak nyata.
      3. Structure Completeness: Keberadaan Kontak, Ringkasan, Pengalaman, Pendidikan, dan Skill.
      4. Language Professionalism: Penggunaan Action Verbs dan nada bicara formal.

      Input:
      - Target Posisi: $role
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
            "title": "Nama Bagian CV (Contoh: Pengalaman Kerja / Experience)",
            "priority": "high/medium/low",
            "original": "Kalimat asli dari CV yang lemah",
            "suggestion": "Kalimat baru yang sudah direvisi total, mengandung angka/pencapaian, dan siap pakai."
          }
        ],
        "summary_feedback": "Ringkasan analisis 2-3 kalimat yang suportif."
      }
    """;

    try {
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
                  'text': prompt,
                },
              ],
            },
          ],
        },
      );

      final analyzeResult = jsonDecode(
          response.data['candidates'][0]['content']['parts'][0]['text']);

      return CvAnalysisEntity(
        metrics: CvAnalysisMetrics(
          keywordMatch: analyzeResult['metrics']['keyword_match'],
          quantifiableAchievements: analyzeResult['metrics']
              ['quantifiable_achievements'],
          structureCompleteness: analyzeResult['metrics']
              ['structure_completeness'],
          languageProfessionalism: analyzeResult['metrics']
              ['language_professionalism'],
        ),
        missingKeywords: List<String>.from(analyzeResult['missing_keywords']),
        weakBulletPoints:
            (analyzeResult['weak_bullet_points'] as List).map((item) {
          final priorityStr = (item['priority'] as String).toLowerCase();

          return CvAnalysisWeakBulletPoint(
            title: item['title'],
            priority: priorityStr == 'high'
                ? CvAnalysisWeakBulletPointPriority.high
                : priorityStr == 'medium'
                    ? CvAnalysisWeakBulletPointPriority.medium
                    : CvAnalysisWeakBulletPointPriority.low,
            original: item['original'],
            suggestion: item['suggestion'],
          );
        }).toList(),
        overallScore: analyzeResult['overall_score'],
        summaryFeedback: analyzeResult['summary_feedback'],
      );
    } catch (e) {
      if (e is DioException) {
        debugPrint('Gemini API DioError: ${e.response?.data ?? e.message}');
      } else {
        debugPrint('Gemini API Unknown Error: ${e.toString()}');
      }

      rethrow;
    }
  }
}
