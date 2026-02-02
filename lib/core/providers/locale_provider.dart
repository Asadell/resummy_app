import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  
  Locale _locale = const Locale('en');
  
  Locale get locale => _locale;
  
  bool get isIndonesian => _locale.languageCode == 'id';
  
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_localeKey);
    
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
      notifyListeners();
    }
  }
  
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
  
  Future<void> toggleLocale() async {
    final newLocale = _locale.languageCode == 'en' 
        ? const Locale('id') 
        : const Locale('en');
    await setLocale(newLocale);
  }
}
