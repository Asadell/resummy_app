import 'package:envied/envied.dart';

part 'app_constants.g.dart';

@Envied(path: '.env')
class AppConstants {
  @EnviedField(varName: 'GEMINI_API_KEY')
  static const String geminiApiKey = _AppConstants.geminiApiKey;
}
