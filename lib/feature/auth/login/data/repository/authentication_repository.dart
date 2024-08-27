import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../common/utils/index.dart';
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
    final auth = FirebaseAuth.instance;

    final emailExists = await _userRepository.doesEmailExist(email);

    if (emailExists) {
      await auth.sendPasswordResetEmail(email: email);

      return ResetResponse(isSuccess: true, message: 'Verification email sent');
    }

    return ResetResponse(
        isSuccess: false, message: 'Email is not registered with the app');
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
      // Link if a user is already signed in, otherwise sign in
      return user != null
          ? await user.linkWithCredential(credential)
          : await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
        // Handle provider-already-linked case
        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
      rethrow;
    }
  }

  Future<UserCredential?> handleGoogleAuthentication(
      {bool isLogin = true}) async {
    final isSignedIn = await GoogleSignIn().isSignedIn();

    if (isSignedIn) await GoogleSignIn().disconnect();

    // Trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null;

    // Obtain the auth details from the request
    final googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Check if the email is registered with the app
    final emailExists = await _userRepository.doesEmailExist(googleUser.email);

    if (emailExists && !isLogin) {
      throw RegisteredEmailException(AppStrings.registeredEmail);
    }

    if (!emailExists && isLogin) {
      throw UnregisteredEmailException(AppStrings.unregisteredEmail);
    }

    final user = FirebaseAuth.instance.currentUser;

    try {
      // Link if a user is already signed in, otherwise sign in
      return user != null
          ? await user.linkWithCredential(credential)
          : await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
        // Sign in with Google credential if provider is already linked
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        // Rethrow the exception if it's not provider-already-linked
        rethrow;
      }
    }
  }

  Future<void> handleFacebookLogin() async {}
}
