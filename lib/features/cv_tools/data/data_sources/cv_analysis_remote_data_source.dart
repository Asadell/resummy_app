import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:resummy_app/core/services/gemini_pool_manager.dart';
import 'package:resummy_app/features/cv_tools/data/models/cv_analysis_model.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis.dart';
import 'package:uuid/uuid.dart';

class CVAnalysisRemoteDataSource {
  final GeminiPoolManager _geminiPool;
  final Uuid _uuid = const Uuid();

  CVAnalysisRemoteDataSource(this._geminiPool);

  Future<CvAnalysisResult> analyzeCV({
    required String cvText,
    required String jobPosition,
    String jobDescription = '',
    String language = 'id',
  }) async {
    final prompt = _buildAnalysisPrompt(
      cvText: cvText,
      jobPosition: jobPosition,
      jobDescription: jobDescription,
      language: language,
    );

    try {
      final response = await _geminiPool.executeWithRetry(
        poolType: GeminiPoolType.cvAnalyzer,
        task: (model) async {
          final content = [Content.text(prompt)];
          final result = await model.generateContent(
            content,
            generationConfig: GenerationConfig(
              temperature: 0.2,
              maxOutputTokens: 8192,
              responseMimeType: 'application/json',
            ),
          );
          return result;
        },
      );

      final rawJson = response.text ?? '';
      final cleanJson =
          rawJson.replaceAll('```json', '').replaceAll('```', '').trim();

      final data = jsonDecode(cleanJson) as Map<String, dynamic>;

      return CvAnalysisResultModel.fromJson(
        data,
        id: _uuid.v4(),
        createdAt: DateTime.now(),
        jobPosition: jobPosition,
        jobDescription: jobDescription.isEmpty ? null : jobDescription,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> convertAppliedSuggestionsToCvJson({
    required String originalCvText,
    required List<CvSuggestion> appliedSuggestions,
    required String jobPosition,
  }) async {
    final suggestionsText = appliedSuggestions.asMap().entries.map((e) {
      final i = e.key + 1;
      final s = e.value;
      return '''
Saran $i (${s.sectionTitle}):
  - GANTI: "${s.original}"
  - DENGAN: "${s.suggestion}"''';
    }).join('\n');

    final prompt = '''
Kamu adalah expert CV formatter dan ATS specialist.

Tugas kamu:
1. Baca CV asli di bawah
2. Terapkan SEMUA perubahan yang ada di daftar saran
3. Return seluruh isi CV yang sudah diperbarui dalam format JSON yang diminta

TARGET POSISI: $jobPosition

DAFTAR SARAN YANG HARUS DITERAPKAN:
$suggestionsText

CV ASLI:
$originalCvText

PENTING:
- Terapkan SEMUA saran di atas ke konten CV
- Pertahankan semua informasi lain yang tidak ada di daftar saran
- Jangan ubah apapun yang tidak ada di daftar saran
- Deteksi bahasa CV dan gunakan bahasa yang sama
- Return ONLY pure JSON, no markdown, no explanation

Return JSON ini:
{
  "name": "string",
  "email": "string|null",
  "phone": "string|null",
  "linkedin": "string|null",
  "portfolio": "string|null",
  "github": "string|null",
  "location": "string|null",
  "sections": [
    {
      "type": "summary|experience|education|organization|skills|certifications|custom",
      "title": "string",
      "isVisible": true,
      "content": "string (for summary)",
      "entries": [...],
      "skillCategories": {...}
    }
  ]
}
''';

    try {
      final response = await _geminiPool.executeWithRetry(
        poolType: GeminiPoolType.cvAnalyzer,
        task: (model) async {
          final content = [Content.text(prompt)];
          final result = await model.generateContent(
            content,
            generationConfig: GenerationConfig(
              temperature: 0.1,
              maxOutputTokens: 16384,
              responseMimeType: 'application/json',
            ),
          );
          return result;
        },
      );

      final rawJson = response.text ?? '';
      final cleanJson =
          rawJson.replaceAll('```json', '').replaceAll('```', '').trim();

      return jsonDecode(cleanJson) as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  String _buildAnalysisPrompt({
    required String cvText,
    required String jobPosition,
    required String jobDescription,
    required String language,
  }) {
    final langNote = language == 'id'
        ? 'Tulis SEMUA teks output JSON dalam Bahasa Indonesia yang natural dan profesional.'
        : 'Write ALL output text in professional English.';

    final jobDescSection = jobDescription.trim().isNotEmpty
        ? 'JOB DESCRIPTION:\n${jobDescription.trim()}'
        : 'Job description tidak disediakan. Analisis berdasarkan judul posisi saja.';

    return '''
Kamu adalah sistem pakar ATS dan Senior HR Manager profesional, seperti Cake.me AI Resume Checker.
$langNote

ATURAN:
1. "suggestion" HARUS kalimat REVISI UTUH siap pakai, BUKAN instruksi.
   SALAH: "Tambahkan angka pada pencapaian"
   BENAR: "Architected financial services hotline app for 8 countries, reducing deployment time by 30% and serving 2M+ users annually."
2. "original" = kalimat PERSIS dari CV yang lemah.
3. "reason" = 1 kalimat pendek max 12 kata.
4. Transferable skills: hubungkan pengalaman lama ke target posisi baru.
5. Maks 15 saran, prioritaskan yang paling berdampak ke ATS.
6. Kategori: measurable_result / spelling_grammar / bullet_points / keywords / sections / style

TARGET POSISI: $jobPosition
$jobDescSection

TEKS CV:
$cvText

Return ONLY pure JSON:
{
  "overall_score": 0-100,
  "metrics": {
    "keyword_match": 0-100,
    "quantifiable_achievements": 0-100,
    "structure_completeness": 0-100,
    "language_professionalism": 0-100
  },
  "summary_feedback": "2-3 kalimat ringkasan",
  "highlights": ["kekuatan 1", "kekuatan 2", "kekuatan 3"],
  "improvements": ["area perbaikan 1", "area perbaikan 2", "area perbaikan 3"],
  "missing_keywords": ["keyword1", "keyword2"],
  "suggestions": [
    {
      "section_title": "Work Experience",
      "priority": "high/medium/low",
      "category": "measurable_result/spelling_grammar/bullet_points/keywords/sections/style",
      "original": "Kalimat asli dari CV",
      "suggestion": "Kalimat revisi siap pakai",
      "reason": "Alasan singkat"
    }
  ]
}
''';
  }
}
