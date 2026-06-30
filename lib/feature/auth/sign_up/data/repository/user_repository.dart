import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:whossy_app/common/utils/app_utils.dart';
import 'package:whossy_app/common/utils/exceptions/failed_upload.dart';

import '../../../../../common/utils/services/services.dart';
import '../../../../../constants/index.dart';
import '../../../../home/tabs/matching/model/user_profile.dart';
import '../../../onboarding/model/face_verification.dart';
import '../../model/app_user.dart';

/// Interacting with the database [Firebase](www.firebase.com) directly
class UserRepository {
  final _users = FirebaseFirestore.instance.collection('users');
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

  Future<void> addUserToken() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    String token = await NotificationService().getToken();

    await _users.doc(userId).update({
      'tokens': FieldValue.arrayUnion([token])
    });
  }

  Future<void> removeUserToken() async {
    await NotificationService().deleteToken().timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        return;
      },
    );
  }

  Future<void> setUserData({required Map<String, dynamic> data}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    try {
      await _users.doc(uid).set(data, SetOptions(merge: true)).timeout(
            const Duration(seconds: 10),
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
    var result = await _users
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

  /// Watches the current user's `face_verification` field, so the app can
  /// react when an admin approves/rejects a submitted selfie (reviewed via
  /// the Retool admin tooling, which writes directly to this document).
  Stream<FaceVerification?> faceVerificationStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return _users.doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;

      return FaceVerification.faceVerificationFromJson(
        data['face_verification'] as Map<String, dynamic>?,
      );
    });
  }

  Future<AppUser?> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final docSnapshot = await _users.doc(uid).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();

      if (data != null) return AppUser.fromJson(data);
    }

    return null;
  }

  Future<List<UserProfile>> getUserProfilesInBatches({
    required List<String> userIds,
    required List<String> blockedIds,
    ExcludeSettings? settings,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    List<UserProfile> profiles = [];

    for (int i = 0; i < userIds.length; i += 10) {
      final batchIds =
          userIds.sublist(i, i + 10 > userIds.length ? userIds.length : i + 10);

      try {
        final userSnapshots =
            await _users.where(FieldPath.documentId, whereIn: batchIds).get();

        // Map Firestore data to `UserProfile` objects
        List<UserProfile> batchProfiles = userSnapshots.docs.map(
          (doc) {
            return UserProfile.fromJson(doc.data());
          },
        ).toList();

        // Don't filter for the blocked screen
        batchProfiles.removeWhere(
          (profile) => AppUtils.excludeProfile(
            profile,
            userId,
            blockedIds,
            settings: settings,
          ),
        );

        profiles.addAll(batchProfiles);
      } catch (e) {
        log('Error processing batch $batchIds: $e');
      }
    }
    return profiles;
  }

  Future<bool> doesEmailExist(String email) async {
    var result = await _users
        .where('email', isEqualTo: email)
        .get(const GetOptions(source: Source.server));

    return result.docs.isNotEmpty;
  }

  Future<List<String>> uploadPictures({
    int timeout = 120,
    required List<File> files,
    required String Function(String?, String) pathGenerator,
  }) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      // Create a list of Future tasks for uploading each file
      final uploadFutures = files.map((file) async {
        final fileName = p.basenameWithoutExtension(file.path);
        final storageRef = _storage.ref().child(pathGenerator(uid, fileName));

        final uploadTask = await storageRef.putFile(file);
        return await uploadTask.ref.getDownloadURL();
      }).toList();

      // Wait for all upload tasks to complete with a 45-second timeout
      return await Future.wait(uploadFutures).timeout(
        Duration(seconds: timeout),
        onTimeout: () {
          throw FailedUploadException(AppStrings.uploadTimeout);
        },
      );
    } catch (e) {
      log(e.toString());
      if (e is FailedUploadException) {
        rethrow;
      }
      throw FailedUploadException(AppStrings.deviceOffline);
    }
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

      // Wait for all upload tasks to complete with a 45-second timeout
      return await Future.wait(uploadFutures).timeout(
        const Duration(minutes: 2),
        onTimeout: () {
          throw FailedUploadException(AppStrings.uploadTimeout);
        },
      );
    } catch (e) {
      log(e.toString());
      if (e is FailedUploadException) {
        rethrow;
      }
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

      // await addUserToken(tokens: appUser?.tokens);

      onAuthenticate();
    } else {
      // Email is not verified, show the Snackbar
      if (showEmailSnackbar != null && userCred != null) {
        showEmailSnackbar(userCred);
      }
    }
  }

  Future<void> deleteUserData(String userId) async {
    try {
      // 🔹 Delete all notifications at once
      final notificationsRef = _users.doc(userId).collection("notifications");

      final notificationsSnap = await notificationsRef.get(
        const GetOptions(source: Source.server),
      );

      final batch = FirebaseFirestore.instance.batch();

      for (var doc in notificationsSnap.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit(); // Commit the batch delete

      // 🔹 Now delete the user document
      await _users.doc(userId).delete();
    } catch (e) {
      log("Error deleting user data: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // Handle sign-out error
      log('Error signing out: $e');

      rethrow;
    }
  }
}
