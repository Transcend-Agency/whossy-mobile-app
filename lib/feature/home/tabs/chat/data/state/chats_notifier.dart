import 'package:flutter/cupertino.dart';

import '../../model/chat.dart';
import '../../model/current_chat.dart';
import '../repository/chat_repository.dart';

class ChatsNotifier extends ChangeNotifier {
  final _chatRepository = ChatRepository();

  // Getter for the chat stream
  Stream<List<Chat>> get chatStream => _chatRepository.getChatsStream();

  CurrentChat? currentChat;

  String generateChatId(String currentUserUid, String otherUserUid) {
    List<String> userId = [currentUserUid, otherUserUid]..sort();
    return '${userId[0]}_${userId[1]}';
  }

  void setCurrentChat({
    required String username,
    required String uidUser1,
    required String uidUser2,
    String? profilePicUrl,
    int? oppIndex,
    bool? isDeleted,
    bool? isBlocked,
  }) {
    final chatId = generateChatId(uidUser1, uidUser2);

    currentChat = CurrentChat(
      chatId: chatId,
      username: username,
      uidUser1: uidUser1,
      uidUser2: uidUser2,
      profilePicUrl: profilePicUrl,
      oppIndex: oppIndex,
      isBlocked: isBlocked ?? false,
    );

    notifyListeners();
  }
}
