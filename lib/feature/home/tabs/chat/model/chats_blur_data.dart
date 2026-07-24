import '../../../edit_profile/model/core_profile.dart';
import 'chat_credit_state.dart';

class ChatsBlurData {
  final CoreProfile? user;
  final String userName;
  final ChatCreditState creditState;
  final bool hasMessages;

  ChatsBlurData({
    required this.user,
    required this.userName,
    required this.creditState,
    required this.hasMessages,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatsBlurData &&
        other.user == user &&
        other.userName == userName &&
        other.creditState == creditState &&
        other.hasMessages == hasMessages;
  }

  @override
  int get hashCode => Object.hash(user, userName, creditState, hasMessages);
}
