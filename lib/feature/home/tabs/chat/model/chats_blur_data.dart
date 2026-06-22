import '../../../edit_profile/model/core_profile.dart';

class ChatsBlurData {
  final CoreProfile? user;
  final String userName;
  final bool hasChatExpired;
  final bool isMutualMatch;

  ChatsBlurData({
    required this.user,
    required this.userName,
    required this.hasChatExpired,
    required this.isMutualMatch,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatsBlurData &&
        other.user == user &&
        other.userName == userName &&
        other.hasChatExpired == hasChatExpired &&
        other.isMutualMatch == isMutualMatch;
  }

  @override
  int get hashCode =>
      Object.hash(user, userName, hasChatExpired, isMutualMatch);
}
