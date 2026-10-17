import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../../feature/auth/onboarding/model/verification_challenge.dart';
import '../../styles/text_style.dart';
import '../../utils/utils.dart';
import '../components.dart';

/// Shows the reference pose the user is asked to match before they capture
/// their verification selfie — displayed above the camera preview on both
/// onboarding and the profile-edit retake flow.
///
/// When [onRefresh] is provided, a recaptcha-style refresh button lets the
/// user swap to a different pose without leaving the flow.
class VerificationChallengeCard extends StatelessWidget {
  const VerificationChallengeCard({
    super.key,
    required this.challenge,
    this.onRefresh,
  });

  final VerificationChallenge challenge;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.inputBackGround,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedNetworkImage(
              imageUrl: challenge.imageUrl,
              width: 56.r,
              height: 56.r,
              fit: BoxFit.cover,
              placeholder: (_, __) => const ShimmerWidget.rectangular(),
              errorWidget: (_, __, ___) => Container(
                width: 56.r,
                height: 56.r,
                color: AppColors.listTileColor,
              ),
            ),
          ),
          addWidth(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Match this pose',
                  style: TextStyles.hintText.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                addHeight(2),
                Text(
                  challenge.label,
                  style: TextStyles.text,
                ),
              ],
            ),
          ),
          if (onRefresh != null) ...[
            addWidth(8),
            IconButton(
              onPressed: onRefresh,
              visualDensity: VisualDensity.compact,
              tooltip: 'Try a different pose',
              icon: Icon(
                Icons.refresh,
                size: 22.r,
                color: AppColors.hintTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
