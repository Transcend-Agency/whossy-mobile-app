import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../common/utils/router/router.gr.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/providers.dart';
import '../../../../../auth/onboarding/model/preferences.dart';
import '../../../../../auth/sign_up/model/app_user.dart';
import '../../../profile/model/report.dart';
import '../../../profile/view/report_dialog.dart';
import '../../model/user_profile.dart';

@RoutePage()
class MatchingProfilePreview extends StatefulWidget {
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
  State<MatchingProfilePreview> createState() => _MatchingProfilePreviewState();
}

class _MatchingProfilePreviewState extends State<MatchingProfilePreview> {
  late ScrollController scrollController;
  late AppUser user;
  late Preferences preferences;
  late bool isAtTop;
  late String name;
  late SwipeAndMatchNotifier swipeAndMatch;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    user = widget.userProfile.user;
    preferences = widget.userProfile.preferences;
    name = user.firstName ?? '';
    isAtTop = false;
    swipeAndMatch = context.read<SwipeAndMatchNotifier>();

    scrollController.addListener(handleScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(handleScroll);
    scrollController.dispose();
    super.dispose();
  }

  void handleScroll() {
    setState(() {
      isAtTop = scrollController.position.pixels ==
          scrollController.position.minScrollExtent;
    });

    if (isAtTop) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      applyTop: false,
      useScrollView: false,
      body: SingleChildScrollView(
        controller: scrollController,
        child: ProfileDetailsScaffold(
          addedHeight: 18,
          tagId: widget.useDefaultTag ? null : user.uid,
          preferences: preferences,
          interests: preferences.ticks,
          country: user.countryOfOrigin,
          gender: user.gender,
          bio: preferences.bio,
          image: preferences.profilePics![widget.index],
          name: name,
          pageName: widget.pageName,
          blockUser: () async =>
              await _blockUser(name: name, context: context, uid: user.uid!),
          reportUser: () => _showReportDialog(context: context, user: user),
          bottomWidget: ProfileFooterScaffold(
            data: widget.userProfile,
            showLess: true,
            activePage: widget.index,
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
                    widget.userProfile.user.uid!,
                    addAction: false,
                    showSnackbar: showSnackbar,
                  ),
                  assetPath: AppAssets.cancel,
                ),
                if (widget.showMessaging) ...[
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
                    widget.userProfile.user.uid!,
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
      username: widget.userProfile.name,
      uidUser1: FirebaseAuth.instance.currentUser!.uid,
      uidUser2: widget.userProfile.user.uid!,
      profilePicUrl: widget.userProfile.preferences.profilePics![0],
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
    );

    if (!success) {
      editNotifier.updateProfile(blockedIds: blockedIds);
      showSnackbar(AppStrings.blockFailure);
      return;
    }
  }

  void _showReportDialog({
    required AppUser user,
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return ReportDialog(
          name: user.firstName ?? '',
          onSubmit: (reason, customMessage) {
            final reportNotifier = context.read<ReportNotifier>();
            final reporterName =
                context.read<EditProfileNotifier>().coreProfile?.name;

            final uid = FirebaseAuth.instance.currentUser?.uid;

            String extra = '';

            if (customMessage != null) {
              extra = ': $customMessage';
            }

            final report = Report(
              message: '$reason $extra'.trim(),
              reportedId: user.uid,
              reportedName: user.getName(),
              reporterId: uid,
              reporterName: reporterName,
            );

            // Navigate back on success
            if (context.mounted) Navigator.pop(context);

            reportNotifier.reportUser(report, showSnackbar: showSnackbar);

            showSnackbar(
              AppStrings.reportUser,
              snackBarType: SnackbarType.success,
            );
          },
        );
      },
    );
  }

  void toChat(BuildContext context) => Nav.push(context, const ChatRoom());

  showSnackbar(
    String message, {
    SnackbarType snackBarType = SnackbarType.error,
  }) {
    if (mounted) {
      showTopSnackBar(
        Overlay.of(context),
        AppSnackbar(
          text: message,
          snackbarType: snackBarType,
        ),
      );
    }
  }
}
