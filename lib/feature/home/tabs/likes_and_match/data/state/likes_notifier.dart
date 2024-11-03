import 'package:flutter/material.dart';

import '../../../matching/model/user_profile.dart';
import '../repository/likes_repository.dart';

class LikesNotifier extends ChangeNotifier {
  final _likesRepository = LikesRepository();

  Stream<List<UserProfile>> get likesStream =>
      _likesRepository.getLikersWithProfiles();

  Stream<int> get likesCount => _likesRepository.getLikesCount();
}
