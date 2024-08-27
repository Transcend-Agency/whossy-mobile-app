import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/core_preferences.dart';

class PreferencesRepository {
  final _filtersFirestore = FirebaseFirestore.instance.collection('filters');

  Future<CorePreferences?> fetchFilters() async {
    // final uid = FirebaseAuth.instance.currentUser!.uid;

    const uid = "Ay2YNO2JnYePExiVo7AMarkupE22";

    final filtersSnapshot = await _filtersFirestore.doc(uid).get();

    if (filtersSnapshot.exists) {
      final data = filtersSnapshot.data();

      if (data != null) return CorePreferences.fromJson(data);
    }

    return null;
  }
}
