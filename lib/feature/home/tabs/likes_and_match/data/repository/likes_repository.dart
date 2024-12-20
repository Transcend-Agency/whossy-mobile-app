import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whossy_app/common/utils/app_utils.dart';
import 'package:whossy_app/feature/auth/sign_up/data/repository/user_repository.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

class LikesRepository {
  final _likes = FirebaseFirestore.instance.collection('likes');
  final _dislikes = FirebaseFirestore.instance.collection('dislikes');
  final _userRepository = UserRepository();

  Future<String> addLike({
    required String likedId,
    required String likerId,
  }) async {
    final uid = AppUtils.generateCombinedId(likerId, likedId);

    final dislikeDoc = await _dislikes.doc(uid).get();

    if (dislikeDoc.exists) {
      await _likes.doc(uid).delete();
    }

    final likeData = {
      'liked_id': likedId,
      'liker_id': likerId,
      'timestamp': FieldValue.serverTimestamp(),
      'uid': uid,
    };

    await _likes.doc(uid).set(likeData);

    return uid;
  }

  Future<void> undoAction({
    required Map<String, dynamic> action,
  }) async {
    String uid = action['uid'];
    String collection = action['collection'];

    // Delete the document from the appropriate collection
    FirebaseFirestore.instance.collection(collection).doc(uid).delete();
  }

  Future<String> addDislike({
    required String dislikedId,
    required String dislikerId,
  }) async {
    final uid = AppUtils.generateCombinedId(dislikerId, dislikedId);

    final likeDoc = await _likes.doc(uid).get();

    if (likeDoc.exists) {
      await _likes.doc(uid).delete();
    }

    // Add the dislike
    final dislikeData = {
      'disliked_id': dislikedId,
      'disliker_id': dislikerId,
      'timestamp': FieldValue.serverTimestamp(),
      'uid': uid,
    };

    await _dislikes.doc(uid).set(dislikeData);

    return uid;
  }

  Stream<List<UserProfile>> getLikersWithProfiles(
    List<String> blockedIds, {
    List<String>? testLikerIds,
  }) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    if (testLikerIds != null) {
      return Stream.value(testLikerIds).asyncMap((likerIds) async {
        return await _userRepository.getUserProfilesInBatches(
          userIds: likerIds,
          blockedIds: blockedIds,
        );
      });
    }

    return _likes
        .where('liked_id', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((likesSnapshot) async {
      final likerIds = likesSnapshot.docs
          .map((doc) => doc['liker_id'] as String)
          .toSet()
          .toList();

      // Use the helper function to fetch profiles in batches
      return await _userRepository.getUserProfilesInBatches(
        userIds: likerIds,
        blockedIds: blockedIds,
      );
    });
  }
}
