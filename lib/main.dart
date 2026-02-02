import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/app/app.dart';
import 'package:resummy_app/core/providers/locale_provider.dart';
import 'package:resummy_app/core/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize providers
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
      ],
      child: ResummyApp(),
    ),
  );
}
