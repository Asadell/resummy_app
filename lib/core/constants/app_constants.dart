import 'package:envied/envied.dart';

part 'app_constants.g.dart';

@Envied(path: '.env')
class AppConstants {
  @EnviedField(varName: 'GEMINI_API_KEY')
  static const String geminiApiKey = _AppConstants.geminiApiKey;

  @EnviedField(varName: 'GEMINI_API_KEY_2', defaultValue: '')
  static const String geminiApiKey2 = _AppConstants.geminiApiKey2;

  @EnviedField(varName: 'GEMINI_API_KEY_3', defaultValue: '')
  static const String geminiApiKey3 = _AppConstants.geminiApiKey3;

  @EnviedField(varName: 'GEMINI_API_KEY_4', defaultValue: '')
  static const String geminiApiKey4 = _AppConstants.geminiApiKey4;

  @EnviedField(varName: 'GEMINI_API_KEY_5', defaultValue: '')
  static const String geminiApiKey5 = _AppConstants.geminiApiKey5;

  @EnviedField(varName: 'GEMINI_API_KEY_6', defaultValue: '')
  static const String geminiApiKey6 = _AppConstants.geminiApiKey6;

  @EnviedField(varName: 'GEMINI_API_KEY_7', defaultValue: '')
  static const String geminiApiKey7 = _AppConstants.geminiApiKey7;

  @EnviedField(varName: 'GEMINI_API_KEY_8', defaultValue: '')
  static const String geminiApiKey8 = _AppConstants.geminiApiKey8;

  @EnviedField(varName: 'GEMINI_API_KEY_9', defaultValue: '')
  static const String geminiApiKey9 = _AppConstants.geminiApiKey9;

  @EnviedField(varName: 'GEMINI_API_KEY_10', defaultValue: '')
  static const String geminiApiKey10 = _AppConstants.geminiApiKey10;

  @EnviedField(varName: 'GEMINI_API_KEY_11', defaultValue: '')
  static const String geminiApiKey11 = _AppConstants.geminiApiKey11;

  @EnviedField(varName: 'GEMINI_API_KEY_12', defaultValue: '')
  static const String geminiApiKey12 = _AppConstants.geminiApiKey12;

  @EnviedField(varName: 'GEMINI_API_KEY_13', defaultValue: '')
  static const String geminiApiKey13 = _AppConstants.geminiApiKey13;
}
