import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../../common/components/index.dart';
import '../../../../../../../common/styles/component_style.dart';
import '../../../../../../../common/styles/text_style.dart';
import '../../../../../../../common/utils/index.dart';
import '../../../../../../../constants/index.dart';
import '../../../../../../../provider/providers.dart';

class ActionsSheet extends HookWidget {
  final String name;

  const ActionsSheet({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final uidOppUser =
        useContext().read<ChatsNotifier>().currentChat?.uidUser2 ?? '';
    return AppSheetScaffold(
      title: 'Actions',
      topPadding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: pagePadding,
            child: AppButton(
              color: AppColors.listTileColor,
              onPress: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.unMatch, height: 22),
                  addWidth(10),
                  Text(
                    "Unmatch $name",
                    style: TextStyles.buttonText.copyWith(
                      fontSize: AppUtils.scale(17),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 14.r),
            child: AppButton(
              color: AppColors.listTileColor,
              onPress: () async {
                await _blockUser(
                  name: name,
                  uid: uidOppUser,
                  context: context,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  svgIcon(AppAssets.blockUser, color: Colors.black, size: 21.r),
                  addWidth(10),
                  Text(
                    "Block $name",
                    style: TextStyles.buttonText.copyWith(
                      fontSize: AppUtils.scale(17),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: pagePadding,
            child: AppButton(
              color: AppColors.listTileColor,
              onPress: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.report, height: 26),
                  addWidth(10),
                  Text(
                    "Report $name",
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
      showSnackbar: (msg) => showSnackbar(msg),
      returnResult: true,
    );

    if (!success) {
      editNotifier.updateProfile(blockedIds: blockedIds);
      showSnackbar(AppStrings.blockFailure);
      return;
    }
  }

  showSnackbar(String message) {
    if (useContext().mounted) {
      showTopSnackBar(Overlay.of(useContext()), AppSnackbar(text: message));
    }
  }
}

void showActionsSheet(BuildContext context, String name) {
  showModalBottomSheet<void>(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => ActionsSheet(name: name),
  );
}
