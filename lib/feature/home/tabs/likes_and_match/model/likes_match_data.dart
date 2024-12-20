import '../../../edit_profile/model/core_profile.dart';
import '../../matching/model/user_profile.dart';

class LikesMatchData {
  final Stream<List<UserProfile>> profileStream;
  final CoreProfile user;

  LikesMatchData({
    required this.profileStream,
    required this.user,
  });
}
