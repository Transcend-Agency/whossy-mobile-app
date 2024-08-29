import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/preferences.dart';

class PreferenceRepository {
  final _prefFirestore = FirebaseFirestore.instance.collection('preferences');

  Future<void> uploadPreferences({
    String? uid,
    required Map<String, dynamic> data,
  }) async {
    await _prefFirestore.doc(uid).set(data, SetOptions(merge: true));
  }

  Future<Preferences?> getPreferences(String id) async {
    final docSnapshot = await _prefFirestore.doc(id).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();

      if (data != null) return Preferences.fromJson(data);
    }

    return null;
  }
}
