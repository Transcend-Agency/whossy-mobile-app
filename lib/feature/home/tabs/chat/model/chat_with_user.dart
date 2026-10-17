import '../../matching/model/user_profile.dart';
import 'chat.dart';

class ChatWithUser {
  final Chat chat;
  final UserProfile? userProfile;

  ChatWithUser({required this.chat, required this.userProfile});
}
