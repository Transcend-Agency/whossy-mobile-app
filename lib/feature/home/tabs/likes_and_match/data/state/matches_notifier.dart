import 'package:flutter/material.dart';
import 'package:whossy_app/feature/home/tabs/explore/model/liked_user_profile.dart';

import '../repository/matches_repository.dart';

class MatchesNotifier extends ChangeNotifier {
  final _matchesRepository = MatchesRepository();

  Stream<List<LikedUserProfile>> dataStream(List<String>? blockedIds) =>
      _matchesRepository.getMatchesWithProfile(
        blockedIds ?? [],
      );
}
