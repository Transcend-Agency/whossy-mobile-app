import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../common/components/index.dart';
import '../../../../provider/providers.dart';
import '../model/edit_profile_data.dart';

@RoutePage()
class EditProfilePreview extends HookWidget {
  const EditProfilePreview({super.key, required this.index});

  final int index;

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
        child: Selector<EditProfileNotifier, EditProfileData>(
          selector: (_, editProfile) => editProfile.profileData,
          builder: (_, data, __) {
            final profile = data.profile;
            final preferences = data.preferences;
            return ProfileDetailsScaffold(
              isSameUser: true,
              preferences: preferences,
              interests: profile.interests,
              gender: profile.gender,
              country: profile.countryOfOrigin,
              bio: profile.bio,
              name: data.name,
              images: profile.profilePics,
              bottomWidget: ProfileFooterScaffold(
                showLess: true,
                data: data,
              ),
              options: null,
            );
          },
        ),
      ),
    );
  }
}
