import '../../matching/model/user_profile.dart';

class LikedUserProfile {
  final UserProfile profile;
  final bool isLiked;

  LikedUserProfile({
    required this.profile,
    required this.isLiked,
  });
}
