import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/chats_blur_data.dart';

import '../../../../../../common/components/components.dart';
import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/utils.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/provider.dart';

/// Reply-Gated Credits: full-screen gate for the one state where the chat
/// can't be used at all — a fresh chat the user can't afford to start
/// (AC 1.6). There is no match prerequisite (removed 2026-07-19).
/// Everything else (hold pending, connected, expired-with-history) shows the
/// normal chat with the state banner; history always stays readable (AC 4.4).
/// Credit deduction no longer happens here — holds and captures are
/// server-side (`initiateChat` / `onMessageCreated` Cloud Functions).
class ChatRoomBlur extends StatelessWidget {
  const ChatRoomBlur({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<ChatsNotifier, ChatsBlurData>(
      selector: (_, chats) => ChatsBlurData(
        user: chats.userData,
        userName: chats.currentChat!.username,
        creditState: chats.creditState,
        hasMessages: chats.subChat?.lastMessageId != null,
      ),
      builder: (_, data, __) {
        final broke = !(data.user?.canInitiateChat ?? false);

        // Paywall only over chats with no history — once messages exist the
        // banner + gated send handle it and history stays readable (AC 4.4).
        if (data.creditState.needsInitiation && broke && !data.hasMessages) {
          final balance = data.user?.creditBalance ?? 0;
          final held = data.user?.creditsOnHold ?? 0;

          return _overlay(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You need 1 credit or Premium\nto start this chat  🔐',
                  textAlign: TextAlign.center,
                  style: TextStyles.profileHead.copyWith(
                    color: AppColors.inputBackGround,
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Text(
                    'Credits are only charged when ${data.userName} replies — '
                    'no reply within 48 hours and your credit is returned 😍',
                    textAlign: TextAlign.center,
                    style: TextStyles.profileHead.copyWith(
                      color: AppColors.inputBackGround,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  held > 0
                      ? '🪙 Balance: $balance · $held on hold'
                      : '🪙 Balance: $balance',
                  style: TextStyles.profileHead.copyWith(
                    color: AppColors.inputBackGround,
                    fontSize: 18,
                  ),
                ),
                addHeight(20),
                SizedBox(
                  width: 160,
                  child: AppButton(
                    gradient: AppColors.useCredits,
                    onPress: () => Nav.push(context, const Credits()),
                    text: 'Buy Credits',
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
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _overlay({required Widget child}) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
          color: Colors.black.withValues(alpha: .25),
          padding: pagePadding,
          child: Center(child: child),
        ),
      ),
    );
  }
}
