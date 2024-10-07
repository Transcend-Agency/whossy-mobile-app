import 'package:flutter/cupertino.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/message.dart';

import '../../../../../../common/utils/services/services.dart';
import '../../../../edit_profile/model/core_profile.dart';
import '../../model/chat.dart';
import '../../model/current_chat.dart';
import '../repository/chat_repository.dart';

class ChatsNotifier extends ChangeNotifier {
  final _sharedPrefs = SharedPrefsService();
  final _chatRepository = ChatRepository();
  bool _hasChatRoomOpened = true;

  CurrentChat? currentChat;
  CoreProfile? _profileData;

  // Getter for the chat stream
  Stream<List<Chat>> get chatStream => _chatRepository.getChatsStream();

  Stream<List<Message>> messagesStream(int limit) => _chatRepository
      .getChatMessagesStream(limit: limit, chatId: currentChat!.chatId!);

  void saveProfile(CoreProfile? data) => _profileData = data;

  String generateChatId(String currentUserUid, String otherUserUid) {
    List<String> userId = [currentUserUid, otherUserUid]..sort();
    return '${userId[0]}_${userId[1]}';
  }

  Future<void> sendMessage(String content) async {
    if (currentChat == null) return;

    final exists = await _chatRepository.doesChatExist(currentChat!.chatId!);

    if (exists) {
      await _chatRepository.sendMessage(
        content,
        chatId: currentChat!.chatId!,
      );
    } else {
      await _chatRepository.createNewChat(
        content,
        currentChat: currentChat!,
        userName: _profileData!.firstName!,
        picUrl: _profileData!.profilePics![0],
      );
    }
  }

  bool get hasChatOpened => _hasChatRoomOpened;

  set hasChatOpened(bool value) {
    if (_hasChatRoomOpened != value) {
      _hasChatRoomOpened = value;

      notifyListeners();
    }
  }

  checkOpenedState() async {
    _hasChatRoomOpened = !await _sharedPrefs.isFirstTimeOpened(ChatRoom.name);
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
