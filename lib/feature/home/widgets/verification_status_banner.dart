import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';

import '../../../common/components/components.dart';
import '../../../common/utils/services/services.dart';
import '../../../common/utils/utils.dart';
import '../../../constants/index.dart';
import '../../../provider/provider.dart';


class VerificationStatusBanner extends StatefulWidget {
  const VerificationStatusBanner({super.key, required this.child});
  final Widget child;

  @override
  State<VerificationStatusBanner> createState() =>
      _VerificationStatusBannerState();
}

class _VerificationStatusBannerState extends State<VerificationStatusBanner> {
  // Session-scoped so the "verify your photo" prompt stays away for the rest
  // of this app run once dismissed, but returns on next launch.
  static bool _promptDismissedThisSession = false;

  final _sharedPrefs = SharedPrefsService();

  int? _approvalAck;
  bool _ackLoaded = false;
  Timer? _autoDismissTimer;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadAck();
  }

  Future<void> _loadAck() async {
    final ack = await _sharedPrefs.getVerificationApprovalAck(_uid);

    if (!mounted) return;
    setState(() {
      _approvalAck = ack;
      _ackLoaded = true;
    });
  }

  void _acknowledgeApproval(int reviewedAt) {
    _sharedPrefs.setVerificationApprovalAck(_uid, reviewedAt);
    setState(() => _approvalAck = reviewedAt);
  }

  Future<void> _startVerification() async {
    final profile = context.read<EditProfileNotifier>();

    final image = await context.router.push<File?>(
      PhotoVerification(
        photoUrl: profile.coreProfile?.faceVerification?.photo,
      ),
    );

    if (image == null || !mounted) return;

    profile.updateProfile(photoVerificationUrl: image.path);

    // Auto-save immediately, mirroring the edit-profile entry point: taking a
    // verification selfie is a complete discrete action.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    String? errorMsg;
    final success = await profile.saveUserProfile(
      showSnackbar: (msg) => errorMsg = msg,
    );

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();

    if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    final banner = _buildBanner(context);

    if (banner == null) return widget.child;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        banner,
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: widget.child,
          ),
        ),
      ],
    );
  }

  Widget? _buildBanner(BuildContext context) {
    final profile = context.watch<EditProfileNotifier>();
    final coreProfile = profile.coreProfile;

    // Nothing to say until the profile has loaded.
    if (coreProfile == null || !_ackLoaded) return null;

    final verification = coreProfile.faceVerification;
    final status = verification?.getVerificationStatus() ??
        FaceVerificationStatus.notComplete;

    switch (status) {
      case FaceVerificationStatus.complete:

        final reviewedAt = verification?.reviewedAt?.millisecondsSinceEpoch ??
            verification?.updatedAt?.millisecondsSinceEpoch ??
            1;

        // Already acknowledged: steady state, no banner.
        if ((_approvalAck ?? 0) >= reviewedAt) return null;

        _autoDismissTimer ??= Timer(
          const Duration(seconds: 5),
          () {
            _autoDismissTimer = null;
            if (mounted) _acknowledgeApproval(reviewedAt);
          },
        );

        return _banner(
          color: const Color(0xFFE8F7EE),
          foreground: const Color(0xFF1E7A46),
          icon: Icons.verified,
          text: AppStrings.verificationBannerApproved,
          onTap: () => _acknowledgeApproval(reviewedAt),
        );

      case FaceVerificationStatus.pending:
        return _banner(
          color: const Color(0xFFFFF7E6),
          foreground: const Color(0xFF9A6B00),
          icon: Icons.hourglass_top,
          text: AppStrings.verificationBannerPending,
        );

      case FaceVerificationStatus.notCompleteAndDeclined:
        return _banner(
          color: const Color(0xFFFDECEC),
          foreground: AppColors.primaryColor,
          icon: Icons.error_outline,
          text: AppStrings.verificationBannerRejected,
          actionLabel: 'Retake',
          onAction: _startVerification,
        );

      case FaceVerificationStatus.notComplete:
        if (_promptDismissedThisSession) return null;

        return _banner(
          color: AppColors.listTileColor,
          foreground: AppColors.black,
          icon: Icons.photo_camera_front_outlined,
          text: AppStrings.verificationBannerPrompt,
          actionLabel: 'Take selfie',
          onAction: _startVerification,
          onDismiss: () =>
              setState(() => _promptDismissedThisSession = true),
        );
    }
  }

  Widget _banner({
    required Color color,
    required Color foreground,
    required IconData icon,
    required String text,
    String? actionLabel,
    VoidCallback? onAction,
    VoidCallback? onDismiss,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: color,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8.h,
          bottom: 10.h,
          left: 14.w,
          right: 8.w,
        ),
        child: Row(
          children: [
            Icon(icon, color: foreground, size: 20.r),
            addWidth(10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: foreground,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
            if (actionLabel != null) ...[
              addWidth(8),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  backgroundColor: foreground,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  actionLabel,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            if (onDismiss != null)
              IconButton(
                onPressed: onDismiss,
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.close, color: foreground, size: 18.r),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    super.dispose();
  }
}
