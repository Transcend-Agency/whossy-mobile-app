// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      id: json['id'] as String?,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      userNames:
          (json['names'] as List<dynamic>).map((e) => e as String).toList(),
      profilePicUrls: (json['profile_pic_urls'] as List<dynamic>)
          .map((e) => e as String?)
          .toList(),
      lastMessage: json['last_message'] as String,
      lastMessageTimestamp: Chat._fromTimestamp(json['last_message_timestamp']),
      unreadCount: json['unread_count'] as num?,
      lastMessageStatus: $enumDecodeNullable(
              _$MessageStatusEnumMap, json['last_message_status']) ??
          MessageStatus.undelivered,
      lastMessageId: json['last_message_id'] as String?,
      userMuted: (json['user_muted'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList(),
      userBlocked: (json['user_blocked'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList(),
      deletedAccount: (json['deleted_account'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList(),
    );

Map<String, dynamic> _$ChatToJson(Chat instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['participants'] = instance.participants;
  val['names'] = instance.userNames;
  val['profile_pic_urls'] = instance.profilePicUrls;
  val['last_message'] = instance.lastMessage;
  writeNotNull('last_message_timestamp',
      Chat._toTimestamp(instance.lastMessageTimestamp));
  writeNotNull('unread_count', instance.unreadCount);
  writeNotNull('last_message_status',
      _$MessageStatusEnumMap[instance.lastMessageStatus]);
  writeNotNull('last_message_id', instance.lastMessageId);
  val['user_blocked'] = instance.userBlocked;
  val['user_muted'] = instance.userMuted;
  val['deleted_account'] = instance.deletedAccount;
  return val;
}

const _$MessageStatusEnumMap = {
  MessageStatus.sent: 'sent',
  MessageStatus.seen: 'seen',
  MessageStatus.undelivered: 'undelivered',
};
