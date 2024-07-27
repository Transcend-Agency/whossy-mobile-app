import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/model/preferences.dart';

class PreferenceRepository {
  final _prefFirestore = FirebaseFirestore.instance.collection('preferences');

  Future<void> uploadPreferences(Preferences pref) async {
    final id = FirebaseAuth.instance.currentUser?.uid;

    await _prefFirestore.doc(id).set(pref.toJson());
  }
}
