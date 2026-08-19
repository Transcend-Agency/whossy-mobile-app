import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/components/components.dart';
import '../../../../../../common/utils/router/router.gr.dart';
import '../../../../../../common/utils/utils.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/provider.dart';
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
    this.isLiked = false,
    this.showCancel = false,
    this.showMessaging = true,
    this.useDefaultTag = false,
    this.usePageView = false,
  });

  final int index;
  final String? pageName;
  final bool showMessaging;
  final bool showCancel;
  final bool isLiked;
  final bool useDefaultTag; // default is "preview"
  final UserProfile userProfile;
  final bool usePageView;

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

  bool _isLikeVisible = true;
  bool _isDislikeVisible = true;

  void _onLikeTapComplete() {
    setState(() {
      _isLikeVisible = false;
    });
  }

  void _onDislikeTapComplete() {
    setState(() {
      _isDislikeVisible = false;
    });
  }

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
          usePageView: widget.usePageView,
          addedHeight: 18,
          tagId: widget.useDefaultTag ? null : user.uid,
          preferences: preferences,
          interests: preferences.ticks,
          country: user.countryOfOrigin,
          gender: user.gender,
          bio: preferences.bio,
          images: preferences.profilePics,
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
                // Passing is never gated on verification (A3) — declining
                // someone is harmless and gating it just makes the app feel
                // broken to an unverified user.
                if (widget.showCancel && _isDislikeVisible) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.h),
                    child: MatchIconButton(
                      animateOnTap: true,
                      onTap: () => onDisLikeTap(context),
                      assetPath: AppAssets.cancel,
                      onAnimationComplete: _onDislikeTapComplete,
                    ),
                  ),
                ],
                if (widget.showMessaging) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.h),
                    child: MatchIconButton(
                      size: 26,
                      padding: 14,
                      onTap: () => onMessageTap(context),
                      assetPath: AppAssets.message,
                    ),
                  ),
                ],
                if (!widget.isLiked && _isLikeVisible) ...[
                  Selector<EditProfileNotifier, bool>(
                    selector: (_, edit) =>
                        edit.coreProfile?.isApproved ?? false,
                    builder: (_, isApproved, __) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.h),
                        child: MatchIconButton(
                          animateOnTap: isApproved,
                          onTap: () => onLikeTap(context),
                          onAnimationComplete:
                              isApproved ? _onLikeTapComplete : null,
                          assetPath: AppAssets.like,
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDisLikeTap(BuildContext context) {
    swipeAndMatch.addDislike(
      widget.userProfile.user.uid!,
      addAction: false,
      showSnackbar: (msg) => showSnackbar(msg, context),
    );
  }

  void onLikeTap(BuildContext context) {
    var isApproved =
        context.read<EditProfileNotifier>().profileData.isUserVerified;

    if (!isApproved) {
      showSnackbar(
        AppStrings.disAbleUnapproved('Liking'),
        context,
        snackBarType: SnackbarType.warning,
      );
      return;
    }

    swipeAndMatch.addLike(
      widget.userProfile.user.uid!,
      widget.userProfile.name,
      addAction: false,
      showSnackbar: (msg, {type = SnackbarType.error}) {
        showSnackbar(msg, context, snackBarType: type);
      },
    );
  }

  void onMessageTap(BuildContext context) {
    var notifier = context.read<ChatsNotifier>();

    var isApproved =
        context.read<EditProfileNotifier>().profileData.isUserVerified;

    if (!isApproved) {
      showSnackbar(
        AppStrings.disAbleUnapproved('Messaging'),
        context,
        snackBarType: SnackbarType.warning,
      );
      return;
    }

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
    if (blockedIds.contains(uid) && mounted) {
      showSnackbar('$name is already blocked', this.context);
      return;
    }

    // Navigate back on success
    if (context.mounted) Navigator.pop(context);

    // Temporarily update the blocked IDs
    var newBlockedIds = [...blockedIds, uid];
    editNotifier.updateProfile(blockedIds: newBlockedIds);

    bool success = await editNotifier.saveUserProfile(
      showSnackbar: (msg) => showSnackbar(msg, this.context),
    );

    if (!success && mounted) {
      editNotifier.updateProfile(blockedIds: blockedIds);
      showSnackbar(AppStrings.blockFailure, this.context);

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
                context.read<EditProfileNotifier>().profileData.name;

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

            reportNotifier.reportUser(
              report,
              showSnackbar: (msg) => showSnackbar(msg, this.context),
            );

            showSnackbar(
              AppStrings.reportUser,
              this.context,
              snackBarType: SnackbarType.success,
            );
          },
        );
      },
    );
  }

  void toChat(BuildContext context) => Nav.push(context, const ChatRoom());
}
