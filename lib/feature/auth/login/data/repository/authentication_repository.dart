import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../../common/utils/utils.dart';
import '../../../../../constants/index.dart';
import '../../../sign_up/data/repository/user_repository.dart';
import '../../model/auth_params.dart';
import '../../model/reset_response.dart';

class AuthenticationRepository {
  final _userRepository = UserRepository();

  Future<UserCredential> createUser(String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<ResetResponse> resetPassword(String email) async {
    // Sent without first checking the email is registered: that check ran
    // signed out, which the security rules do not allow, and it told anyone
    // which emails have accounts.
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    return ResetResponse(
      isSuccess: true,
      message: 'If that email has an account, a reset link is on its way',
    );
  }

  /// Logging in must land on an account that has a profile. This runs after
  /// sign-in because the profile can only be read once signed in; a login
  /// Firebase created just now for an unregistered user is removed again so
  /// it does not linger as an empty account.
  Future<void> requireExistingProfile(
    UserCredential? credential, {
    String message = AppStrings.unregisteredEmail,
  }) async {
    if (credential?.user == null) return;
    if (await _userRepository.getUserData() != null) return;

    if (credential!.additionalUserInfo?.isNewUser ?? false) {
      await credential.user!.delete();
    } else {
      await FirebaseAuth.instance.signOut();
    }
    throw UnregisteredEmailException(message);
  }

  Future<UserCredential> handleEmailLogin(String email, String password) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<PhoneAuthCredential?> sendOTPCode(
    String phone,
    void Function(String, String, int?) onSend,
    void Function(String) showSnackbar,
    int? resendingToken,
  ) async {
    PhoneAuthCredential? phoneAuthCredential;

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      forceResendingToken: resendingToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) {
        log('Verification completed $credential');
        phoneAuthCredential = credential;
      },
      verificationFailed: (error) {
        log('Verification failed: $error');
        showSnackbar('An error occurred while attempting to send the code');
      },
      codeSent: (verificationId, forceResendingToken) {
        onSend(phone, verificationId, forceResendingToken);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        log('Auto retrieval timeout');
      },
    );

    return phoneAuthCredential;
  }

  Future<UserCredential?> handlePhoneAuthentication(AuthParams params) async {
    final credential = params.cred ??
        (params.hasIdAndCode
            ? PhoneAuthProvider.credential(
                verificationId: params.id!,
                smsCode: params.code!,
              )
            : null);

    if (credential == null) return null;

    final user = FirebaseAuth.instance.currentUser;

    try {
      return user != null
          ? await user.linkWithCredential(credential)
          : await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
      rethrow;
    }
  }

  Future<UserCredential?> handleGoogleAuthentication(
      {bool isLogin = true}) async {
    final isSignedIn = await GoogleSignIn().isSignedIn();

    if (isSignedIn) await GoogleSignIn().disconnect();

    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await _signInOrLink(credential);
    // Signing up onto an existing profile is refused by setBaseData.
    if (isLogin) await requireExistingProfile(result);
    return result;
  }

  Future<UserCredential> _signInOrLink(AuthCredential credential) async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      return user != null
          ? await user.linkWithCredential(credential)
          : await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked' ||
          e.code == 'credential-already-in-use') {
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        rethrow;
      }
    }
  }

  Future<UserCredential?> handleAppleAuthentication(
      {bool isLogin = true}) async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final credential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final result = await _signInOrLink(credential);
    if (isLogin) await requireExistingProfile(result);
    return result;
  }

  /// Re-authenticate with Google
  Future<bool> reAuthenticateWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      log("Google re-authentication failed: $e");
      return false;
    }
  }

  /// Re-authenticate with Apple
  Future<bool> reAuthenticateWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final credential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      log("Apple re-authentication failed: $e");
      return false;
    }
  }

  /// Re-authenticate with Email & Password
  Future<bool> reAuthenticateWithEmail(String password) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) return false;

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      log("Email re-authentication failed: $e");
      return false;
    }
  }

  /// Get the authentication provider of the current user
  String? getUserAuthProvider() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null || user.providerData.isEmpty) return null;

    String provider = user.providerData.first.providerId;
    log("User signed in with: $provider");
    return provider;
  }
}
