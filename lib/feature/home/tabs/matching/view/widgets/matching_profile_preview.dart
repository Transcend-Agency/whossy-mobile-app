import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../model/user_profile.dart';

@RoutePage()
class MatchingProfilePreview extends HookWidget {
  const MatchingProfilePreview({
    super.key,
    required this.index,
    required this.userProfile,
    this.pageName,
    this.showMessaging = false,
    this.useDefaultTag = false,
  });

  final int index;
  final String? pageName;
  final bool showMessaging;
  final bool useDefaultTag; // default is "preview"
  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final user = userProfile.user;
    final preferences = userProfile.preferences;
    final isAtTop = useState(false);

    useEffect(() {
      void handleScroll() {
        isAtTop.value = scrollController.position.pixels ==
            scrollController.position.minScrollExtent;

        if (isAtTop.value) Navigator.pop(context);
      }

      scrollController.addListener(handleScroll);
      return () => scrollController.removeListener(handleScroll);
    }, [scrollController]);

    return AppScaffold(
      applyTop: false,
      useScrollView: false,
      body: SingleChildScrollView(
        controller: scrollController,
        child: ProfileDetailsScaffold(
          tagId: useDefaultTag ? null : user.uid,
          preferences: preferences,
          interests: preferences.ticks,
          country: user.countryOfOrigin,
          gender: user.gender,
          bio: preferences.bio,
          image: preferences.profilePics![index],
          name: user.firstName ?? '',
          pageName: pageName,
          bottomWidget: ProfileFooterScaffold(
            data: userProfile,
            showLess: true,
            activePage: index,
          ),
          options: Positioned(
            bottom: -54,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MatchIconButton(
                  onTap: () {},
                  assetPath: AppAssets.cancel,
                ),
                if (showMessaging) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.h),
                    child: MatchIconButton(
                      size: 20,
                      padding: 12,
                      onTap: () => {},
                      assetPath: AppAssets.message,
                    ),
                  )
                ] else
                  addWidth(40),
                MatchIconButton(
                  onTap: () {},
                  assetPath: AppAssets.like,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
