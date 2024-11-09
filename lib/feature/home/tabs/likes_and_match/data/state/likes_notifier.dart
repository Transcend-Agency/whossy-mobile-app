import 'package:flutter/material.dart';

import '../../../matching/model/user_profile.dart';
import '../repository/likes_repository.dart';

abstract class LikesAndMatch {
  Stream<List<UserProfile>> get profileStream;
}

class LikesNotifier extends ChangeNotifier implements LikesAndMatch {
  final _likesRepository = LikesRepository();

  @override
  Stream<List<UserProfile>> get profileStream =>
      _likesRepository.getLikersWithProfiles();

  Stream<int> get likesCount => _likesRepository.getLikesCount();
}
