import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/components.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/constants/index.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../provider/provider.dart';
import '../../model/chat_credit_state.dart';

/// Slim status strip above the composer describing either the face
/// verification gate (messaging is disabled until approved) or the
/// Reply-Gated Credits state (spec §1.2) — whichever is actually blocking
/// the composer right now. Verification takes priority since it's the more
/// fundamental gate. Renders nothing when there's nothing to say — the
/// not-matched and broke-and-empty cases are handled by [ChatRoomBlur].
class ChatStateBanner extends StatelessWidget {
  const ChatStateBanner({super.key});

  Future<void> _startVerification(BuildContext context) async {
    final profile = context.read<EditProfileNotifier>();

    final image = await context.router.push<File?>(
      PhotoVerification(
        photoUrl: profile.coreProfile?.faceVerification?.photo,
      ),
    );

    if (image == null || !context.mounted) return;

    profile.updateProfile(photoVerificationUrl: image.path);

    String? errorMsg;
    final success = await profile.saveUserProfile(
      showSnackbar: (msg) => errorMsg = msg,
    );

    if (!context.mounted) return;
    if (errorMsg != null) {
      showSnackbar(errorMsg!, context);
    } else if (success) {
      showSnackbar(
        AppStrings.faceVerificationSubmitted,
        context,
        snackBarType: SnackbarType.success,
      );
    }
  }

  Widget _strip({
    required Color background,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 12.w).copyWith(bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatsNotifier>(
      builder: (_, chats, __) {
        final isApproved = chats.userData?.isApproved ?? false;

        if (!isApproved) {
          final name = chats.currentChat?.username ?? 'them';
          const foreground = Color(0xFFF0174B);

          return _strip(
            background: const Color(0xFFFDECEC),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    'Verify your photo to message $name.',
                    textAlign: TextAlign.center,
                    style: TextStyles.hintText.copyWith(
                      fontSize: 12.sp,
                      color: foreground,
                      height: 1.35,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _startVerification(context),
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                  ),
                  child: Text(
                    'Verify',
                    style: TextStyles.hintText.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: foreground,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final state = chats.creditState;
        final name = chats.currentChat?.username ?? 'them';
        final premium = chats.userData?.premiumUser ?? false;
        final broke = !(chats.userData?.canInitiateChat ?? false);
        final subChat = chats.subChat;

        String text;
        Color background = const Color(0xFFF6F6F6);
        Color foreground = const Color(0xFF5D5D5D);

        switch (state) {
          case ChatCreditState.idle:
            text = broke
                ? 'You need 1 credit or Premium to chat with $name — credits '
                    'are only charged when they reply.'
                : premium
                    ? 'Send a message to start the chat with $name.'
                    : 'Send a message to start. 1 credit will be held and '
                        'only charged when $name replies.';
          case ChatCreditState.pendingInitiator:
            if (subChat?.creditHeld ?? false) {
              final left = hoursLeftFrom(subChat?.holdPlacedAt);
              text = '1 credit on hold · charged only when $name replies · '
                  'returned in ${left}h if they don\'t';
            } else {
              text = 'Waiting for $name to reply.';
            }
            background = const Color(0xFFFFF7E6);
            foreground = const Color(0xFF8A6D1A);
          case ChatCreditState.pendingRecipient:
            text = '$name started a chat with you — replying is free and '
                'connects you two.';
            background = const Color(0xFFEAF7EF);
            foreground = const Color(0xFF1D7A45);
          case ChatCreditState.connected:
            final left = hoursUntil(subChat?.expirationTime);
            text = 'Connected · free chat for ${left}h more';
            background = const Color(0xFFEAF7EF);
            foreground = const Color(0xFF1D7A45);
          case ChatCreditState.expired:
            text = broke
                ? 'Your 48-hour window has ended. You need 1 credit or '
                    'Premium to reconnect — only charged when $name replies.'
                : premium
                    ? 'Your 48-hour window has ended. Send a message to '
                        'reconnect.'
                    : 'Your 48-hour window has ended. Send a message to '
                        'reconnect — 1 credit, held until they reply.';
        }

        return _strip(
          background: background,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyles.hintText.copyWith(
              fontSize: 12.sp,
              color: foreground,
              height: 1.35,
            ),
          ),
        );
      },
    );
  }
}
