import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/app/app.dart';
import 'package:resummy_app/core/providers/auth_provider.dart';
import 'package:resummy_app/core/providers/locale_provider.dart';
import 'package:resummy_app/core/providers/theme_provider.dart';
import 'package:resummy_app/features/cv_tools/data/repositories/cv_builder_repository_impl.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/cv_local_data_source.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_analyzer_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';
import 'package:resummy_app/core/services/gemini_speech_service.dart';
import 'package:resummy_app/core/services/gemini_interview_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final themeProvider = ThemeProvider();
  final localeProvider = LocaleProvider();
  final authProvider = AuthProvider();

  // Initialize SharedPreferences for CV Builder
  final prefs = await SharedPreferences.getInstance();

  await Future.wait([
    themeProvider.init(),
    localeProvider.init(),
    authProvider.init(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(
          create: (_) => CvAnalyzerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CVBuilderProvider(
            CVBuilderRepositoryImpl(
              CVLocalDataSource(prefs),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => InterviewProvider(
            geminiService: GeminiSpeechService(),
            interviewService: GeminiInterviewService(),
          ),
        ),
      ],
      child: ResummyApp(),
    ),
  );
}
