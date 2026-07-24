import '../../../../../common/utils/utils.dart';
import 'sub_chat.dart';

/// Reply-Gated Credits — client-side view of the chat state machine (spec §2).
/// Derived from the live chat doc; Cloud Functions are the only writer of the
/// underlying fields, so this is rendering logic, not business logic.
enum ChatCreditState {
  idle,
  pendingInitiator,
  pendingRecipient,
  connected,
  expired;

  bool get isPending =>
      this == ChatCreditState.pendingInitiator ||
      this == ChatCreditState.pendingRecipient;

  /// States in which this send starts a new cycle (hold/initiation needed).
  bool get needsInitiation =>
      this == ChatCreditState.idle || this == ChatCreditState.expired;
}

/// Mirrors HOLD_WINDOW_HOURS / CHAT_WINDOW_HOURS in the backend
/// (whossy-web-app/functions/src/index.ts).
const int kChatWindowHours = 48;

ChatCreditState deriveChatCreditState({
  required SubChat? chat,
  required String currentUid,
}) {
  // No match prerequisite (removed 2026-07-19): premium-or-credits is the
  // only gate on initiating; matching is a discovery feature only.
  if (chat == null) return ChatCreditState.idle;

  if (chat.creditStatus == 'pending') {
    // A hold past its 48h reads as idle — the backend sweeper will refund it,
    // and initiateChat supersedes it server-side if someone sends first.
    final placedAt = chat.holdPlacedAt?.toDateTime();
    if (placedAt != null &&
        DateTime.now().difference(placedAt).inHours >= kChatWindowHours) {
      return ChatCreditState.idle;
    }
    return chat.initiatorId == currentUid
        ? ChatCreditState.pendingInitiator
        : ChatCreditState.pendingRecipient;
  }

  final windowActive = !(chat.expirationTime?.isInThePast() ?? true);

  if (chat.creditStatus == 'connected') {
    return windowActive ? ChatCreditState.connected : ChatCreditState.expired;
  }

  // Legacy docs that predate the backfill: only is_unlocked/expiration_time.
  if (chat.creditStatus == null && (chat.isUnlocked ?? false)) {
    return windowActive ? ChatCreditState.connected : ChatCreditState.expired;
  }

  return ChatCreditState.idle;
}

/// Whole hours left before [from] + 48h; 0 when passed/absent.
int hoursLeftFrom(TimestampWrapper? from) {
  final start = from?.toDateTime();
  if (start == null) return 0;
  final left = start
      .add(const Duration(hours: kChatWindowHours))
      .difference(DateTime.now())
      .inHours;
  return left < 0 ? 0 : left + 1;
}

/// Whole hours until [t]; 0 when passed/absent.
int hoursUntil(TimestampWrapper? t) {
  final at = t?.toDateTime();
  if (at == null) return 0;
  final left = at.difference(DateTime.now()).inHours;
  return left < 0 ? 0 : left + 1;
}
