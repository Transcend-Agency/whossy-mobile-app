import 'current_chat.dart';

class ChatRoomData {
  final CurrentChat currentChat;
  final bool hasViewPermission;
  final String currentUserName;

  ChatRoomData({
    required this.currentChat,
    required this.hasViewPermission,
    required this.currentUserName,
  });
}
