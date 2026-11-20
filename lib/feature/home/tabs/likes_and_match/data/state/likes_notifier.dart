import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whossy_app/common/utils/shared_stream_cache.dart';
import 'package:whossy_app/feature/home/tabs/explore/model/liked_user_profile.dart';

import '../repository/likes_repository.dart';

class LikesNotifier extends ChangeNotifier {
  final _likesRepository = LikesRepository();

  // One shared stream per user and blocked list, so a rebuild doesn't
  // re-subscribe and re-fetch every profile. The user is part of the key so
  // a stream opened for one account is never handed to another.
  final _cache = SharedStreamCache<List<LikedUserProfile>>();

  String _key(String kind, List<String> ids) =>
      '${FirebaseAuth.instance.currentUser?.uid}|$kind|${ids.join(',')}';

  /// Stream of users who liked the current user (excluding mutual matches)
  Stream<List<LikedUserProfile>> usersWhoLikedMeStream(
    List<String>? blockedIds,
  ) {
    final ids = blockedIds ?? const <String>[];
    return _cache.get(_key('likedMe', ids),
        () => _likesRepository.getProfilesOfUsersWhoLikedMe(ids));
  }

  /// Stream of users the current user has liked (excluding mutual matches)
  Stream<List<LikedUserProfile>> usersILikedStream(List<String>? blockedIds) {
    final ids = blockedIds ?? const <String>[];
    return _cache.get(
        _key('iLiked', ids), () => _likesRepository.getProfilesOfUsersILiked(ids));
  }

  void reset() => _cache.clear();
}
