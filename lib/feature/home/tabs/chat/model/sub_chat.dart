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

  // Reply-Gated Credits (spec §4) — written exclusively by Cloud Functions.
  // 'idle' | 'pending' | 'connected'. Note: the chat doc's `status` field is
  // message seen-state and is unrelated.
  @JsonKey(name: 'credit_status')
  final String? creditStatus;

  @JsonKey(name: 'initiator_id')
  final String? initiatorId;

  @JsonKey(
    name: 'hold_placed_at',
    fromJson: TimestampWrapper.timestampFromJson,
    toJson: TimestampWrapper.timestampToJson,
  )
  final TimestampWrapper? holdPlacedAt;

  @JsonKey(
    name: 'connected_at',
    fromJson: TimestampWrapper.timestampFromJson,
    toJson: TimestampWrapper.timestampToJson,
  )
  final TimestampWrapper? connectedAt;

  @JsonKey(name: 'credit_held')
  final bool? creditHeld;

  // Legacy v1 flag — kept readable for chats that predate the backfill.
  @JsonKey(name: 'is_unlocked')
  final bool? isUnlocked;

  SubChat({
    this.id,
    this.lastMessageId,
    this.unlockTime,
    this.expirationTime,
    this.creditStatus,
    this.initiatorId,
    this.holdPlacedAt,
    this.connectedAt,
    this.creditHeld,
    this.isUnlocked,
  });

  factory SubChat.fromJson(Map<String, dynamic> json) =>
      _$SubChatFromJson(json);

  Map<String, dynamic> toJson() => _$SubChatToJson(this);
}
