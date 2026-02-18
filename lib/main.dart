import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/app/app.dart';
import 'package:resummy_app/core/providers/locale_provider.dart';
import 'package:resummy_app/core/providers/theme_provider.dart';
import 'package:resummy_app/core/di/injection.dart';
import 'package:resummy_app/features/features.dart';

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

  // Initialize all dependencies including 51 Gemini models
  // and register all Providers
  await setupDI();

  final themeProvider = ThemeProvider();
  final localeProvider = LocaleProvider();
 
  
  await Future.wait([
    themeProvider.init(),
    localeProvider.init(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: localeProvider),
        
        // Auth
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),

        // Profile (depends on Auth internally)
        ChangeNotifierProvider(create: (_) => getIt<ProfileProvider>()),

        // CV Tools
        ChangeNotifierProvider(create: (_) => getIt<CvAnalyzerProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<CVBuilderProvider>()),
        
        // Interview (depends on Auth internally)
        ChangeNotifierProvider(create: (_) => getIt<InterviewProvider>()),
        
        // History (depends on Auth internally)
        ChangeNotifierProvider(create: (_) => getIt<HistoryProvider>()),
      ],
      child: ResummyApp(),
    ),
  );
}
