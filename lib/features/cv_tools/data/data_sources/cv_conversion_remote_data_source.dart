import 'dart:convert';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:resummy_app/core/services/gemini_pool_manager.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/data/services/cv_ats_converter_service.dart';

class CVConversionRemoteDataSource {
  final GeminiPoolManager _geminiPool;
  final CvAtsConverterService _converterService;

  CVConversionRemoteDataSource(
    this._geminiPool,
    this._converterService,
  );

  Future<CVData> convertFromFile(File file, {String? targetLanguage}) async {
    try {
      final bytes = await file.readAsBytes();
      final mimeType = _getMimeType(file.path);


      final prompt = _buildConversionPrompt(targetLanguage: targetLanguage);

      final response = await _geminiPool.executeWithRetry(
        poolType: GeminiPoolType.cvConverter,
        task: (model) async {
          final content = [
            Content.multi([
              DataPart(mimeType, Uint8List.fromList(bytes)),
              TextPart(prompt),
            ])
          ];

          final result = await model.generateContent(
            content,
            generationConfig: GenerationConfig(
              temperature: 1.0,
              topP: 0.95,
              maxOutputTokens: 65536,
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
      final cvData =
          _converterService.parseCvJson(data, source: 'ats_converter');

      return cvData;
    } catch (e) {
      rethrow;
    }
  }

  String _getMimeType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.pdf')) return 'application/pdf';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  String _buildConversionPrompt({String? targetLanguage}) => '''
You are an expert CV/Resume parser and ATS specialist.
${targetLanguage != null ? 'CRITICAL: You MUST translate all extracted content into $targetLanguage. The output JSON values must be in $targetLanguage.' : ''}

Extract ALL information from this CV and return ONLY valid JSON matching this exact structure.
No explanation, no markdown, no backticks — pure JSON only.
IMPORTANT: Ensure all strings are properly escaped. DO NOT include literal newlines within string values; use "\\n" instead.

Rules:
- Dates format: "MMM yyyy" e.g. "Jan 2022", "Aug 2024"
- If date says "Present/Sekarang/Now/Current" → isPresent: true, endDate: null
- Extract bullet points as separate array items, strip bullet characters
- Group skills by category if possible
- Preserve the EXACT order of sections as they appear in the CV
- For mixed sections (awards + skills + competition together) → use custom skillsLike
- For experience-style custom sections → use custom experienceLike
- For education-style custom sections → use custom educationLike

Section template selection rules:
- Work Experience / Pengalaman Kerja → type: "experience"
- Education / Pendidikan → type: "education"
- Organization / Organisasi → type: "organization"
- Skills / Kemampuan → type: "skills"
- Certifications / Sertifikasi → type: "certifications"
- Professional Summary / Ringkasan → type: "summary"
- Mixed awards + skills + competitions in bullet format → type: "custom", template: "skillsLike"
- Volunteer / Projects / Awards with dates → type: "custom", template: "experienceLike"
- Courses / Training with dates → type: "custom", template: "educationLike"
- Simple item list → type: "custom", template: "bulletList"
- Free text → type: "custom", template: "paragraph"

Return this JSON structure:
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
      "type": "summary",
      "title": "Professional Summary",
      "isVisible": true,
      "content": "string"
    },
    {
      "type": "experience",
      "title": "Work Experience",
      "isVisible": true,
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
      ]
    },
    {
      "type": "education",
      "title": "Education",
      "isVisible": true,
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
      ]
    },
    {
      "type": "skills",
      "title": "Skills",
      "isVisible": true,
      "skillCategories": {
        "Programming Languages": ["Python", "Dart"],
        "Frameworks": ["Flutter", "FastAPI"]
      }
    }
  ]
}
''';
}
