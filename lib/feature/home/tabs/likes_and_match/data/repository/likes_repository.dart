import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whossy_app/feature/auth/sign_up/data/repository/user_repository.dart';

import '../../../../../../common/utils/utils.dart';
import '../../../explore/model/liked_user_profile.dart';

class LikesRepository {
  LikesRepository({FirebaseFirestore? firestore})
      : _likes = (firestore ?? FirebaseFirestore.instance).collection('likes'),
        _dislikes =
            (firestore ?? FirebaseFirestore.instance).collection('dislikes');

  final CollectionReference<Map<String, dynamic>> _likes;
  final CollectionReference<Map<String, dynamic>> _dislikes;
  late final _userRepo = UserRepository();

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

    // A like is written once: the rules refuse to overwrite one (each like
    // sends a notification and counts toward popularity), so writing it
    // again fails. A second tap, for example from a like notification
    // opened after liking back, just reports where things stand.
    if (await hasLiked(likerId: likerId, likedId: likedId)) {
      return await _likedMeBack(likedId, likerId) ? 'match' : 'like';
    }

    // Attempt to remove the dislike (ignores if it doesn't exist)
    try {
      await _dislikes.doc(uid).delete();
    } on FirebaseException catch (e) {
      if (e.code != 'not-found') {
        rethrow;
      }
    }

    await _setLike(uid, likerId, likedId);

    // Only to tell the user it is a match. The match document itself is
    // written by the server from the two likes.
    return await _likedMeBack(likedId, likerId) ? 'match' : 'like';
  }

  /// Whether [likerId] has already liked [likedId]. Read by id, which the
  /// rules allow for either party and for a like that does not exist.
  Future<bool> hasLiked({
    required String likerId,
    required String likedId,
  }) async {
    final like = await _likes.doc('${likerId}_$likedId').get();
    return like.exists;
  }

  // Read by id: the rules only let a user query likes on their own
  // liker_id/liked_id, and a lookup by id is allowed for either party.
  Future<bool> _likedMeBack(String likedId, String likerId) async {
    final theirLike = await _likes.doc('${likedId}_$likerId').get();
    return theirLike.exists;
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

  Stream<List<LikedUserProfile>> getProfilesOfUsersWhoLikedMe(
      List<String> blockedIds) {
    return _getFilteredProfiles(
      myUserId: FirebaseAuth.instance.currentUser!.uid,
      primaryFilter: 'liked_id', // Users who liked me
      secondaryFilter: 'liker_id', // Users I liked
      blockedIds: blockedIds,
      markAsLiked: false, // Since they liked me
    );
  }

  Stream<List<LikedUserProfile>> getProfilesOfUsersILiked(
      List<String> blockedIds) {
    return _getFilteredProfiles(
      myUserId: FirebaseAuth.instance.currentUser!.uid,
      primaryFilter: 'liker_id', // Users I liked
      secondaryFilter: 'liked_id', // Users who liked me
      blockedIds: blockedIds,
      markAsLiked: true, // Since I liked them
    );
  }

  /// Fetches user profiles while excluding mutual matches
  Stream<List<LikedUserProfile>> _getFilteredProfiles({
    required String myUserId,
    required String primaryFilter,
    required String secondaryFilter,
    required List<String> blockedIds,
    required bool markAsLiked,
  }) {
    // Stream of primary filtered users
    final primaryStream = _likes
        .where(primaryFilter, isEqualTo: myUserId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc[secondaryFilter] as String).toSet());

    // Stream of secondary filtered users
    final secondaryStream = _likes
        .where(secondaryFilter, isEqualTo: myUserId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc[primaryFilter] as String).toSet());

    // Combine both streams
    final combinedIdsStream = Rx.combineLatest2(
      primaryStream,
      secondaryStream,
      (primaryIds, secondaryIds) => {
        'primaryIds': primaryIds,
        'secondaryIds': secondaryIds,
      },
    );

    return combinedIdsStream.asyncMap(
      (idsMap) async {
        final primaryIds = idsMap['primaryIds']!;
        final secondaryIds = idsMap['secondaryIds']!;

        // Exclude mutual matches
        final filteredIds = primaryIds.difference(secondaryIds);

        // Fetch user profiles
        final profiles = await _userRepo.getUserProfilesInBatches(
          userIds: filteredIds.toList(),
          blockedIds: blockedIds,
          settings: excludeSettings,
        );

        return profiles
            .map((profile) =>
                LikedUserProfile(profile: profile, isLiked: markAsLiked))
            .toList();
      },
    );
  }
}
