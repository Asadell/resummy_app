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

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ProfileProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<CvAnalyzerProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<CVBuilderProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<InterviewProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<HistoryProvider>()),
      ],
      child: ResummyApp(),
    ),
  );
}
