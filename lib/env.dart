import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'NOMBA_CLIENT_ID', obfuscate: true)
  static String nombaClientId = _Env.nombaClientId;

  @EnviedField(varName: 'NOMBA_CLIENT_SECRET', obfuscate: true)
  static String nombaClientSecret = _Env.nombaClientSecret;

  @EnviedField(varName: 'NOMBA_ACCOUNT_ID', obfuscate: true)
  static String nombaAccountId = _Env.nombaAccountId;

  @EnviedField(varName: 'PAYSTACK_SECRET_KEY_NGN', obfuscate: true)
  static String paystackSecretKeyNgn = _Env.paystackSecretKeyNgn;

  @EnviedField(varName: 'PAYSTACK_SECRET_KEY_KES', obfuscate: true)
  static String paystackSecretKeyKes = _Env.paystackSecretKeyKes;

  @EnviedField(varName: 'PAYMENT_CALLBACK_URL', obfuscate: true)
  static String paymentCallbackUrl = _Env.paymentCallbackUrl;
}
