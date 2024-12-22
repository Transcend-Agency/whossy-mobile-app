import 'current_chat.dart';

class ChatRoomData {
  final CurrentChat currentChat;
  final bool hasViewPermission;

  ChatRoomData({
    required this.currentChat,
    required this.hasViewPermission,
  });
}
