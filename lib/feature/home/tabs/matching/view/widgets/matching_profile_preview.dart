import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../common/utils/router/router.gr.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/providers.dart';
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
    final name = user.firstName ?? '';

    useEffect(() {
      void handleScroll() {
        isAtTop.value = scrollController.position.pixels ==
            scrollController.position.minScrollExtent;

        if (isAtTop.value) Navigator.pop(context);
      }

      scrollController.addListener(handleScroll);
      return () => scrollController.removeListener(handleScroll);
    }, [scrollController]);

    final swipeAndMatch = useContext().read<SwipeAndMatchNotifier>();

    return AppScaffold(
      applyTop: false,
      useScrollView: false,
      body: SingleChildScrollView(
        controller: scrollController,
        child: ProfileDetailsScaffold(
          addedHeight: 18,
          tagId: useDefaultTag ? null : user.uid,
          preferences: preferences,
          interests: preferences.ticks,
          country: user.countryOfOrigin,
          gender: user.gender,
          bio: preferences.bio,
          image: preferences.profilePics![index],
          name: name,
          pageName: pageName,
          blockUser: () async =>
              await _blockUser(name: name, context: context, uid: user.uid!),
          bottomWidget: ProfileFooterScaffold(
            data: userProfile,
            showLess: true,
            activePage: index,
          ),
          options: Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MatchIconButton(
                  onTap: () => swipeAndMatch.addDislike(
                    userProfile.user.uid!,
                    addAction: false,
                    showSnackbar: showSnackbar,
                  ),
                  assetPath: AppAssets.cancel,
                ),
                if (showMessaging) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.h),
                    child: MatchIconButton(
                      size: 26,
                      padding: 14,
                      onTap: () => onMessageTap(context),
                      assetPath: AppAssets.message,
                    ),
                  )
                ] else
                  addWidth(40),
                MatchIconButton(
                  onTap: () => swipeAndMatch.addLike(
                    userProfile.user.uid!,
                    addAction: false,
                    showSnackbar: showSnackbar,
                  ),
                  assetPath: AppAssets.like,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onMessageTap(BuildContext context) {
    var notifier = context.read<ChatsNotifier>();

    notifier.setCurrentChat(
      username: userProfile.name,
      uidUser1: FirebaseAuth.instance.currentUser!.uid,
      uidUser2: userProfile.user.uid!,
      profilePicUrl: userProfile.preferences.profilePics![0],
      oppIndex: 1, // will always be 1 as if I initiate the chat I am uid1
    );

    toChat(context);
  }

  Future<void> _blockUser({
    required String name,
    required String uid,
    required BuildContext context,
  }) async {
    bool? result = await showConfirmationDialog(
      context,
      title: 'Block ',
      content: contentText(AppStrings.blockUser(name)),
      yes: 'Yes',
      no: 'Cancel',
    );

    // Exit if user cancels or dismisses the dialog
    if (result != true || !context.mounted) return;

    final editNotifier = context.read<EditProfileNotifier>();
    var blockedIds = editNotifier.coreProfile?.blockedIds ?? [];

    // Check if the user is already blocked
    if (blockedIds.contains(uid)) {
      showSnackbar('$name is already blocked');
      return;
    }

    // Navigate back on success
    if (context.mounted) Navigator.pop(context);

    // Temporarily update the blocked IDs
    var newBlockedIds = [...blockedIds, uid];
    editNotifier.updateProfile(blockedIds: newBlockedIds);

    bool success = await editNotifier.saveUserProfile(
      showSnackbar: showSnackbar,
      returnResult: true,
    );

    if (!success) {
      editNotifier.updateProfile(blockedIds: blockedIds);
      showSnackbar(AppStrings.blockFailure);
      return;
    }
  }

  void toChat(BuildContext context) => Nav.push(context, const ChatRoom());

  showSnackbar(String message) {
    if (useContext().mounted) {
      showTopSnackBar(Overlay.of(useContext()), AppSnackbar(text: message));
    }
  }
}
