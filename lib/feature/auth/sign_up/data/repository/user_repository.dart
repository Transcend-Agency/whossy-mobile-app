import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:whossy_mobile_app/feature/auth/login/model/reset_response.dart';

import '../../model/app_user.dart';

/// Interacting with the database [Firebase](www.firebase.com) directly
class UserRepository {
  final _usersFirestore = FirebaseFirestore.instance.collection('users');
  final _storage = FirebaseStorage.instance;

  Future<UserCredential> createUser(String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> loginUser(String email, String password) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> setUserData(AppUser user) async {
    await _usersFirestore.doc(user.uid).set(user.toJson());
  }

  Future<bool> isPhoneUnique(String phone) async {
    var result = await _usersFirestore
        .where('phone_number', isEqualTo: phone)
        .get(const GetOptions(source: Source.server));

    return result.docs.isEmpty;
  }

  Future<AppUser?> getUserData(String uid) async {
    final docSnapshot = await _usersFirestore.doc(uid).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();

      if (data != null) {
        return AppUser.fromJson(data);
      }
    }

    return null;
  }

  Future<ResetResponse> resetPassword(String email) async {
    final auth = FirebaseAuth.instance;

    var result = await _usersFirestore
        .where('email', isEqualTo: email)
        .get(const GetOptions(source: Source.server));

    if (result.docs.isNotEmpty) {
      await auth.sendPasswordResetEmail(email: email);

      return ResetResponse(isSuccess: true, message: 'Verification email sent');
    }

    return ResetResponse(
        isSuccess: false, message: 'Email is not registered with the app');
  }

  // Update specific fields of user data
  Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _usersFirestore.doc(uid).set(updatedData, SetOptions(merge: true));
  }

  // Method to upload files and return download URLs
  Future<List<String>> uploadProfilePictures(List<File> files) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final List<String> downloadUrls = [];

    for (var file in files) {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef =
          _storage.ref().child('users/$uid/profile_pictures/$fileName');
      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }

    return downloadUrls;
  }
}
