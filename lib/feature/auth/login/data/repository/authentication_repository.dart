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

  Future<UserCredential?> handleGoogleLogin() async {
    final isSignedIn = await GoogleSignIn().isSignedIn();

    if (isSignedIn) {
      await GoogleSignIn().disconnect();
    }

    // Trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // User canceled the Google sign-in
      return null;
    }

    // Obtain the auth details from the request
    final googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Check if the email associated with the Google account is already registered
    final email = googleUser.email;

    // Check if the email is registered with the app
    final emailExists = await _userRepository.doesEmailExist(email);

    if (!emailExists) {
      throw UnregisteredEmailException(AppStrings.unregisteredEmail);
    }

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> handleFacebookLogin() async {
    final auth = FacebookAuth.instance;

    final result = await auth.login();

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
