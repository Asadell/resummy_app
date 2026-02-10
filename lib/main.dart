import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/app/app.dart';
import 'package:resummy_app/core/providers/auth_provider.dart';
import 'package:resummy_app/core/providers/locale_provider.dart';
import 'package:resummy_app/core/providers/theme_provider.dart';
import 'package:resummy_app/features/auth/data/user_profile_repository.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/remote/cv_analysis_remote_data_source.dart';
import 'package:resummy_app/features/cv_tools/data/repositories/cv_repository_impl.dart';
import 'package:resummy_app/features/cv_tools/domain/usecases/analyze_cv_usecase.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_analyzer_provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final themeProvider = ThemeProvider();
  final localeProvider = LocaleProvider();
  final authProvider = AuthProvider();

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
          create: (_) => CvAnalyzerProvider(
            userProfileRepository: UserProfileRepository(),
            analyzeCvUseCase: AnalyzeCvUseCase(
              CvRepositoryImpl(CvAnalysisRemoteDataSourceImpl()),
            ),
          ),
        ),
      ],
      child: ResummyApp(),
    ),
  );
}
