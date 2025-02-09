import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env') // Specify the path to your .env file
abstract class Env {
  @EnviedField(varName: 'NOMBA_CLIENT_ID', obfuscate: true)
  static String nombaClientId = _Env.nombaClientId;

  @EnviedField(varName: 'NOMBA_CLIENT_SECRET', obfuscate: true)
  static String nombaClientSecret = _Env.nombaClientSecret;

  @EnviedField(varName: 'NOMBA_ACCOUNT_ID', obfuscate: true)
  static String nombaAccountId = _Env.nombaAccountId;
}
