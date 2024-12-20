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

  @JsonKey(name: 'last_message')
  final String lastMessage;

  @JsonKey(name: 'last_sender_id')
  final String lastSenderUserId;

  @JsonKey(
    name: 'last_message_timestamp',
    fromJson: TimestampWrapper.timestampFromJson,
    toJson: TimestampWrapper.timestampToJson,
  )
  final TimestampWrapper? lastMessageTimestamp;

  @JsonKey(name: 'status')
  final MessageStatus? lastMessageStatus;

  @JsonKey(name: 'last_message_id')
  final String? lastMessageId;

  @JsonKey(name: 'is_seen_by_initiator')
  final bool? isSeenByInitiator;

  @JsonKey(name: 'is_seen_by_receiver')
  final bool? isSeenByReceiver;

  Chat({
    this.id,
    required this.participants,
    required this.lastMessage,
    this.lastMessageTimestamp,
    this.lastMessageStatus = MessageStatus.undelivered,
    this.lastMessageId,
    this.isSeenByReceiver,
  })  : lastSenderUserId = FirebaseAuth.instance.currentUser!.uid,
        isSeenByInitiator = true;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);

  // Static method to generate the update map
  static Map<String, dynamic> updateChatData(
    Message message,
    bool isConnected,
  ) {
    return {
      'last_message': message.message,
      'last_message_id': message.id,
      'last_sender_id': message.senderId,
      'last_message_timestamp': FieldValue.serverTimestamp(),
      'status': isConnected
          ? MessageStatus.sent.name
          : MessageStatus.undelivered.name,
    };
  }
}
