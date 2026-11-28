import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/theme/theme.dart';
import 'package:whossy_app/feature/home/tabs/explore/data/repository/user_search_repository.dart';
import 'package:whossy_app/feature/home/tabs/explore/data/state/user_search_notifier.dart';
import 'package:whossy_app/feature/home/tabs/explore/model/liked_user_profile.dart';
import 'package:whossy_app/feature/home/tabs/explore/model/user_search_result.dart';
import 'package:whossy_app/feature/home/tabs/explore/view/widgets/search/explore_search_bar.dart';

class _NoSearch implements UserSearchRepository {
  @override
  Future<List<UserSearchResult>> search(String query) async => [];

  @override
  Future<LikedUserProfile?> openProfile(String uid) async => null;
}

void main() {
  // The search box sits inside its own grey pill. Under the app theme, which
  // fills form fields and gives them rounded borders, the field drew a
  // second, tinted box inside that pill.
  testWidgets('the field draws no fill or border of its own under the app theme',
      (tester) async {
    final search = UserSearchNotifier(repository: _NoSearch());
    addTearDown(search.dispose);

    await tester.pumpWidget(ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp(
        theme: AppTheme().theme(),
        home: Scaffold(
          body: ChangeNotifierProvider.value(
            value: search,
            child: const ExploreSearchBar(),
          ),
        ),
      ),
    ));

    InputDecoration effective() => tester
        .widget<InputDecorator>(find.byType(InputDecorator))
        .decoration;

    for (final focused in [false, true]) {
      if (focused) {
        await tester.tap(find.byType(TextField));
        await tester.pump();
      }
      final d = effective();
      expect(d.filled, isFalse, reason: 'focused: $focused');
      expect(d.enabledBorder, InputBorder.none, reason: 'focused: $focused');
      expect(d.focusedBorder, InputBorder.none, reason: 'focused: $focused');
    }
  });
}
