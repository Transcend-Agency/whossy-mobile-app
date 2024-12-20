import 'package:flutter/material.dart';

import '../../../matching/model/user_profile.dart';
import '../repository/matches_repository.dart';

class MatchesNotifier extends ChangeNotifier {
  final _matchesRepository = MatchesRepository();

  Stream<List<UserProfile>> dataStream(List<String>? blockedIds) =>
      _matchesRepository.getMatchesWithProfile(
        blockedIds ?? [],
      );
}
