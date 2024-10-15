import 'dart:async';
import 'dart:collection';
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

  final Queue<List<String>> _uploadQueue = Queue();
  bool _isProcessingQueue = false;

  // Variables to manage state
  CurrentChat? currentChat;
  CoreProfile? _profileData;
  bool _hasChatRoomOpened = true;

  bool _isUserConnected = false;
  Timer? _uploadTimeout;

  // Updated variables to manage upload states for multiple files
  List<double> _progressList = [];
  List<bool> _isUploadingList = [];
  List<bool> _hasUploadFailedList = [];

  // Getters for the updated lists
  List<double> get progressList => _progressList;
  List<bool> get hasUploadFailedList => _hasUploadFailedList;
  List<bool> get isUploadingList => _isUploadingList;

  // Update progress for a specific image
  void updateProgress(int index, double value) {
    if (index >= 0 && index < _progressList.length) {
      _progressList[index] = value;
      notifyListeners();
    }
  }

  void setUploading(int index, bool value) {
    if (index >= 0 && index < _isUploadingList.length) {
      _isUploadingList[index] = value;
      notifyListeners();
    }
  }

  void setUploadFailed(int index, bool value) {
    if (index >= 0 && index < _hasUploadFailedList.length) {
      _hasUploadFailedList[index] = value;
      notifyListeners();
    }
  }

  // Method to initialize upload states for a list of images
  void initializeUploadStates(int count) {
    _progressList = List<double>.filled(count, 0.0);
    _isUploadingList = List<bool>.filled(count, false);
    _hasUploadFailedList = List<bool>.filled(count, false);
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
  void updateConnectivity(bool isConnected) {
    _isUserConnected = isConnected;

    log('Connectivity changed within the Chat Notifier to $isConnected');
  }

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

    String messageId = '';
    final exists = await _chatRepository.doesChatExist(currentChat!.chatId!);

    if (exists) {
      messageId = await _chatRepository.sendMessage(
        content,
        chatId: currentChat!.chatId!,
        pictures: pictures,
        isConnected: _isUserConnected,
      );
    } else {
      messageId = await _chatRepository.createNewChat(
        content,
        pictures: pictures,
        currentChat: currentChat!,
        isConnected: _isUserConnected,
        userName: _profileData!.firstName!,
        picUrl: _profileData!.profilePics![0],
      );
    }

    // // If there are pictures to upload
    // if (pictures != null && pictures.isNotEmpty) {
    //   uploadFiles(
    //     localPhotoPaths: pictures.map((pic) => pic.path).toList(),
    //     id: messageId,
    //     onUploadComplete: (success) => log(
    //         success ? 'Uploaded successfully' : 'Did not upload successfully'),
    //   );
    // }
  }

  /// Checks if the chat room has been opened for the first time
  Future<void> checkOpenedState() async {
    _hasChatRoomOpened = !await _sharedPrefs.isFirstTimeOpened(ChatRoom.name);
  }

  /// -------------------------
  /// File Uploading Methods
  /// -------------------------

  Future<void> uploadFiles({
    required List<String> localPhotoPaths,
    required String id,
    required Function(bool success) onUploadComplete, // Accept the callback
  }) async {
    // Add to the queue
    _uploadQueue.add(localPhotoPaths);

    if (!_isProcessingQueue) {
      _isProcessingQueue = true;
      await _processUploadQueue(id, onUploadComplete); // Pass the callback here
      _isProcessingQueue = false;
    }
  }

  Future<void> _processUploadQueue(
    String id,
    Function(bool success) onUploadComplete,
  ) async {
    bool allUploadsSuccessful = true; // Track overall success of the batch

    while (_uploadQueue.isNotEmpty) {
      List<String> currentBatch = _uploadQueue.removeFirst();
      initializeUploadStates(currentBatch.length);

      for (int i = 0; i < currentBatch.length; i++) {
        String localPhotoPath = currentBatch[i];

        if (!_fileService.isUploading(localPhotoPath)) {
          setUploading(i, true);
          setUploadFailed(i, false);

          try {
            // Set a 60-second timeout for the upload operation
            _uploadTimeout = Timer(
              const Duration(seconds: 60),
              () {
                // Mark as unsuccessful if timed out
                setUploading(i, false);
                setUploadFailed(i, true);
                allUploadsSuccessful = false;
              },
            );

            // Start uploading the file
            await _fileService.uploadImagesInBackground(
              chatId: currentChat!.chatId!,
              messageId: id,
              localPaths: [localPhotoPath],
              onProgress: (localPath, progress) {
                updateProgress(i, progress);
              },
            );

            _uploadTimeout?.cancel();
            setUploading(i, false);
            setUploadFailed(i, false);
          } catch (e) {
            setUploading(i, false);
            setUploadFailed(i, true);
            log('Error uploading file at index $i: ${e.toString()}');
            allUploadsSuccessful =
                false; // Mark as unsuccessful if an error occurs
          }
        }
      }
    }

    // After processing all uploads, call the completion callback
    onUploadComplete(
        allUploadsSuccessful); // Pass true if all uploads succeeded
  }

  Future<void> retryUpload(String id, String localPhotoPath) async {
    await uploadFiles(
      id: id,
      localPhotoPaths: [localPhotoPath],
      onUploadComplete: (success) => log(
          success ? 'Uploaded successfully' : 'Did not upload successfully'),
    );
  }
}
