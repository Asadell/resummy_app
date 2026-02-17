import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:resummy_app/core/constants/app_constants.dart';

// ─── MODELS ──────────────────────────────────────────────────────

enum SuggestionPriority { high, medium, low }

enum SuggestionCategory {
  measurableResult,
  spellingGrammar,
  bulletPoints,
  keywords,
  style,
  sections,
}

extension SuggestionCategoryLabel on SuggestionCategory {
  String get label {
    switch (this) {
      case SuggestionCategory.measurableResult:
        return 'Measurable Result';
      case SuggestionCategory.spellingGrammar:
        return 'Spelling & Grammar';
      case SuggestionCategory.bulletPoints:
        return 'Bullet Points';
      case SuggestionCategory.keywords:
        return 'Keywords';
      case SuggestionCategory.style:
        return 'Style';
      case SuggestionCategory.sections:
        return 'Sections';
    }
  }
}

class CvSuggestion {
  final String id;
  final String sectionTitle;
  final SuggestionPriority priority;
  final SuggestionCategory category;
  final String original;
  final String suggestion;
  final String reason;
  bool isDismissed;
  bool isApplied;

  CvSuggestion({
    required this.id,
    required this.sectionTitle,
    required this.priority,
    required this.category,
    required this.original,
    required this.suggestion,
    required this.reason,
    this.isDismissed = false,
    this.isApplied = false,
  });

  factory CvSuggestion.fromJson(Map<String, dynamic> json, int index) {
    final priorityStr = (json['priority'] as String? ?? 'medium').toLowerCase();
    final categoryStr = (json['category'] as String? ?? 'style').toLowerCase();

    final priority = switch (priorityStr) {
      'high' => SuggestionPriority.high,
      'low' => SuggestionPriority.low,
      _ => SuggestionPriority.medium,
    };

    final category = switch (categoryStr) {
      'measurable_result' => SuggestionCategory.measurableResult,
      'spelling_grammar' => SuggestionCategory.spellingGrammar,
      'bullet_points' => SuggestionCategory.bulletPoints,
      'keywords' => SuggestionCategory.keywords,
      'sections' => SuggestionCategory.sections,
      _ => SuggestionCategory.style,
    };

    return CvSuggestion(
      id: 'sug_$index',
      sectionTitle: json['section_title'] as String? ?? 'General',
      priority: priority,
      category: category,
      original: json['original'] as String? ?? '',
      suggestion: json['suggestion'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
    );
  }
}

class CvScoreMetrics {
  final int keywordMatch;
  final int quantifiableAchievements;
  final int structureCompleteness;
  final int languageProfessionalism;

  const CvScoreMetrics({
    required this.keywordMatch,
    required this.quantifiableAchievements,
    required this.structureCompleteness,
    required this.languageProfessionalism,
  });

  factory CvScoreMetrics.fromJson(Map<String, dynamic> json) => CvScoreMetrics(
        keywordMatch: (json['keyword_match'] as num? ?? 0).toInt(),
        quantifiableAchievements:
            (json['quantifiable_achievements'] as num? ?? 0).toInt(),
        structureCompleteness:
            (json['structure_completeness'] as num? ?? 0).toInt(),
        languageProfessionalism:
            (json['language_professionalism'] as num? ?? 0).toInt(),
      );
}

class CvAnalysisResult {
  final int overallScore;
  final CvScoreMetrics metrics;
  final String summaryFeedback;
  final List<String> highlights;
  final List<String> improvements;
  final List<String> missingKeywords;
  final List<CvSuggestion> suggestions;

  CvAnalysisResult({
    required this.overallScore,
    required this.metrics,
    required this.summaryFeedback,
    required this.highlights,
    required this.improvements,
    required this.missingKeywords,
    required this.suggestions,
  });

  String get grade {
    if (overallScore >= 85) return 'Excellent!';
    if (overallScore >= 70) return 'Good';
    if (overallScore >= 50) return 'Fair';
    return 'Needs Work';
  }

  int get pendingCount =>
      suggestions.where((s) => !s.isDismissed && !s.isApplied).length;
  int get appliedCount => suggestions.where((s) => s.isApplied).length;
  int get dismissedCount => suggestions.where((s) => s.isDismissed).length;

  factory CvAnalysisResult.fromJson(Map<String, dynamic> json) {
    final rawSugs = json['suggestions'] as List<dynamic>? ?? [];
    return CvAnalysisResult(
      overallScore: (json['overall_score'] as num? ?? 0).toInt(),
      metrics: CvScoreMetrics.fromJson(
          json['metrics'] as Map<String, dynamic>? ?? {}),
      summaryFeedback: json['summary_feedback'] as String? ?? '',
      highlights: List<String>.from(json['highlights'] as List? ?? []),
      improvements: List<String>.from(json['improvements'] as List? ?? []),
      missingKeywords:
          List<String>.from(json['missing_keywords'] as List? ?? []),
      suggestions: rawSugs
          .asMap()
          .entries
          .map((e) =>
              CvSuggestion.fromJson(e.value as Map<String, dynamic>, e.key))
          .toList(),
    );
  }
}

// ─── SERVICE ─────────────────────────────────────────────────────

class CvAnalyzerService {
  static const List<String> _apiKeys = [
    AppConstants.geminiApiKey22,
    AppConstants.geminiApiKey23,
    AppConstants.geminiApiKey24,
    AppConstants.geminiApiKey25,
    AppConstants.geminiApiKey26,
    AppConstants.geminiApiKey27,
    AppConstants.geminiApiKey28,
    AppConstants.geminiApiKey29,
    AppConstants.geminiApiKey30,
    AppConstants.geminiApiKey31,
  ];

  static int _keyIndex = 0;
  static String _nextKey() => _apiKeys[(_keyIndex++) % _apiKeys.length];

  /// Kirim CV asli + saran yang di-apply ke Gemini,
  /// minta Gemini return JSON format CVData
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

      // Untuk type "summary":
      "content": "string",

      // Untuk type "experience":
      "entries": [
        {
          "companyName": "string",
          "jobTitle": "string",
          "location": "string|null",
          "startDate": "MMM yyyy",
          "endDate": "MMM yyyy|null",
          "isPresent": false,
          "description": "string|null",
          "bullets": ["bullet 1", "bullet 2"]
        }
      ],

      // Untuk type "education":
      "entries": [
        {
          "institution": "string",
          "degree": "string",
          "major": "string",
          "startYear": 2020,
          "endYear": 2024,
          "isPresent": false,
          "gpa": "string|null",
          "bullets": ["achievement 1"]
        }
      ],

      // Untuk type "organization":
      "entries": [
        {
          "organizationName": "string",
          "role": "string",
          "location": "string|null",
          "startDate": "MMM yyyy",
          "endDate": "MMM yyyy|null",
          "isPresent": false,
          "bullets": ["description"]
        }
      ],

      // Untuk type "skills":
      "skillCategories": {
        "Category Name": ["skill1", "skill2"]
      },

      // Untuk type "certifications":
      "entries": [
        {
          "name": "string",
          "issuingOrganization": "string",
          "issueDate": "MMM yyyy",
          "credentialId": "string|null",
          "credentialUrl": "string|null"
        }
      ],

      // Untuk type "custom" dengan template "skillsLike":
      "template": "skillsLike",
      "skillCategories": { "Category": ["item1"] },

      // Untuk type "custom" dengan template "experienceLike" atau "educationLike":
      "template": "experienceLike",
      "titleLabel": "string",
      "subtitleLabel": "string",
      "metaLabel": "string",
      "entries": [
        {
          "title": "string",
          "subtitle": "string|null",
          "meta": "string|null",
          "startDate": "MMM yyyy|null",
          "endDate": "MMM yyyy|null",
          "isPresent": false,
          "bullets": ["string"]
        }
      ],

      // Untuk type "custom" dengan template "bulletList":
      "template": "bulletList",
      "content": "item1\\nitem2\\nitem3",

      // Untuk type "custom" dengan template "paragraph":
      "template": "paragraph",
      "content": "free text"
    }
  ]
}
''';

    Future<Response> doRequest(String key) => Dio().post(
      'https://generativelanguage.googleapis.com/v1alpha/models/gemini-3-flash-preview:generateContent',
      options: Options(
        headers: {
          'x-goog-api-key': key,
          'Content-Type': 'application/json',
        },
        receiveTimeout: const Duration(seconds: 120),
        sendTimeout: const Duration(seconds: 30),
      ),
      data: {
        'contents': [
          {
            'parts': [{'text': prompt}]
          }
        ],
        'generationConfig': {
          'temperature': 0.1,
          'maxOutputTokens': 16384,
          'responseMimeType': 'application/json',
        },
        'safetySettings': [
          {'category': 'HARM_CATEGORY_HARASSMENT', 'threshold': 'BLOCK_NONE'},
          {'category': 'HARM_CATEGORY_HATE_SPEECH', 'threshold': 'BLOCK_NONE'},
          {'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT', 'threshold': 'BLOCK_NONE'},
          {'category': 'HARM_CATEGORY_DANGEROUS_CONTENT', 'threshold': 'BLOCK_NONE'},
        ],
      },
    );

    try {
      final response = await doRequest(_nextKey());
      
      final candidate = response.data['candidates'][0];
      String raw = candidate['content']['parts'][0]['text'] as String;
      
      raw = raw.replaceAll('```json', '').replaceAll('```', '').trim();
      return jsonDecode(raw) as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        final response = await doRequest(_nextKey());
        String raw = response.data['candidates'][0]['content']['parts'][0]['text'] as String;
        raw = raw.replaceAll('```json', '').replaceAll('```', '').trim();
        return jsonDecode(raw) as Map<String, dynamic>;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<CvAnalysisResult> analyze({
    required String cvText,
    required String jobPosition,
    String jobDescription = '',
    String language = 'id',
  }) async {
    final prompt = _buildPrompt(
      cvText: cvText,
      jobPosition: jobPosition,
      jobDescription: jobDescription,
      language: language,
    );

    Future<Response> doRequest(String key) => Dio().post(
          'https://generativelanguage.googleapis.com/v1alpha/models/gemini-3-flash-preview:generateContent',
          options: Options(
            headers: {
              'x-goog-api-key': key,
              'Content-Type': 'application/json',
            },
            receiveTimeout: const Duration(seconds: 90),
            sendTimeout: const Duration(seconds: 30),
          ),
          data: {
            'contents': [
              {
                'parts': [
                  {'text': prompt}
                ]
              }
            ],
            'generationConfig': {
              'temperature': 0.2,
              'maxOutputTokens': 8192,
              'responseMimeType': 'application/json',
            },
          },
        );

    try {
      final response = await doRequest(_nextKey());
      return _parse(response);
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        final retryResponse = await doRequest(_nextKey());
        return _parse(retryResponse);
      }
      throw Exception('Analisis gagal: ${e.message}');
    }
  }

  CvAnalysisResult _parse(Response response) {
    String raw =
        response.data['candidates'][0]['content']['parts'][0]['text'] as String;
    raw = raw.replaceAll('```json', '').replaceAll('```', '').trim();
    return CvAnalysisResult.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  String _buildPrompt({
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
