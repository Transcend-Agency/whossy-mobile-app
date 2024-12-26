import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/chats_blur_data.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/providers.dart';

class ChatRoomBlur extends HookWidget {
  const ChatRoomBlur({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    return Selector<ChatsNotifier, ChatsBlurData>(
      selector: (_, chats) => ChatsBlurData(
        user: chats.userData,
        userName: chats.currentChat!.username,
        hasChatExpired: chats.chatExpTime?.isInThePast() ?? true,
      ),
      builder: (_, data, __) {
        final isPremiumUser = data.user?.isPremium ?? false;
        final credits = (data.user?.creditBalance ?? 0);
        final hasCredits = credits > 0;

        return isPremiumUser
            ? const SizedBox.shrink()
            : data.hasChatExpired
                ? Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        color: Colors.black.withOpacity(0.25),
                        padding: pagePadding,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'This chat has not been unlocked   🔐',
                              style: TextStyles.profileHead.copyWith(
                                color: AppColors.inputBackGround,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Text(
                                'Unlock this chat for both of you to connect 😍',
                                textAlign: TextAlign.center,
                                style: TextStyles.profileHead.copyWith(
                                  color: AppColors.inputBackGround,
                                ),
                              ),
                            ),
                            Text(
                              hasCredits
                                  ? 'Credit balance: $credits'
                                  : 'You have no credits',
                              style: TextStyles.profileHead.copyWith(
                                color: AppColors.inputBackGround,
                              ),
                            ),
                            addHeight(20),
                            SizedBox(
                              width: 180,
                              height: 50,
                              child: AppButton(
                                onPress: isLoading.value
                                    ? null
                                    : hasCredits
                                        ? () async {
                                            isLoading.value = true;
                                            await useCredit(
                                              isLoading,
                                              context,
                                              data.userName,
                                            );
                                          }
                                        : () =>
                                            Nav.push(context, const Credits()),
                                text:
                                    hasCredits ? 'Use Credits' : 'Buy Credits',
                                loading: isLoading.value,
                                color: Colors.green,
                                textStyle: TextStyles.profileHead.copyWith(
                                  color: AppColors.inputBackGround,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
      },
    );
  }

  Future<void> useCredit(
    ValueNotifier<bool> isLoading,
    BuildContext context,
    String name,
  ) async {
    bool? result = await showConfirmationDialog(
      context,
      title: 'Unlock Chat',
      content: contentText(AppStrings.unlockChat(name)),
      yes: 'Unlock',
      no: 'Cancel',
    );

    if (result != true || !context.mounted) {
      isLoading.value = false;

      return;
    }

    final editNotifier = context.read<EditProfileNotifier>();
    final chatsNotifier = context.read<ChatsNotifier>();

    var creditBalance = editNotifier.coreProfile?.creditBalance ?? 0;

    editNotifier.updateProfile(creditBalance: creditBalance - 1);

    bool success = await editNotifier.saveUserProfile(
      showSnackbar: showSnackbar,
    );

    if (success) {
      chatsNotifier.updateUnlockTime();
    }

    if (!success) {
      editNotifier.updateProfile(creditBalance: creditBalance);
      showSnackbar(AppStrings.addCreditsFailure);
    }

    isLoading.value = false;
  }

  showSnackbar(String message) {
    if (useContext().mounted) {
      showTopSnackBar(Overlay.of(useContext()), AppSnackbar(text: message));
    }
  }
}
