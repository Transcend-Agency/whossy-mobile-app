import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/common/utils/enum/enums.dart';
import 'package:whossy_app/constants/colors.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/chat.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/delivery.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/message.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/reply_to.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/sub_chat.dart';
import 'package:whossy_app/feature/home/tabs/chat/view/chat_room/message/reply_quote.dart';
import 'package:whossy_app/feature/home/tabs/chat/view/chat_room/message/swipe_to_reply.dart';
import 'package:whossy_app/feature/home/tabs/chat/view/widgets/tick_icon.dart';

Timestamp at(int seconds) => Timestamp(seconds, 0);

void main() {
  group('tickStateFor', () {
    TickState tick({
      MessageStatus? status = MessageStatus.sent,
      Timestamp? sentAt,
      Timestamp? deliveredAt,
      bool readReceiptsOn = true,
    }) =>
        tickStateFor(
          status: status,
          sentAt: sentAt ?? at(100),
          recipientDeliveredAt: deliveredAt,
          readReceiptsOn: readReceiptsOn,
        );

    test('a message still on your phone shows as sending', () {
      expect(tick(status: MessageStatus.undelivered), TickState.pending);
    });

    test('one tick until their phone has received it', () {
      expect(tick(), TickState.sent);
      expect(tick(deliveredAt: at(99)), TickState.sent);
    });

    test('two grey ticks once their phone has received it', () {
      expect(tick(deliveredAt: at(100)), TickState.delivered);
      expect(tick(deliveredAt: at(150)), TickState.delivered);
    });

    test('a message with no server time yet is not delivered', () {
      expect(
        tickStateFor(
          status: MessageStatus.sent,
          sentAt: null,
          recipientDeliveredAt: at(150),
          readReceiptsOn: true,
        ),
        TickState.sent,
      );
    });

    test('two blue ticks once they have read it', () {
      expect(tick(status: MessageStatus.seen), TickState.read);
    });

    test('with your read receipts off, a read message shows as delivered', () {
      expect(
        tick(status: MessageStatus.seen, readReceiptsOn: false),
        TickState.delivered,
      );
    });

    test('a message with no status is treated as sent', () {
      expect(tick(status: null), TickState.sent);
      expect(tick(status: null, deliveredAt: at(200)), TickState.delivered);
    });
  });

  group('needsDeliveryAck', () {
    bool needs({
      String? uid = 'me',
      String? lastSenderId = 'them',
      Timestamp? lastMessageAt,
      Map<String, Timestamp> deliveredAt = const {},
    }) =>
        needsDeliveryAck(
          uid: uid,
          lastSenderId: lastSenderId,
          lastMessageAt: lastMessageAt ?? at(100),
          deliveredAt: deliveredAt,
        );

    test('acknowledges a new message from the other person', () {
      expect(needs(), isTrue);
      expect(needs(deliveredAt: {'me': at(50)}), isTrue);
    });

    test('does not acknowledge your own message', () {
      expect(needs(lastSenderId: 'me'), isFalse);
    });

    test('does not acknowledge a message already covered', () {
      expect(needs(deliveredAt: {'me': at(100)}), isFalse);
      expect(needs(deliveredAt: {'me': at(120)}), isFalse);
    });

    test("ignores the other person's delivery time", () {
      expect(needs(deliveredAt: {'them': at(500)}), isTrue);
    });

    test('does nothing when signed out or the chat is incomplete', () {
      expect(needs(uid: null), isFalse);
      expect(needs(lastSenderId: null), isFalse);
      expect(
        needsDeliveryAck(
          uid: 'me',
          lastSenderId: 'them',
          lastMessageAt: null,
          deliveredAt: const {},
        ),
        isFalse,
      );
    });
  });

  group('timestampMapFromJson', () {
    test('keeps timestamps and skips anything else', () {
      expect(
        timestampMapFromJson({'a': at(1), 'b': 'x', 'c': null}),
        {'a': at(1)},
      );
    });

    test('reads a missing or odd value as empty', () {
      expect(timestampMapFromJson(null), isEmpty);
      expect(timestampMapFromJson('nope'), isEmpty);
    });
  });

  group('Chat and SubChat JSON', () {
    test('Chat reads who sent the last message and delivery times', () {
      final chat = Chat.fromJson({
        'participants': ['me', 'them'],
        'last_message': 'hi',
        'last_sender_id': 'them',
        'delivered_at': {'me': at(10)},
      });

      expect(chat.lastSenderUserId, 'them');
      expect(chat.deliveredAt, {'me': at(10)});
    });

    test('Chat never writes delivery times back', () {
      final chat = Chat.fromJson({
        'participants': ['me', 'them'],
        'last_message': 'hi',
        'last_sender_id': 'them',
        'delivered_at': {'me': at(10)},
      });

      expect(chat.toJson().containsKey('delivered_at'), isFalse);
    });

    test('SubChat reads the last message time and delivery times', () {
      final chat = SubChat.fromJson({
        'last_message_timestamp': at(20),
        'delivered_at': {'them': at(30)},
      });

      expect(chat.lastMessageTimestamp?.toTimestamp(), at(20));
      expect(chat.deliveredAt, {'them': at(30)});
    });
  });

  group('Message replies', () {
    Map<String, dynamic> json([Map<String, dynamic> extra = const {}]) => {
          'id': 'm2',
          'sender_id': 'me',
          'message': 'Sure, Saturday works',
          'status': 'sent',
          ...extra,
        };

    test('a message without a reply still reads as before', () {
      final message = Message.fromJson(json());

      expect(message.replyTo, isNull);
      expect(message.toJson().containsKey('reply_to'), isFalse);
    });

    test('reads and writes the quoted message', () {
      final message = Message.fromJson(json({
        'reply_to': {
          'id': 'm1',
          'sender_id': 'them',
          'message': 'Coffee this weekend?',
          'has_photo': false,
        },
      }));

      expect(message.replyTo?.id, 'm1');
      expect(message.replyTo?.senderId, 'them');
      expect(message.replyTo?.preview, 'Coffee this weekend?');
      expect(message.toJson()['reply_to'], {
        'id': 'm1',
        'sender_id': 'them',
        'message': 'Coffee this weekend?',
        'has_photo': false,
      });
    });

    test('a malformed quote is dropped, not fatal', () {
      final message = Message.fromJson(json({
        'reply_to': {'message': 'no id or sender'},
      }));

      expect(message.replyTo, isNull);
      expect(message.message, 'Sure, Saturday works');
    });

    test('copyWith keeps the reply', () {
      final message = Message.fromJson(json({
        'reply_to': {'id': 'm1', 'sender_id': 'them', 'has_photo': true},
      }));

      expect(message.copyWith(message: 'edited').replyTo?.id, 'm1');
    });

    test('status is still one of the values older builds understand', () {
      final written = Message.fromJson(json()).toJson()['status'];
      expect(['sent', 'seen', 'undelivered'], contains(written));
    });
  });

  group('ReplyTo.quoting', () {
    test('cuts long text and marks photos', () {
      final quote = ReplyTo.quoting(
        id: 'm1',
        senderId: 'them',
        message: 'x' * 300,
      );

      expect(quote.message!.length, ReplyTo.maxTextLength + 1);
      expect(quote.message, endsWith('…'));
    });

    test('a photo without text previews as a photo', () {
      final quote = ReplyTo.quoting(
        id: 'm1',
        senderId: 'them',
        message: '   ',
        photo: 'https://example.com/p.jpg',
      );

      expect(quote.message, isNull);
      expect(quote.hasPhoto, isTrue);
      expect(quote.preview, '📷 Photo');
    });
  });

  group('TickIcon', () {
    Future<Icon> pumpTick(WidgetTester tester, TickState state) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: TickIcon(state))),
      );
      return tester.widget<Icon>(find.byType(Icon));
    }

    testWidgets('one grey tick when sent', (tester) async {
      final icon = await pumpTick(tester, TickState.sent);
      expect(icon.icon, Icons.check);
      expect(icon.color, AppColors.messageMetaColor);
    });

    testWidgets('two grey ticks when delivered', (tester) async {
      final icon = await pumpTick(tester, TickState.delivered);
      expect(icon.icon, Icons.done_all);
      expect(icon.color, AppColors.messageMetaColor);
    });

    testWidgets('two blue ticks when read', (tester) async {
      final icon = await pumpTick(tester, TickState.read);
      expect(icon.icon, Icons.done_all);
      expect(icon.color, AppColors.readTickColor);
    });

    testWidgets('a clock while sending', (tester) async {
      final icon = await pumpTick(tester, TickState.pending);
      expect(icon.icon, Icons.schedule_rounded);
    });
  });

  group('SwipeToReply', () {
    Future<List<int>> pumpSwipe(WidgetTester tester) async {
      final replies = <int>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwipeToReply(
              onReply: () => replies.add(1),
              child: const SizedBox(
                width: 300,
                height: 60,
                child: Text('Hello there'),
              ),
            ),
          ),
        ),
      );
      return replies;
    }

    testWidgets('a long enough swipe right starts a reply', (tester) async {
      final replies = await pumpSwipe(tester);

      await tester.drag(find.text('Hello there'), const Offset(120, 0));
      await tester.pumpAndSettle();

      expect(replies, hasLength(1));
    });

    testWidgets('a short swipe does nothing', (tester) async {
      final replies = await pumpSwipe(tester);

      await tester.drag(find.text('Hello there'), const Offset(30, 0));
      await tester.pumpAndSettle();

      expect(replies, isEmpty);
    });

    testWidgets('a swipe left does nothing', (tester) async {
      final replies = await pumpSwipe(tester);

      await tester.drag(find.text('Hello there'), const Offset(-120, 0));
      await tester.pumpAndSettle();

      expect(replies, isEmpty);
    });

    testWidgets('the message slides back after the swipe', (tester) async {
      await pumpSwipe(tester);
      final before = tester.getTopLeft(find.text('Hello there'));

      await tester.drag(find.text('Hello there'), const Offset(120, 0));
      await tester.pumpAndSettle();

      expect(tester.getTopLeft(find.text('Hello there')), before);
    });
  });

  testWidgets('ReplyQuote shows who wrote it and the text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 280,
            child: ReplyQuote(
              name: 'Ola',
              preview: 'Coffee this weekend?',
              isOwn: false,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Ola'), findsOneWidget);
    expect(find.text('Coffee this weekend?'), findsOneWidget);
  });
}
