import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/sub_chat.dart';

// The open chat room moves the reader's own read marker on with
// shouldMarkChatRead deciding when; the web app's unread count relies on it.
void main() {
  SubChat chat({String? lastMessageId = 'm2', String? lastSenderId = 'them'}) =>
      SubChat(lastMessageId: lastMessageId, lastSenderId: lastSenderId);

  test('reads last_sender_id from the chat document', () {
    final parsed =
        SubChat.fromJson({'last_message_id': 'm2', 'last_sender_id': 'them'});
    expect(parsed.lastSenderId, 'them');
  });

  test('marks read when the other person sent the latest message', () {
    expect(
        shouldMarkChatRead(chat: chat(), uid: 'me', markedFor: null), isTrue);
    expect(
        shouldMarkChatRead(chat: chat(), uid: 'me', markedFor: 'm1'), isTrue);
  });

  test('marks read only once per latest message', () {
    expect(
        shouldMarkChatRead(chat: chat(), uid: 'me', markedFor: 'm2'), isFalse);
  });

  test('never for my own latest message', () {
    expect(
        shouldMarkChatRead(
            chat: chat(lastSenderId: 'me'), uid: 'me', markedFor: null),
        isFalse);
  });

  test('never without a chat, a signed-in user, or a known last message', () {
    expect(shouldMarkChatRead(chat: null, uid: 'me', markedFor: null), isFalse);
    expect(
        shouldMarkChatRead(chat: chat(), uid: null, markedFor: null), isFalse);
    expect(
        shouldMarkChatRead(
            chat: chat(lastMessageId: null), uid: 'me', markedFor: null),
        isFalse);
    expect(
        shouldMarkChatRead(
            chat: chat(lastSenderId: null), uid: 'me', markedFor: null),
        isFalse);
  });
}
