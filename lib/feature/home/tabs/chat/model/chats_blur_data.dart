import '../../../edit_profile/model/core_profile.dart';

class ChatsBlurData {
  final CoreProfile? user;
  final String userName;
  final bool hasChatExpired;

  ChatsBlurData({
    required this.user,
    required this.userName,
    required this.hasChatExpired,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatsBlurData &&
        other.user == user &&
        other.userName == userName &&
        other.hasChatExpired == hasChatExpired;
  }

  @override
  int get hashCode => Object.hash(user, userName, hasChatExpired);
}
