import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/app_user.dart';

/// Interacting with the database [Firebase](www.firebase.com) directly
class UserRepository {
  final _usersFirestore = FirebaseFirestore.instance.collection('users');

  Future<UserCredential> createUser(String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
    return null;

    // Logic to fetch user data
  }

  // Update specific fields of user data
  Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await _usersFirestore.doc(uid).set(updatedData, SetOptions(merge: true));
  }
}
