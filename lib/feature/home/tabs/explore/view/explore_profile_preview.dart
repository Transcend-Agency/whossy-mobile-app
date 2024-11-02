import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import '../../../edit_profile/model/core_profile.dart';
import '../../../preferences/model/core_preferences.dart';

@RoutePage()
class ExploreProfilePreview extends HookWidget {
  const ExploreProfilePreview(
      {super.key, required this.profile, required this.preferences});

  final CoreProfile profile;
  final CorePreferences preferences;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
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
          preferences: preferences,
          interests: profile.interests,
          gender: profile.gender,
          country: profile.countryOfOrigin,
          bio: profile.bio,
          image: profile.profilePics![0],
          bottomWidget: ProfileFooterScaffold(
            showLess: true,
            data: profile,
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
