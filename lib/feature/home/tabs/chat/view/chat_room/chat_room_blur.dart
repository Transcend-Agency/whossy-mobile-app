import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/chats_blur_data.dart';

import '../../../../../../common/components/components.dart';
import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/utils.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/provider.dart';

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
        isMutualMatch: chats.isMutualMatch,
      ),
      builder: (_, data, __) {
        final isPremiumUser = data.user?.isPremium ?? false;
        final credits = (data.user?.creditBalance ?? 0);
        final hasCredits = credits > 0;

        if (!data.isMutualMatch) {
          return Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                color: Colors.black.withValues(alpha: .25),
                padding: pagePadding,
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 280.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 28.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [matchButtonShadow],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 56.r,
                          height: 56.r,
                          decoration: const BoxDecoration(
                            gradient: AppColors.matchContainerGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lock_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        addHeight(16),
                        Text(
                          "You're not connected yet",
                          textAlign: TextAlign.center,
                          style: TextStyles.profileHead.copyWith(
                            color: AppColors.black,
                            fontSize: 18,
                          ),
                        ),
                        addHeight(8),
                        Text(
                          AppStrings.matchRequired(data.userName),
                          textAlign: TextAlign.center,
                          style: TextStyles.bioText.copyWith(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return isPremiumUser
            ? const SizedBox.shrink()
            : data.hasChatExpired
            ? Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              color: Colors.black.withValues(alpha: .25),
              padding: pagePadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'This chat has not been unlocked   🔐',
                    style: TextStyles.profileHead.copyWith(
                      color: AppColors.inputBackGround,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Text(
                      'Unlock this chat for both of you to connect 😍',
                      textAlign: TextAlign.center,
                      style: TextStyles.profileHead.copyWith(
                        color: AppColors.inputBackGround,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Text(
                    hasCredits
                        ? '🪙 Credit balance: $credits'
                        : 'You have no credits',
                    style: TextStyles.profileHead.copyWith(
                      color: AppColors.inputBackGround,
                      fontSize: 20,
                    ),
                  ),
                  addHeight(20),
                  SizedBox(
                    width: 160,
                    child: AppButton(
                      gradient: AppColors.useCredits,
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
                          : () => Nav.push(context, const Credits()),

                      text:
                      hasCredits ? 'Use Credits' : 'Buy Credits',
                      loading: isLoading.value,
                      textStyle: TextStyles.profileHead.copyWith(
                        color: AppColors.inputBackGround,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  addHeight(15),
                  SizedBox(
                    width: 230,
                    child: AppButton(
                      gradient: AppColors.subscribeToPremium,
                      onPress: () => Nav.push(
                        context,
                        SubscriptionPlans(initialPage: 1),
                      ),
                      text: 'Subscribe to Premium',
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
    final chatsNotifier = context.read<ChatsNotifier>();

    if (!chatsNotifier.isMutualMatch) {
      showSnackbar(AppStrings.matchRequired(name));
      isLoading.value = false;

      return;
    }

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