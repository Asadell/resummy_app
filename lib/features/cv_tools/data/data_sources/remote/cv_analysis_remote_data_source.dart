import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:resummy_app/core/constants/app_constants.dart';
import 'package:resummy_app/features/cv_tools/data/models/cv_analysis_model.dart';

abstract class CvAnalysisRemoteDataSource {
  Future<CvAnalysisModel> prompt({
    required String text,
  });
}

class CvAnalysisRemoteDataSourceImpl implements CvAnalysisRemoteDataSource {
  @override
  Future<CvAnalysisModel> prompt({required String text}) async {
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
                'text': text,
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
