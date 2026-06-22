import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whossy_app/common/utils/app_utils.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/chat_with_user.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/message.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/sub_chat.dart';

import '../../../../../../common/utils/services/services.dart';
import '../../../../edit_profile/model/core_profile.dart';
import '../../../likes_and_match/data/repository/matches_repository.dart';
import '../../../matching/model/user_profile.dart';
import '../../model/current_chat.dart';
import '../repository/chat_repository.dart';
import '../source/extensions.dart';

class ChatsNotifier extends ChangeNotifier {
  // Internal services and repository
  final _sharedPrefs = SharedPrefsService();
  final _chatRepository = ChatRepository();
  final _matchesRepository = MatchesRepository();

  final _fileService = FileService();

  final Queue<List<String>> _uploadQueue = Queue();
  bool _isProcessingQueue = false;
  String? _lastMessageId;
  StreamSubscription<SubChat?>? _chatSubscription;

  // Variables to manage state
  CurrentChat? currentChat;
  CoreProfile? _profileData;
  TimestampWrapper? chatExpTime;
  bool _hasChatRoomOpened = true;

  List<String>? _blockedIds; // Variable to store blocked IDs
  bool _isUserConnected = false;

  // Whether the current user and the chat partner have a mutual `matches`
  // doc. Unrelated to `_isUserConnected` above (see updateConnectivity).
  bool _isMutualMatch = false;
  Timer? _uploadTimeout;

  final Map<String, double> _progressMap = {};
  final Map<String, bool> _isUploadingMap = {};
  final Map<String, bool> _hasUploadFailedMap = {};

  // Getters
  Map<String, double> get progressMap => _progressMap;
  Map<String, bool> get isUploadingMap => _isUploadingMap;
  Map<String, bool> get hasUploadFailedMap => _hasUploadFailedMap;

  bool get isMutualMatch => _isMutualMatch;

  bool get viewPermission {
    // The credit/premium unlock mechanism only kicks in once both users
    // are mutually matched — see whossy-mobile-app-implementation-plan.md §1.
    if (!_isMutualMatch) return false;

    // Check if chatExpTime is available and in the past
    bool? isCreditFinished = chatExpTime?.isInThePast();

    // If isCreditFinished is null (meaning chatExpTime is not available),
    // assume no permission
    if (isCreditFinished == null) {
      return _profileData?.premiumUser ?? false;
    }

    // If isCreditFinished is false (credit hasn't finished),
    // return true if user has premium access or if credit is still active
    bool isPremiumUser = _profileData?.premiumUser ?? false;
    return isPremiumUser || !isCreditFinished;
  }

  CoreProfile? get userData => _profileData;

  void updateExpirationTime(TimestampWrapper? expTime) {
    chatExpTime = expTime;

    notifyListeners();
  }

// Update methods for progress and state
  void updateProgress(String localPhotoPath, double value) {
    _progressMap[localPhotoPath] = value;
    notifyListeners();
  }

  void setUploading(String localPhotoPath, bool value) {
    _isUploadingMap[localPhotoPath] = value;
    notifyListeners();
  }

  void setUploadFailed(String localPhotoPath, bool value) {
    _hasUploadFailedMap[localPhotoPath] = value;
    notifyListeners();
  }

  // Initialize states for a list of files
  void initializeUploadStates(List<String> localPhotoPaths) {
    for (var path in localPhotoPaths) {
      _progressMap[path] = 0.0;
      _isUploadingMap[path] = false;
      _hasUploadFailedMap[path] = false;
    }
    notifyListeners();
  }

  // Chat stream getter
  Stream<List<ChatWithUser>> get chatStream => _chatRepository.getChatsStream();

  Stream<UserProfile?> chatterDataStream(String id) {
    return _chatRepository.getChatterDataStream(id).map((userProfile) {
      final newBlockedIds = userProfile?.user.blockedIds;

      // Update the local `_blockedIds` if they are different
      if (newBlockedIds != _blockedIds) {
        _blockedIds = newBlockedIds;
      }

      return userProfile; // Pass the original userProfile downstream
    });
  }

  // Manage the opened chat room state
  bool get hasChatOpened => _hasChatRoomOpened;

  set hasChatOpened(bool value) {
    if (_hasChatRoomOpened != value) {
      _hasChatRoomOpened = value;
      notifyListeners();
    }
  }

  void saveProfile(CoreProfile? data) {
    if (_profileData == data) return;

    _profileData = data;
    notifyListeners();
  }

  void updateConnectivity(bool isConnected) {
    if (_isUserConnected == isConnected) return;

    _isUserConnected = isConnected;
  }

  /// -------------------------
  /// Chat Management Methods
  /// -------------------------

  void setCurrentChat({
    required String username,
    required String uidUser1,
    required String uidUser2,
    String? profilePicUrl,
    int? oppIndex,
    bool? isDeleted,
    bool? isBlocked,
  }) {
    final chatId = AppUtils.generateCombinedId(uidUser1, uidUser2);

    currentChat = CurrentChat(
      chatId: chatId,
      username: username,
      uidUser1: uidUser1,
      uidUser2: uidUser2,
      profilePicUrl: profilePicUrl,
      oppIndex: oppIndex,
      isBlocked: isBlocked ?? false,
    );

    _isMutualMatch = false;

    notifyListeners();

    _matchesRepository.isMutualMatch(uidUser1, uidUser2).then((isMatch) {
      _isMutualMatch = isMatch;
      notifyListeners();
    });
  }

  Future<void> updateUnlockTime() async =>
      await _chatRepository.updateUnlockTime(chatId: currentChat?.chatId);

  Stream<List<Message>> messagesStream(int limit) => _chatRepository
      .getChatMessagesStream(limit: limit, chatId: currentChat!.chatId!);

  /// Sends a message with optional attached pictures
  Future<void> sendMessage(String content, {List<XFile>? pictures}) async {
    if (currentChat == null) return;

    // Check if the sender is blocked
    final isSenderBlocked =
        _blockedIds?.contains(currentChat!.uidUser1) ?? false;

    String messageId = await _chatRepository.sendMessage(
      content,
      chatId: currentChat!.chatId!,
      pictures: pictures,
      isConnected: _isUserConnected,
      currentChat: currentChat!,
      isSenderBlocked: isSenderBlocked,
    );

    // If there are pictures to upload
    if (pictures != null && pictures.isNotEmpty) {
      uploadFiles(
        localPhotoPaths: pictures.map((pic) => pic.path).toList(),
        id: messageId,
        onUploadComplete: (success) => log(
            success ? 'Uploaded successfully' : 'Did not upload successfully'),
      );
    }
  }

  Future<void> updateMessageStatus(Message message) async {
    if (viewPermission) {
      return _chatRepository.updateMessageStatus(
        message: message,
        chatId: currentChat?.chatId,
        lastMessageId: _lastMessageId,
      );
    }
  }

  void listenToChatUpdates() {
    _chatSubscription =
        _chatRepository.getChatDataStream(currentChat?.chatId).listen((chat) {
      updateExpirationTime(chat?.expirationTime);
      if (chat != null) {
        if (chat.lastMessageId != _lastMessageId) {
          _lastMessageId = chat.lastMessageId;
        }
      }
    });
  }

  void cancelChatUpdates() {
    _chatSubscription?.cancel();
    _chatSubscription = null;
    _lastMessageId == null;
  }

  /// Checks if the chat room has been opened for the first time
  Future<void> checkOpenedState() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    _hasChatRoomOpened =
        !await _sharedPrefs.isFirstTimeOpened(ChatRoom.name, uid);
  }

  /// -------------------------
  /// File Uploading Methods
  /// -------------------------
  ///
  Future<void> uploadFiles({
    required List<String> localPhotoPaths,
    required String id,
    required Function(bool success) onUploadComplete,
  }) async {
    // Check if the upload for these paths is already in progress
    if (_uploadQueue.any(
      (existingPaths) => areListsEqual(existingPaths, localPhotoPaths),
    )) {
      return;
    }

    // Add the photo paths to the queue
    _uploadQueue.add(localPhotoPaths);

    // If no upload is currently being processed, start processing the queue
    if (!_isProcessingQueue) {
      _isProcessingQueue = true;
      await _processUploadQueue(id, onUploadComplete);
      _isProcessingQueue = false;
    }
  }

  Future<void> _processUploadQueue(
    String id,
    Function(bool success) onUploadComplete,
  ) async {
    bool allUploadsSuccessful = true;

    while (_uploadQueue.isNotEmpty) {
      List<String> currentBatch = _uploadQueue.first;
      initializeUploadStates(currentBatch);

      for (String localPhotoPath in currentBatch) {
        if (!_fileService.isUploading(localPhotoPath)) {
          setUploading(localPhotoPath, true);
          setUploadFailed(localPhotoPath, false);

          try {
            _uploadTimeout = Timer(
              const Duration(seconds: 60),
              () {
                setUploading(localPhotoPath, false);
                setUploadFailed(localPhotoPath, true);
                allUploadsSuccessful = false;
              },
            );

            // Start uploading the file

            await _fileService.uploadImagesInBackground(
              chatId: currentChat!.chatId!,
              messageId: id,
              localPaths: [localPhotoPath],
              onProgress: (localPath, progress) {
                updateProgress(localPath, progress);
              },
            );

            _uploadTimeout?.cancel();
            setUploading(localPhotoPath, false);
            setUploadFailed(localPhotoPath, false);
          } catch (e) {
            setUploading(localPhotoPath, false);
            setUploadFailed(localPhotoPath, true);
            log('Error uploading file at index $localPhotoPath: ${e.toString()}');
            allUploadsSuccessful = false;
          }
        }
      }
      _uploadQueue.removeFirst();
    }

    // After processing all uploads, call the completion callback
    onUploadComplete(allUploadsSuccessful);
  }

  Future<void> retryUpload(String id, String localPhotoPath) async {
    await uploadFiles(
      id: id,
      localPhotoPaths: [localPhotoPath],
      onUploadComplete: (success) => log(
          success ? 'Uploaded successfully' : 'Did not upload successfully'),
    );
  }

  void reset() {
    currentChat = null;
    _profileData = null;
    chatExpTime = null;
    _hasChatRoomOpened = true;
    _blockedIds = null;
    _isUserConnected = false;
    _isMutualMatch = false;
    _lastMessageId = null;

    _chatSubscription?.cancel();
    _chatSubscription = null;

    _progressMap.clear();
    _isUploadingMap.clear();
    _hasUploadFailedMap.clear();

    _uploadQueue.clear();
    _isProcessingQueue = false;
    _uploadTimeout?.cancel();
    _uploadTimeout = null;

    notifyListeners();
  }
}
