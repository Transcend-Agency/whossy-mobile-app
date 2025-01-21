import '../../../edit_profile/model/core_profile.dart';
import '../../explore/model/liked_user_profile.dart';

class LikesMatchData {
  final Stream<List<LikedUserProfile>> profileStream;
  final CoreProfile user;

  LikesMatchData({
    required this.profileStream,
    required this.user,
  });
}
