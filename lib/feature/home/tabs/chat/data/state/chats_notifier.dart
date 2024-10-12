import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/message.dart';

import '../../../../../../common/utils/services/services.dart';
import '../../../../edit_profile/model/core_profile.dart';
import '../../model/chat.dart';
import '../../model/current_chat.dart';
import '../repository/chat_repository.dart';

class ChatsNotifier extends ChangeNotifier {
  // Internal services and repository
  final _sharedPrefs = SharedPrefsService();
  final _chatRepository = ChatRepository();
  final _fileService = FileService();

  // Variables to manage state
  CurrentChat? currentChat;
  CoreProfile? _profileData;
  bool _hasChatRoomOpened = true;

  bool _isUserConnected = false;

  Timer? _uploadTimeout;
  // Upload related variables
  double _progress = 0.0;
  bool isUploading = false;
  bool _hasUploadFailed = false;

  double get progress => _progress;
  bool get hasUploadFailed => _hasUploadFailed;

  set progress(double value) {
    _progress = value;
    notifyListeners();
  }

  set hasUploadFailed(bool value) {
    _hasUploadFailed = value;
    notifyListeners();
  }

  // Chat stream getter
  Stream<List<Chat>> get chatStream => _chatRepository.getChatsStream();

  // Manage the opened chat room state
  bool get hasChatOpened => _hasChatRoomOpened;

  set hasChatOpened(bool value) {
    if (_hasChatRoomOpened != value) {
      _hasChatRoomOpened = value;
      notifyListeners();
    }
  }

  void saveProfile(CoreProfile? data) => _profileData = data;
  void updateConnectivity(bool isConnected) => _isUserConnected = isConnected;

  /// -------------------------
  /// Chat Management Methods
  /// -------------------------

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

  /// Fetches messages from the chat repository based on the chat ID
  Stream<List<Message>> messagesStream(int limit) => _chatRepository
      .getChatMessagesStream(limit: limit, chatId: currentChat!.chatId!);

  /// Sends a message with optional attached pictures
  Future<void> sendMessage(String content, {List<XFile>? pictures}) async {
    if (currentChat == null) return;

    final exists = await _chatRepository.doesChatExist(currentChat!.chatId!);

    if (exists) {
      await _chatRepository.sendMessage(
        content,
        chatId: currentChat!.chatId!,
        pictures: pictures,
        isConnected: _isUserConnected,
      );
    } else {
      await _chatRepository.createNewChat(
        content,
        pictures: pictures,
        currentChat: currentChat!,
        isConnected: _isUserConnected,
        userName: _profileData!.firstName!,
        picUrl: _profileData!.profilePics![0],
      );
    }
  }

  /// Checks if the chat room has been opened for the first time
  Future<void> checkOpenedState() async {
    _hasChatRoomOpened = !await _sharedPrefs.isFirstTimeOpened(ChatRoom.name);
  }

  /// -------------------------
  /// File Uploading Methods
  /// -------------------------

  Future<void> uploadFile({
    required String localPhotoPath,
    required String id,
  }) async
  // lb
  {
    // Check if already uploading this file
    if (!_fileService.isUploading(localPhotoPath)) {
      isUploading = true;
      hasUploadFailed = false;

      try {
        // Set a 30-second timeout for the upload operation
        _uploadTimeout = Timer(const Duration(seconds: 30), () {
          isUploading = false;
          hasUploadFailed = true;
        });

        // Start uploading the file
        await _fileService.uploadImagesInBackground(
          chatId: currentChat!.chatId!,
          messageId: id,
          localPaths: [localPhotoPath],
          onProgress: (localPath, progress) {
            this.progress = progress;
          },
        );

        // If upload succeeds before timeout, cancel the timeout and reset states
        _uploadTimeout?.cancel();
        isUploading = false;
        hasUploadFailed = false;
      } catch (e) {
        // Handle upload failure (e.g., network error)
        isUploading = false;
        hasUploadFailed = true;
        log('Error uploading file: ${e.toString()}');
      }
    }
  }

  Future<void> retryUpload(String id, String localPhotoPath) async {
    await uploadFile(id: id, localPhotoPath: localPhotoPath);
  }
}
