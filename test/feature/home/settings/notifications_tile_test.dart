import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/common/utils/services/notification/notification_access.dart';
import 'package:whossy_app/feature/home/settings/view/widgets/notifications_tile.dart';

void main() {
  group('notificationAccessFrom', () {
    test('allowed and provisional count as on', () {
      expect(notificationAccessFrom(AuthorizationStatus.authorized),
          NotificationAccess.on);
      expect(notificationAccessFrom(AuthorizationStatus.provisional),
          NotificationAccess.on);
    });

    test('denied is off and never asked is not asked', () {
      expect(notificationAccessFrom(AuthorizationStatus.denied),
          NotificationAccess.off);
      expect(notificationAccessFrom(AuthorizationStatus.notDetermined),
          NotificationAccess.notAsked);
    });
  });

  group('NotificationsTile', () {
    late NotificationAccess current;
    late NotificationAccess afterRequest;
    late int requests;
    late int settingsOpened;
    late int turnedOn;

    setUp(() {
      requests = 0;
      settingsOpened = 0;
      turnedOn = 0;
    });

    Future<void> pump(WidgetTester tester) async {
      await tester.pumpWidget(ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            body: NotificationsTile(
              readAccess: () async => current,
              requestAccess: () async {
                requests++;
                current = afterRequest;
                return afterRequest;
              },
              openSettings: () async => settingsOpened++,
              onTurnedOn: () async => turnedOn++,
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('shows On with no hint when allowed', (tester) async {
      current = NotificationAccess.on;
      await pump(tester);

      expect(find.text('On'), findsOneWidget);
      expect(find.textContaining('Off on this phone'), findsNothing);
    });

    testWidgets('after "Don\'t allow" it points to the phone settings',
        (tester) async {
      current = NotificationAccess.off;
      afterRequest = NotificationAccess.off;
      await pump(tester);
      expect(find.text('Off'), findsOneWidget);
      expect(find.textContaining('Off on this phone'), findsOneWidget);

      await tester.tap(find.text('Notifications'));
      await tester.pumpAndSettle();
      expect(requests, 1);
      expect(find.text('Turn on notifications'), findsOneWidget);

      await tester.tap(find.text('Open Settings'));
      await tester.pumpAndSettle();
      expect(settingsOpened, 1);
    });

    testWidgets('allowing from the prompt turns it on without the dialog',
        (tester) async {
      current = NotificationAccess.notAsked;
      afterRequest = NotificationAccess.on;
      await pump(tester);

      await tester.tap(find.text('Notifications'));
      await tester.pumpAndSettle();

      expect(find.text('On'), findsOneWidget);
      expect(find.text('Turn on notifications'), findsNothing);
      expect(turnedOn, 1);
      expect(settingsOpened, 0);
    });

    testWidgets('when on, tapping offers the phone settings to turn it off',
        (tester) async {
      current = NotificationAccess.on;
      await pump(tester);

      await tester.tap(find.text('Notifications'));
      await tester.pumpAndSettle();
      expect(requests, 0);
      expect(find.text('Notifications are on'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(settingsOpened, 0);
    });

    testWidgets('returning to the app picks up a change made in settings',
        (tester) async {
      current = NotificationAccess.off;
      await pump(tester);
      expect(find.text('Off'), findsOneWidget);

      current = NotificationAccess.on;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      expect(find.text('On'), findsOneWidget);
      expect(find.textContaining('Off on this phone'), findsNothing);
    });
  });
}
