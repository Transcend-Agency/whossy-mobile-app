import 'package:flutter/material.dart';
import 'package:whossy_app/feature/home/tabs/explore/model/liked_user_profile.dart';

import '../repository/likes_repository.dart';

class LikesNotifier extends ChangeNotifier {
  final _likesRepository = LikesRepository();

  /// Stream of users who liked the current user (excluding mutual matches)
  Stream<List<LikedUserProfile>> usersWhoLikedMeStream(
    List<String>? blockedIds,
  ) =>
      _likesRepository.getProfilesOfUsersWhoLikedMe(blockedIds ?? []);

  /// Stream of users the current user has liked (excluding mutual matches)
  Stream<List<LikedUserProfile>> usersILikedStream(List<String>? blockedIds) =>
      _likesRepository.getProfilesOfUsersILiked(blockedIds ?? []);
}
