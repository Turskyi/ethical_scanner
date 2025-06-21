import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'OPEN_AI_API_KEY')
  static const String openAiApiKey = _Env.openAiApiKey;
  @EnviedField(varName: 'OPEN_FOOD_USER_ID')
  static const String openFoodUserId = _Env.openFoodUserId;
  @EnviedField(varName: 'OPEN_FOOD_BACKUP_USER_ID')
  static const String openFoodBackupUserId = _Env.openFoodBackupUserId;
  @EnviedField(varName: 'OPEN_FOOD_PASSWORD')
  static const String openFoodPassword = _Env.openFoodPassword;
}
