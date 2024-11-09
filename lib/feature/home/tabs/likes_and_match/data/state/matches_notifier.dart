import 'package:flutter/material.dart';

import '../../../matching/model/user_profile.dart';
import '../repository/matches_repository.dart';
import 'likes_notifier.dart';

class MatchesNotifier extends ChangeNotifier implements LikesAndMatch {
  final _matchesRepository = MatchesRepository();

  @override
  Stream<List<UserProfile>> get profileStream =>
      _matchesRepository.getMatchesWithProfile();

  Stream<int> get matchesCount => _matchesRepository.getMatchesCount();
}
