import 'package:firebase_auth/firebase_auth.dart';

class AuthParams {
  final String? id;
  final String? code;
  final PhoneAuthCredential? cred;

  AuthParams.withCredential(this.cred)
      : id = null,
        code = null,
        assert(cred != null);

  AuthParams.withIdAndCode(this.id, this.code)
      : cred = null,
        assert(id != null && code != null);

  bool get hasCredential => cred != null;
  bool get hasIdAndCode => id != null && code != null;
}
