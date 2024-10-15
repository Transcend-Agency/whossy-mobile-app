import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../common/utils/index.dart';
import 'message.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  final String? id;

  @JsonKey(name: 'participants')
  final List<String> participants;

  @JsonKey(name: 'names')
  final List<String> userNames;

  @JsonKey(name: 'profile_pic_urls')
  final List<String?> profilePicUrls;

  @JsonKey(name: 'last_message')
  final String lastMessage;

  @JsonKey(name: 'last_sender_user_id')
  final String lastSenderUserId;

  @JsonKey(
    name: 'last_message_timestamp',
    fromJson: _fromTimestamp,
    toJson: _toTimestamp,
  )
  final Timestamp? lastMessageTimestamp;

  @JsonKey(name: 'unread_count')
  final num? unreadCount;

  @JsonKey(name: 'last_message_status')
  final MessageStatus? lastMessageStatus;

  @JsonKey(name: 'last_message_id')
  final String? lastMessageId;

  @JsonKey(name: 'user_blocked')
  final List<bool> userBlocked;

  @JsonKey(name: 'user_muted')
  final List<bool> userMuted;

  @JsonKey(name: 'deleted_account')
  final List<bool> deletedAccount;

  Chat({
    this.id,
    required this.participants,
    required this.userNames,
    required this.profilePicUrls,
    required this.lastMessage,
    this.lastMessageTimestamp,
    this.unreadCount,
    this.lastMessageStatus = MessageStatus.undelivered,
    this.lastMessageId,
    List<bool>? userMuted,
    List<bool>? userBlocked,
    List<bool>? deletedAccount,
  })  : userMuted = userMuted ?? List.filled(2, false),
        userBlocked = userBlocked ?? List.filled(2, false),
        lastSenderUserId = FirebaseAuth.instance.currentUser!.uid,
        deletedAccount = deletedAccount ?? List.filled(2, false);

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);

  static Timestamp _fromTimestamp(dynamic json) =>
      json != null && json is Timestamp ? json : Timestamp.now();

  static dynamic _toTimestamp(Timestamp? timestamp) => timestamp;

  // Static method to generate the update map
  static Map<String, dynamic> updateChatData(
    Message message,
    bool isConnected,
  ) {
    return {
      'last_message': message.message,
      'last_message_id': message.id,
      'last_sender_user_id': message.senderId,
      'last_message_timestamp': FieldValue.serverTimestamp(),
      'last_message_status': isConnected
          ? MessageStatus.sent.name
          : MessageStatus.undelivered.name,
    };
  }
}
