import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../matching/model/user_profile.dart';
import '../../model/liked_user_profile.dart';
import '../../model/user_search_result.dart';

/// Global name search on Explore. The search itself runs in the
/// `searchUsers` Cloud Function, which applies the visibility rules (banned,
/// unapproved, Public search off, blocks) and the rate limit.
class UserSearchRepository {
  UserSearchRepository({
    FirebaseFunctions? functions,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _functions = functions ?? FirebaseFunctions.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFunctions _functions;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<List<UserSearchResult>> search(String query) async {
    final response = await _functions
        .httpsCallable('searchUsers')
        .call<Map<String, dynamic>>({'query': query});
    final results = (response.data['results'] as List?) ?? const [];
    return results
        .map((r) => UserSearchResult.fromJson(Map<String, dynamic>.from(r as Map)))
        .toList();
  }

  /// The full profile behind a result, for the profile preview, and whether
  /// the viewer has already liked them. Null if the profile is gone.
  Future<LikedUserProfile?> openProfile(String uid) async {
    final me = _auth.currentUser?.uid;
    final profileSnap = await _firestore.collection('users').doc(uid).get();
    final data = profileSnap.data();
    if (data == null) return null;

    var isLiked = false;
    if (me != null) {
      final like = await _firestore.collection('likes').doc('${me}_$uid').get();
      isLiked = like.exists;
    }
    return LikedUserProfile(profile: UserProfile.fromJson(data), isLiked: isLiked);
  }
}
