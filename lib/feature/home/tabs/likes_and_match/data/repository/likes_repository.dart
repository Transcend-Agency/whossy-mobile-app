import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whossy_app/common/utils/app_utils.dart';
import 'package:whossy_app/feature/auth/sign_up/data/repository/user_repository.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

class LikesRepository {
  final _likes = FirebaseFirestore.instance.collection('likes');
  final _dislikes = FirebaseFirestore.instance.collection('dislikes');
  final _matches = FirebaseFirestore.instance.collection('matches');
  final _userRepository = UserRepository();

  Future<String> addLike({
    required String likedId,
    required String likerId,
  }) async {
    final uid = '${likerId}_$likedId';

    // Attempt to remove the dislike (ignores if it doesn't exist)
    try {
      await _dislikes.doc(uid).delete();
    } on FirebaseException catch (e) {
      if (e.code != 'not-found') {
        rethrow;
      }
    }

    await _setLike(uid, likerId, likedId);

    final isMatch = await _checkForMatch(likedId, likerId);

    if (isMatch) {
      await _createMatch(uid, likerId, likedId);
      return 'match';
    }

    return 'like';
  }

  Future<bool> _checkForMatch(String likedId, String likerId) async {
    final existingLikeDoc = await _likes
        .where('uid', isEqualTo: '${likedId}_$likerId')
        .limit(1)
        .get();
    return existingLikeDoc.docs.isNotEmpty;
  }

  Future<void> _createMatch(String uid, String likerId, String likedId) async {
    final matchData = {
      'user_ids': [likerId, likedId],
      'timestamp': FieldValue.serverTimestamp(),
    };
    await _matches.doc(uid).set(matchData);
  }

  Future<void> _setLike(String uid, String likerId, String likedId) async {
    final likeData = {
      'liked_id': likedId,
      'liker_id': likerId,
      'timestamp': FieldValue.serverTimestamp(),
      'uid': uid,
    };
    await _likes.doc(uid).set(likeData);
  }

  Future<void> addDislike({
    required String dislikedId,
    required String dislikerId,
  }) async {
     final uid = '${dislikerId}_$dislikedId';

    // Add the dislike
    final dislikeData = {
      'disliked_id': dislikedId,
      'disliker_id': dislikerId,
      'timestamp': FieldValue.serverTimestamp(),
      'uid': uid,
    };

    await _dislikes.doc(uid).set(dislikeData);
  }

  Stream<List<UserProfile>> getLikersWithProfiles(
    List<String> blockedIds, {
    List<String>? testLikerIds,
  }) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Don't forget to add the exclude settings while testing
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
        settings: const ExcludeSettings(
          excludeIncompleteOnboarding: true,
          excludeBannedUsers: true,
          excludeUnapprovedUsers: false,
          excludeBlockedAndSelf: true,
        ),
      );
    });
  }
}
