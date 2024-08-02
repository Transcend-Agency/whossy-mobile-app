import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import '../../../sign_up/data/repository/user_repository.dart';
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

  Future<void> sendOTPCode(
    String phone,
    void Function(String, String) onSend,
    void Function(String) showSnackbar,
  ) async {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (phoneAuthCredential) {
        log('Verification completed $phoneAuthCredential');
      },
      verificationFailed: (error) {
        log('Verification failed$error');
        showSnackbar('An error occurred while attempting to send code');
      },
      codeSent: (verificationId, forceResendingToken) {
        onSend(phone, verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        log('Auto retrieval timeout');
      },
    );
  }

  Future<UserCredential?> handlePhoneAuthentication(
      String id, String code) async {
    final credential =
        PhoneAuthProvider.credential(verificationId: id, smsCode: code);

    final user = FirebaseAuth.instance.currentUser;

    // Link up
    if (user != null) return await user.linkWithCredential(credential);

    // Sign in with phone credential
    return await FirebaseAuth.instance.signInWithCredential(credential);
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
      // Link up
      if (user != null) {
        return await user.linkWithCredential(credential);
      }

      // Sign in with Google credential
      return await FirebaseAuth.instance.signInWithCredential(credential);
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

  Future<void> handleFacebookLogin() async {
    final auth = FacebookAuth.instance;

    final result = await auth.login(loginTracking: LoginTracking.enabled);

    if (result.status == LoginStatus.success) {
      // you are logged
      final accessToken = result.accessToken!;

      // get user data
      final userData = await FacebookAuth.instance.getUserData();

      log('Facebook user data $userData');
      log('Facebook access token $accessToken');

      // debugPrint("face book login user data: ${prettyPrint(userData)}");
      // userModel.userId = accessToken.userId;
      // userModel.email = userData["email"];
      // final Map<String, dynamic> picture =
      //     Map<String, dynamic>.from(userData["picture"]);
      // final Map<String, dynamic> data =
      //     Map<String, dynamic>.from(picture["data"]);
      // userModel.avatar = data["url"];
      // userModel.firstName = userData["name"];
      // userModel.token = accessToken.token;
      // userModel.loginType = loginFacebook;
      // userModel.isFacebook = true;
      // getSocial(context, userModel.token, true);
    } else {
      log(result.status.toString());
      debugPrint(result.message);
    }
  }
}
