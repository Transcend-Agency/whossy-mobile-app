import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whossy_app/common/utils/app_utils.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

class LikesRepository {
  final _likes = FirebaseFirestore.instance.collection('likes');
  final _dislikes = FirebaseFirestore.instance.collection('dislikes');
  final _users = FirebaseFirestore.instance.collection('users');

  Future<void> addLike({
    required String likedId,
    required String likerId,
  }) async {
    final uid = AppUtils.generateCombinedId(likerId, likedId);

    final likeData = {
      'liked_id': likedId,
      'liker_id': likerId,
      'timestamp': FieldValue.serverTimestamp(),
      'uid': uid,
    };

    await _likes.doc(uid).set(likeData);
  }

  Future<void> removeLike({
    required String likedId,
    required String likerId,
  }) async {
    final uid = AppUtils.generateCombinedId(likerId, likedId);
    await _likes.doc(uid).delete();
  }

  Future<void> addDislike({
    required String dislikedId,
    required String dislikerId,
  }) async {
    final uid = AppUtils.generateCombinedId(dislikerId, dislikedId);

    final dislikeData = {
      'disliked_id': dislikedId,
      'disliker_id': dislikerId,
      'timestamp': FieldValue.serverTimestamp(),
      'uid': uid,
    };

    await _dislikes.doc(uid).set(dislikeData);
  }

  Future<void> removeDislike({
    required String dislikedId,
    required String dislikerId,
  }) async {
    final uid = AppUtils.generateCombinedId(dislikerId, dislikedId);
    await _dislikes.doc(uid).delete();
  }

  Stream<int> getLikesCount() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return _likes
        .where('liked_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }


  Stream<List<UserProfile>> getLikersWithProfiles() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return _likes
        .where('liked_id', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((likesSnapshot) async {
      final likerIds = likesSnapshot.docs
          .map((doc) => doc['liker_id'] as String)
          .toSet()
          .toList();

      List<UserProfile> likersProfiles = [];

      for (int i = 0; i < likerIds.length; i += 10) {
        final batchIds = likerIds.sublist(
            i, i + 10 > likerIds.length ? likerIds.length : i + 10);
        final userSnapshots =
            await _users.where(FieldPath.documentId, whereIn: batchIds).get();
        likersProfiles.addAll(
            userSnapshots.docs.map((doc) => UserProfile.fromJson(doc.data())));
      }

      return likersProfiles;
    });
  }
}
