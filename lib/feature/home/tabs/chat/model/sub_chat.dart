import 'package:json_annotation/json_annotation.dart';

import '../../../../../common/utils/utils.dart';

part 'sub_chat.g.dart';

@JsonSerializable()
class SubChat {
  final String? id;

  @JsonKey(
    name: 'unlock_time',
    fromJson: TimestampWrapper.timestampFromJson,
    toJson: TimestampWrapper.timestampToJson,
  )
  final TimestampWrapper? unlockTime;

  @JsonKey(
    name: 'expiration_time',
    fromJson: TimestampWrapper.timestampFromJson,
    toJson: TimestampWrapper.timestampToJson,
  )
  final TimestampWrapper? expirationTime;

  @JsonKey(name: 'last_message_id')
  final String? lastMessageId;

  SubChat({
    this.id,
    this.lastMessageId,
    this.unlockTime,
    this.expirationTime,
  });

  factory SubChat.fromJson(Map<String, dynamic> json) =>
      _$SubChatFromJson(json);

  Map<String, dynamic> toJson() => _$SubChatToJson(this);
}
