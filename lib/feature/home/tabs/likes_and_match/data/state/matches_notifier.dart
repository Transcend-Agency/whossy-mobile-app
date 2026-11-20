import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whossy_app/common/utils/shared_stream_cache.dart';
import 'package:whossy_app/feature/home/tabs/explore/model/liked_user_profile.dart';

import '../repository/matches_repository.dart';

class MatchesNotifier extends ChangeNotifier {
  final _matchesRepository = MatchesRepository();

  // See LikesNotifier: one shared stream per user and blocked list.
  final _cache = SharedStreamCache<List<LikedUserProfile>>();

  Stream<List<LikedUserProfile>> dataStream(List<String>? blockedIds) {
    final ids = blockedIds ?? const <String>[];
    final key = '${FirebaseAuth.instance.currentUser?.uid}|${ids.join(',')}';
    return _cache.get(key, () => _matchesRepository.getMatchesWithProfile(ids));
  }

  void reset() => _cache.clear();
}
