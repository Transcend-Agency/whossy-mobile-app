import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/preferences.dart';

class PreferenceRepository {
  final _prefFirestore = FirebaseFirestore.instance.collection('preferences');

  Future<void> uploadPreferences({required Map<String, dynamic> data}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    await _prefFirestore.doc(uid).set(data, SetOptions(merge: true));
  }

  Future<Preferences?> getPreferences() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final docSnapshot = await _prefFirestore.doc(uid).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();

      if (data != null) return Preferences.fromJson(data);
    }

    return null;
  }
}
