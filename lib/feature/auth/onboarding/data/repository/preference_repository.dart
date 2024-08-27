import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/preferences.dart';

class PreferenceRepository {
  final _prefFirestore = FirebaseFirestore.instance.collection('preferences');

  Future<void> uploadPreferences(Preferences pref) async {
    final id = FirebaseAuth.instance.currentUser?.uid;

    await _prefFirestore.doc(id).set(pref.toJson(), SetOptions(merge: true));
  }
}
