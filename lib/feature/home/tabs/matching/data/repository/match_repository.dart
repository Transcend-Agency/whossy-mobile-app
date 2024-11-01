import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

class MatchRepository {
  final _profiles = FirebaseFirestore.instance.collection('users');

  Future<Map<String, dynamic>> fetchProfiles({
    int limit = 10,
    DocumentSnapshot? lastDoc,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Query to exclude your own profile
    Query query = _profiles
        .where('uid', isNotEqualTo: uid)
        .orderBy('first_name')
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }
    final querySnapshot = await query.get();

    final userProfiles = querySnapshot.docs
        .map((doc) => UserProfile.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    final lastDocument =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

    return {
      'profiles': userProfiles,
      'lastDoc': lastDocument,
    };
  }
}
