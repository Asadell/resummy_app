import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/app/app.dart';
import 'package:resummy_app/features/auth/presentation/providers/auth_provider.dart'; // New AuthProvider
import 'package:resummy_app/core/providers/locale_provider.dart';
import 'package:resummy_app/core/providers/theme_provider.dart';
import 'package:resummy_app/core/di/injection.dart';
import 'package:resummy_app/features/cv_tools/data/repositories/cv_builder_repository_impl.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/cv_local_data_source.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_analyzer_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';
import 'package:resummy_app/features/interview/domain/repositories/interview_repository.dart';
import 'package:resummy_app/features/history/presentation/providers/history_provider.dart'; // Added
import 'package:resummy_app/features/history/domain/repositories/history_repository.dart'; // Added
import 'package:resummy_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:resummy_app/core/services/database_helper.dart'; // Added
import 'package:resummy_app/features/cv_tools/data/data_sources/cv_remote_data_source.dart'; // Added
import 'package:cloud_firestore/cloud_firestore.dart'; // Added
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider; // Added

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
        
        // New AuthProvider using GetIt
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            getUserStreamUseCase: getIt(),
            signInWithGoogleUseCase: getIt(),
            signOutUseCase: getIt(),
          ),
        ),

        // ProfileProvider depends on AuthProvider
        ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
          create: (_) => ProfileProvider(),
          update: (_, auth, profile) {
            final p = profile ?? ProfileProvider();
            final user = auth.currentUser;
            if (user != null) {
              p.loadProfile(user.id);
            }
            return p;
          },
        ),

        ChangeNotifierProvider(
          create: (_) => CvAnalyzerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CVBuilderProvider(
            CVBuilderRepositoryImpl(
              CVLocalDataSource(getIt<DatabaseHelper>()),
              CVRemoteDataSource(FirebaseFirestore.instance),
              FirebaseAuth.instance,
            ),
          ),
        ),
        
        // InterviewProvider depends on AuthProvider for userId
        ChangeNotifierProxyProvider<AuthProvider, InterviewProvider>(
          create: (_) => InterviewProvider(
            getIt<InterviewRepository>(),
          ),
          update: (_, auth, interview) {
             final provider = interview ?? InterviewProvider(getIt<InterviewRepository>());
             final user = auth.currentUser;
             provider.updateUserId(user?.id);
             return provider;
          },
        ),
        
        // HistoryProvider depends on AuthProvider for userId
        ChangeNotifierProxyProvider<AuthProvider, HistoryProvider>(
          create: (_) => HistoryProvider(getIt<HistoryRepository>()),
          update: (_, auth, history) {
             final provider = history ?? HistoryProvider(getIt<HistoryRepository>());
             final user = auth.currentUser;
             if (user != null) {
               provider.loadActivities(user.id);
             } else {
               provider.clear();
             }
             return provider;
          },
        ),
      ],
      child: ResummyApp(),
    ),
  );
}
