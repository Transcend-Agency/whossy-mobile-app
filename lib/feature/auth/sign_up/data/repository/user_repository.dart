import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:whossy_app/common/utils/exceptions/failed_upload.dart';
import 'package:whossy_app/globals.dart';

import '../../model/app_user.dart';

/// Interacting with the database [Firebase](www.firebase.com) directly
class UserRepository {
  final _usersFirestore = FirebaseFirestore.instance.collection('users');
  final _storage = FirebaseStorage.instance;

  Future<void> setUserData({
    String? id,
    required Map<String, dynamic> data,
  }) async {
    // final uid = FirebaseAuth.instance.currentUser?.uid ?? id;

    await _usersFirestore.doc(id).set(data, SetOptions(merge: true));
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
      const message = 'Unable to check, device offline';

      log('Error checking if phone number is unique, '
          'A Firebase Exception occurred ${e.toString()}');

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

  Future<AppUser?> getUserData(String uid) async {
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
      //final uid = FirebaseAuth.instance.currentUser!.uid;
      const uid = testId;

      // Create a list of Future tasks for uploading each file
      final uploadFutures = files.map((file) async {
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final storageRef =
            _storage.ref().child('users/$uid/profile_pictures/$fileName');
        final uploadTask = await storageRef.putFile(file);
        return uploadTask.ref.getDownloadURL();
      }).toList();

      // Wait for all upload tasks to complete and get their download URLs
      final downloadUrls = await Future.wait(uploadFutures);

      return downloadUrls;
    } catch (e) {
      log(e.toString());
      throw FailedUploadException('Poor network, please try again later');
    }
  }
}
