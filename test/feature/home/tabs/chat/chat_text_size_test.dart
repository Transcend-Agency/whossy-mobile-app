import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/styles/text_style.dart';
import 'package:whossy_app/feature/home/settings/view/widgets/chat_text_size_tile.dart';
import 'package:whossy_app/feature/home/tabs/chat/data/state/chat_text_size_notifier.dart';

/// Stands in for shared preferences.
class _FakeStore {
  _FakeStore([Map<String, String>? initial]) : values = {...?initial};

  final Map<String, String> values;
  int writes = 0;

  Future<String?> read(String key) async => values[key];

  Future<void> write(String key, String value) async {
    writes++;
    values[key] = value;
  }

  ChatTextSizeNotifier notifier() =>
      ChatTextSizeNotifier(read: read, write: write);
}

void main() {
  group('ChatTextSizeNotifier', () {
    test('defaults to Medium (16) when nothing is saved', () async {
      final notifier = _FakeStore().notifier();
      await pumpEventQueue();

      expect(notifier.size, ChatTextSize.medium);
      expect(notifier.fontSize, 16);
    });

    test('restores the saved size', () async {
      final notifier = _FakeStore({
        ChatTextSizeNotifier.storageKey: 'large',
      }).notifier();
      await pumpEventQueue();

      expect(notifier.size, ChatTextSize.large);
    });

    test('ignores a saved value it does not recognise', () async {
      final notifier = _FakeStore({
        ChatTextSizeNotifier.storageKey: 'huge',
      }).notifier();
      await pumpEventQueue();

      expect(notifier.size, ChatTextSize.medium);
    });

    test('keeps working when storage cannot be read', () async {
      final notifier = ChatTextSizeNotifier(
        read: (_) async => throw Exception('storage unavailable'),
        write: (_, __) async {},
      );
      await pumpEventQueue();

      expect(notifier.size, ChatTextSize.medium);
    });

    test('saves a new size and tells listeners', () async {
      final store = _FakeStore();
      final notifier = store.notifier();
      await pumpEventQueue();
      var notified = 0;
      notifier.addListener(() => notified++);

      await notifier.setSize(ChatTextSize.small);

      expect(notifier.size, ChatTextSize.small);
      expect(notified, 1);
      expect(store.values[ChatTextSizeNotifier.storageKey], 'small');
    });

    test('does not save again when the size is unchanged', () async {
      final store = _FakeStore();
      final notifier = store.notifier();
      await pumpEventQueue();

      await notifier.setSize(ChatTextSize.medium);

      expect(store.writes, 0);
    });

    test('a choice made before the saved size loads is kept', () async {
      final store = _FakeStore({ChatTextSizeNotifier.storageKey: 'large'});
      final notifier = store.notifier();

      // Picked before the read above finishes.
      await notifier.setSize(ChatTextSize.small);
      await pumpEventQueue();

      expect(notifier.size, ChatTextSize.small);
    });
  });

  group('TextStyles.messageText', () {
    test('uses the given size, Medium weight and no extra letter spacing', () {
      final style = TextStyles.messageText(18);

      expect(style.fontSize, 18);
      expect(style.fontWeight, FontWeight.w500);
      expect(style.letterSpacing, 0);
    });

    test('times are smaller than the smallest message size', () {
      expect(
        TextStyles.messageMeta.fontSize,
        lessThan(ChatTextSize.small.fontSize),
      );
    });
  });

  group('ChatTextSizeSheet', () {
    Future<ChatTextSizeNotifier> pumpSheet(
      WidgetTester tester,
      _FakeStore store,
    ) async {
      final notifier = store.notifier();
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          child: ChangeNotifierProvider.value(
            value: notifier,
            child: const MaterialApp(
              home: Scaffold(body: ChatTextSizeSheet()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return notifier;
    }

    double sampleFontSize(WidgetTester tester) {
      final text = tester.widget<Text>(
        find.text('Hey! How has your week been?'),
      );
      return text.style!.fontSize!;
    }

    testWidgets('shows the sample messages at the current size',
        (tester) async {
      await pumpSheet(tester, _FakeStore());

      expect(sampleFontSize(tester), 16);
    });

    testWidgets('tapping Large resizes the samples and saves the choice',
        (tester) async {
      final store = _FakeStore();
      final notifier = await pumpSheet(tester, store);

      await tester.tap(find.byKey(const ValueKey('chat_text_size_large')));
      await tester.pumpAndSettle();

      expect(notifier.size, ChatTextSize.large);
      expect(sampleFontSize(tester), 18);
      expect(store.values[ChatTextSizeNotifier.storageKey], 'large');
    });
  });
}
