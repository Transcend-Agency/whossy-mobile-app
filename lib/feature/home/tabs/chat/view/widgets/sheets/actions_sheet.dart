import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../common/components/index.dart';
import '../../../../../../../common/styles/component_style.dart';
import '../../../../../../../common/styles/text_style.dart';
import '../../../../../../../common/utils/index.dart';
import '../../../../../../../constants/index.dart';
import '../../../../../../../provider/providers.dart';
import '../../../../profile/model/report.dart';
import '../../../../profile/view/report_dialog.dart';
import '../../../model/chat_room_data.dart';

class ActionsSheet extends StatefulWidget {
  final ChatRoomData chatRoomData;

  const ActionsSheet({super.key, required this.chatRoomData});

  @override
  State<ActionsSheet> createState() => _ActionsSheetState();
}

class _ActionsSheetState extends State<ActionsSheet> {
  BuildContext? get $thisContext => mounted ? context : null;

  @override
  Widget build(BuildContext context) {
    final chat = widget.chatRoomData.currentChat;
    return AppSheetScaffold(
      title: 'Actions',
      topPadding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: pagePadding.copyWith(bottom: 12.r),
            child: AppButton(
              color: AppColors.listTileColor,
              onPress: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.unMatch, height: 22),
                  addWidth(10),
                  Text(
                    "Unmatch ${chat.username}",
                    style: TextStyles.buttonText.copyWith(
                      fontSize: AppUtils.scale(17),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Selector<EditProfileNotifier, bool>(
            selector: (_, edit) =>
                (edit.coreProfile?.blockedIds ?? []).contains(chat.uidUser2),
            builder: (_, isBlocked, __) {
              return isBlocked
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: EdgeInsets.fromLTRB(14.r, 0, 14.r, 12.r),
                      child: AppButton(
                        color: AppColors.listTileColor,
                        onPress: () async {
                          await _blockUser(
                            chatRoomData: widget.chatRoomData,
                            context: context,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            svgIcon(AppAssets.blockUser,
                                color: Colors.black, size: 21.r),
                            addWidth(10),
                            Text(
                              "Block ${chat.username}",
                              style: TextStyles.buttonText.copyWith(
                                fontSize: AppUtils.scale(17),
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            },
          ),
          Padding(
            padding: pagePadding,
            child: AppButton(
              color: AppColors.listTileColor,
              onPress: () {
                _showReportDialog(
                  chatRoomData: widget.chatRoomData,
                  context: context,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.report, height: 26),
                  addWidth(10),
                  Text(
                    "Report ${chat.username}",
                    style: TextStyles.buttonText.copyWith(
                      fontSize: AppUtils.scale(17),
                      color: AppColors.buttonColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _blockUser({
    required ChatRoomData chatRoomData,
    required BuildContext context,
  }) async {
    final chat = chatRoomData.currentChat;

    bool? result = await showConfirmationDialog(
      context,
      title: 'Block ',
      content: contentText(AppStrings.blockUser(chat.username)),
      yes: 'Yes',
      no: 'Cancel',
    );

    // Exit if user cancels or dismisses the dialog
    if (result != true || !context.mounted) return;

    final editNotifier = context.read<EditProfileNotifier>();
    var blockedIds = editNotifier.coreProfile?.blockedIds ?? [];

    // Check if the user is already blocked
    if (blockedIds.contains(chat.uidUser2)) {
      showSnackbar('${chat.username} is already blocked', $thisContext!);
      return;
    }

    // Navigate back on success
    if (context.mounted) Navigator.pop(context);

    // Temporarily update the blocked IDs
    var newBlockedIds = [...blockedIds, chat.uidUser2];
    editNotifier.updateProfile(blockedIds: newBlockedIds);

    bool success = await editNotifier.saveUserProfile(
      showSnackbar: (msg) => showSnackbar(msg, this.context),
    );

    if (!success) {
      editNotifier.updateProfile(blockedIds: blockedIds);

      showSnackbar(AppStrings.blockFailure, $thisContext!);

      return;
    }
  }

  void _showReportDialog({
    required ChatRoomData chatRoomData,
    required BuildContext context,
  }) {
    final chat = chatRoomData.currentChat;

    showDialog(
      context: context,
      builder: (ctx) {
        return ReportDialog(
          name: chat.username,
          onSubmit: (reason, customMessage) {
            final reportNotifier = context.read<ReportNotifier>();

            final uid = FirebaseAuth.instance.currentUser?.uid;

            String extra = '';

            if (customMessage != null) {
              extra = ': $customMessage';
            }

            final report = Report(
              id: chat.chatId,
              message: '$reason $extra'.trim(),
              reportedId: chat.uidUser2,
              reportedName: chat.username,
              reporterId: uid,
              reporterName: chatRoomData.currentUserName,
            );

            // Navigate back on success
            if (context.mounted) Navigator.pop(context);

            reportNotifier.reportUser(report,
                showSnackbar: (msg) => showSnackbar(msg, this.context));

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
}

void showActionsSheet(BuildContext context, {required ChatRoomData data}) {
  showModalBottomSheet<void>(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => ActionsSheet(chatRoomData: data),
  );
}
