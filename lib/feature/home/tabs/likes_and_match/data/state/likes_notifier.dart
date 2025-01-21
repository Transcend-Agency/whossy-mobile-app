import 'package:flutter/material.dart';
import 'package:whossy_app/feature/home/tabs/explore/model/liked_user_profile.dart';

import '../repository/likes_repository.dart';

class LikesNotifier extends ChangeNotifier {
  final _likesRepository = LikesRepository();

  Stream<List<LikedUserProfile>> dataStream(List<String>? blockedIds) =>
      _likesRepository.getLikersWithProfiles(
        blockedIds ?? [],
      );
}
