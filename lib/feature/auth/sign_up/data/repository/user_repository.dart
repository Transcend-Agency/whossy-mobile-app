import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:whossy_app/common/utils/exceptions/failed_upload.dart';
import 'package:whossy_app/common/utils/services/notification_service.dart';

import '../../../../../constants/index.dart';
import '../../model/app_user.dart';

/// Interacting with the database [Firebase](www.firebase.com) directly
class UserRepository {
  final _usersFirestore = FirebaseFirestore.instance.collection('users');
  final _storage = FirebaseStorage.instance;

  Future<bool> didUserCreateWithPhoneNumber() async {
    try {
      User user = FirebaseAuth.instance.currentUser!;

      for (var provider in user.providerData) {
        if (provider.providerId == 'phone') {
          return true;
        }
      }
    } catch (e) {
      log('Error checking if user signed in with phone number: ${e.toString()}');
    }
    return false;
  }

  Future<void> deleteUserToken() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    String token = await NotificationService().getToken();

    await _usersFirestore.doc(userId).update({
      'tokens': FieldValue.arrayRemove([token])
    });

    await NotificationService().deleteToken();

    log('Deleted token $token');
  }

  Future<void> addUserToken({List<String>? tokens}) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    String token = await NotificationService().getToken();

    if (tokens != null && tokens.contains(token)) {
      log('Token $token already exists for user $userId');
      return;
    }

    await _usersFirestore.doc(userId).update({
      'tokens': FieldValue.arrayUnion([token])
    });

    log('Added token $token for user $userId');
  }

  Future<void> setUserData({required Map<String, dynamic> data}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    try {
      await _usersFirestore.doc(uid).set(data, SetOptions(merge: true)).timeout(
            const Duration(seconds: 5),
            onTimeout: () =>
                throw TimeoutException('The upload operation timed out'),
          );
    } on TimeoutException catch (e) {
      log("Timeout: ${e.message}");
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isPhoneUnique(String phone) async {
    var result = await _usersFirestore
        .where('phone_number', isEqualTo: phone)
        .get(const GetOptions(source: Source.server));

    return result.docs.isEmpty;
  }

  Future<Map<String, dynamic>> checkPhone(
    String phone, {
    bool exists = false,
  }) async {
    try {
      bool isEmpty = await isPhoneUnique(phone);

      return {
        'isEmpty': exists ? !isEmpty : isEmpty,
      };
    } on FirebaseException catch (e) {
      String message = AppStrings.deviceOffline;

      log('Error checking if phone number is unique, '
          'A Firebase Exception occurred ${e.toString()}');

      if (e.code == 'permission-denied') {
        message = AppStrings.permissionDeniedPhoneCheck;
      }
      return {
        'message': message,
      };
    } catch (e) {
      log('Error checking for unique phone number ${e.toString()}');
    }
    return {
      'message': 'Oops, an unknown error occurred',
    };
  }

  Future<AppUser?> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final docSnapshot = await _usersFirestore.doc(uid).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();

      if (data != null) return AppUser.fromJson(data);
    }

    return null;
  }

  Future<bool> doesEmailExist(String email) async {
    var result = await _usersFirestore
        .where('email', isEqualTo: email)
        .get(const GetOptions(source: Source.server));

    return result.docs.isNotEmpty;
  }

  Future<List<String>> uploadProfilePictures(List<File> files) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      // Create a list of Future tasks for uploading each file
      final uploadFutures = files.map((file) async {
        final fileName = p.basenameWithoutExtension(file.path);
        final storageRef =
            _storage.ref().child(AppStrings.profilePicsPath(uid, fileName));
        final uploadTask = await storageRef.putFile(file);
        return uploadTask.ref.getDownloadURL();
      }).toList();

      // Wait for all upload tasks to complete and get their download URLs
      return await Future.wait(uploadFutures);
    } catch (e) {
      log(e.toString());
      throw FailedUploadException(AppStrings.deviceOffline);
    }
  }

  Future<void> accountCheck({
    User? user,
    bool showIfNull = false,
    bool disableEmailCheck = false,
    bool enablePhoneCheck = false,
    required void Function(String) showSnackbar,
    required VoidCallback onAuthenticate,
    required VoidCallback toCreateAccount,
    required VoidCallback toOnboarding,
    void Function(UserCredential)? showEmailSnackbar,
    UserCredential? userCred,
  }) async {
    if (user == null) {
      if (showIfNull) showSnackbar(AppStrings.errorUnknown);
      return;
    }

    if (enablePhoneCheck) {
      disableEmailCheck = await didUserCreateWithPhoneNumber();
    }

    if (user.emailVerified || disableEmailCheck) {
      final appUser = await getUserData();

      if (appUser != null) {
        if (!appUser.hasCompletedAccountCreation) {
          toCreateAccount();
          return;
        }

        if (!appUser.hasCompletedOnboarding) {
          toOnboarding();
          return;
        }
      }

      await addUserToken(tokens: appUser?.tokens);

      onAuthenticate();
    } else {
      // Email is not verified, show the Snackbar
      if (showEmailSnackbar != null && userCred != null) {
        showEmailSnackbar(userCred);
      }
    }
  }
}
