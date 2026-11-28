import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../common/utils/enum/enums.dart';

/// What the ticks under one of your own messages show.
///
/// - [pending]: still on your phone (you were offline when you sent it).
/// - [sent]: one grey tick. It reached Whossy but not their phone yet.
/// - [delivered]: two grey ticks. Their phone has received it.
/// - [read]: two blue ticks. They opened the chat and saw it.
enum TickState { pending, sent, delivered, read }

/// Reads the chat's `delivered_at` map: for each participant, when their
/// phone last received the chat's messages. Anything that isn't a
/// timestamp is skipped.
Map<String, Timestamp> timestampMapFromJson(Object? json) {
  if (json is! Map) return const {};
  return {
    for (final entry in json.entries)
      if (entry.key is String && entry.value is Timestamp)
        entry.key as String: entry.value as Timestamp,
  };
}

/// The ticks for one of your messages.
///
/// Delivery is not kept on the message itself. The recipient's phone moves
/// its own `delivered_at` time on the chat when it receives new messages, so
/// every message sent up to that time has been delivered. Keeping `status`
/// to the values older app builds understand stops those builds failing to
/// read the message.
///
/// A read message shows as delivered while your read receipts are off:
/// read receipts work both ways, but delivery is always shown.
TickState tickStateFor({
  required MessageStatus? status,
  required Timestamp? sentAt,
  required Timestamp? recipientDeliveredAt,
  required bool readReceiptsOn,
}) {
  switch (status) {
    case MessageStatus.undelivered:
      return TickState.pending;
    case MessageStatus.seen:
      return readReceiptsOn ? TickState.read : TickState.delivered;
    case MessageStatus.sent:
    case null:
      final delivered = sentAt != null &&
          recipientDeliveredAt != null &&
          sentAt.compareTo(recipientDeliveredAt) <= 0;
      return delivered ? TickState.delivered : TickState.sent;
  }
}

/// Whether this phone should tell the sender it has received the chat's
/// latest message: the other person sent it, and this user's
/// `delivered_at` time is older than it (or not set yet).
bool needsDeliveryAck({
  required String? uid,
  required String? lastSenderId,
  required Timestamp? lastMessageAt,
  required Map<String, Timestamp> deliveredAt,
}) {
  if (uid == null || lastSenderId == null || lastMessageAt == null) {
    return false;
  }
  if (lastSenderId == uid) return false;
  final mine = deliveredAt[uid];
  return mine == null || mine.compareTo(lastMessageAt) < 0;
}
