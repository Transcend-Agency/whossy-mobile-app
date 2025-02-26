import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'NOMBA_CLIENT_ID')
  static String nombaClientId = _Env.nombaClientId;

  @EnviedField(varName: 'NOMBA_CLIENT_SECRET')
  static String nombaClientSecret = _Env.nombaClientSecret;

  @EnviedField(varName: 'NOMBA_ACCOUNT_ID')
  static String nombaAccountId = _Env.nombaAccountId;

  @EnviedField(varName: 'PAYSTACK_SECRET_KEY_NGN')
  static String paystackSecretKeyNgn = _Env.paystackSecretKeyNgn;

  @EnviedField(varName: 'PAYSTACK_SECRET_KEY_KES')
  static String paystackSecretKeyKes = _Env.paystackSecretKeyKes;

  @EnviedField(varName: 'PAYMENT_CALLBACK_URL')
  static String paymentCallbackUrl = _Env.paymentCallbackUrl;

  @EnviedField(varName: "PAYSTACK_PLAN_CODE_NGN_MONTHLY")
  static String paystackPlanCodeNgnMonthly = _Env.paystackPlanCodeNgnMonthly;

  @EnviedField(varName: "PAYSTACK_PLAN_CODE_NGN_3_MONTHS")
  static String paystackPlanCodeNgn3Months = _Env.paystackPlanCodeNgn3Months;

  @EnviedField(varName: "PAYSTACK_PLAN_CODE_NGN_6_MONTHS")
  static String paystackPlanCodeNgn6Months = _Env.paystackPlanCodeNgn6Months;

  @EnviedField(varName: "PAYSTACK_PLAN_CODE_NGN_YEARLY")
  static String paystackPlanCodeNgnYearly = _Env.paystackPlanCodeNgnYearly;
}
