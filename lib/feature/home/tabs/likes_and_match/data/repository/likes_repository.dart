import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whossy_app/feature/auth/sign_up/data/repository/user_repository.dart';

import '../../../../../../common/utils/index.dart';
import '../../../explore/model/liked_user_profile.dart';

class LikesRepository {
  final _likes = FirebaseFirestore.instance.collection('likes');
  final _dislikes = FirebaseFirestore.instance.collection('dislikes');
  final _matches = FirebaseFirestore.instance.collection('matches');
  final _userRepository = UserRepository();

  final excludeSettings = const ExcludeSettings(
    excludeIncompleteOnboarding: true,
    excludeBannedUsers: true,
    excludeUnapprovedUsers: false,
    excludeBlockedAndSelf: true,
  );

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

  Stream<List<LikedUserProfile>> getLikersWithProfiles(
    List<String> blockedIds,
  ) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Stream of likers (users who liked the current user)
    final likersStream = _likes
        .where('liked_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc['liker_id'] as String).toSet());

    // Stream of liked users (users that the current user liked)
    final likedStream = _likes
        .where('liker_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc['liked_id'] as String).toSet());

    // Combine the two streams to get likerIds and likedIds
    final combinedIdsStream = Rx.combineLatest2(
      likersStream,
      likedStream,
      (likerIds, likedIds) => {
        'likerIds': likerIds,
        'likedIds': likedIds,
      },
    );

    // Use asyncMap to handle the async profile fetching
    return combinedIdsStream.asyncMap(
      (idsMap) async {
        final likerIds = idsMap['likerIds']!;
        final likedIds = idsMap['likedIds']!;

        // Exclude mutual likes
        final filteredLikerIds = likerIds.difference(likedIds);

        // Fetch the profiles of users who liked the current user (excluding mutual likes)
        final allProfiles = await _userRepository.getUserProfilesInBatches(
          userIds: filteredLikerIds.toList(),
          blockedIds: blockedIds,
          settings: excludeSettings,
        );

        return allProfiles
            .map(
              (profile) => LikedUserProfile(
                profile: profile,
                isLiked: false,
              ),
            )
            .toList();
      },
    );
  }
}
