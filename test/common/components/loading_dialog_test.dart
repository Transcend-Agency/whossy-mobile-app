import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/common/components/Dialog/loading_dialog.dart';

// The social sign-in flows close the loading dialog with the function
// showLoadingDialog returns. These check it removes that dialog and nothing
// else, wherever the dialog sits in the stack.
void main() {
  late BuildContext homeContext;
  final navigatorKey = GlobalKey<NavigatorState>();

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      navigatorKey: navigatorKey,
      home: Builder(builder: (context) {
        homeContext = context;
        return const Text('login');
      }),
    ));
  }

  Future<void> pushPage(WidgetTester tester, String label) async {
    navigatorKey.currentState!.push(
      MaterialPageRoute<void>(builder: (_) => Text(label)),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('closing removes the dialog and leaves the screen under it', (tester) async {
    await pumpHome(tester);
    final close = showLoadingDialog(homeContext);
    await tester.pump();
    expect(find.byType(LoadingDialog), findsOneWidget);

    close();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(LoadingDialog), findsNothing);
    expect(find.text('login'), findsOneWidget);
  });

  testWidgets('closing after the next screen was pushed keeps that screen', (tester) async {
    await pumpHome(tester);
    final close = showLoadingDialog(homeContext);
    await tester.pump();
    await pushPage(tester, 'onboarding');

    close();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(LoadingDialog), findsNothing);
    expect(find.text('onboarding'), findsOneWidget);

    navigatorKey.currentState!.pop();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('login'), findsOneWidget);
  });

  testWidgets('closing twice is harmless', (tester) async {
    await pumpHome(tester);
    final close = showLoadingDialog(homeContext);
    await tester.pump();
    await pushPage(tester, 'onboarding');

    close();
    await tester.pump(const Duration(seconds: 1));
    close();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('onboarding'), findsOneWidget);
    expect(navigatorKey.currentState!.canPop(), isTrue);
  });
}
