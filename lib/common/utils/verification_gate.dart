import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';

import '../../constants/index.dart';
import '../../feature/home/edit_profile/data/state/edit_profile_notifier.dart';
import '../components/components.dart';
import 'utils.dart';

Future<void> startFaceVerificationFlow(BuildContext context) async {
  final profile = context.read<EditProfileNotifier>();

  final image = await context.router.push<File?>(
    PhotoVerification(
      photoUrl: profile.coreProfile?.faceVerification?.photo,
    ),
  );

  if (image == null || !context.mounted) return;

  profile.updateProfile(photoVerificationUrl: image.path);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  String? errorMsg;
  final success = await profile.saveUserProfile(
    showSnackbar: (msg) => errorMsg = msg,
  );

  if (!context.mounted) return;
  Navigator.of(context, rootNavigator: true).pop();

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

Future<void> showVerificationGateDialog(
  BuildContext context, {
  required String action,
}) {
  final faceVerification =
      context.read<EditProfileNotifier>().coreProfile?.faceVerification;
  final status =
      faceVerification?.getVerificationStatus() ?? FaceVerificationStatus.notComplete;
  final lowerAction = action.toLowerCase();

  late final String title;
  late final String body;
  final String? cta;

  switch (status) {
    case FaceVerificationStatus.pending:
      title = 'Selfie under review';
      body = "Your verification selfie is being reviewed. You'll be able to "
          "use $lowerAction once it's approved.";
      cta = null;
      break;
    case FaceVerificationStatus.notCompleteAndDeclined:
      title = 'Verification wasn’t approved';
      final reason = faceVerification?.rejectionReason;
      body = reason != null
          ? "Your last selfie wasn't approved: $reason. Retake it to unlock "
              "$lowerAction."
          : "Your last selfie wasn't approved — retake it to unlock "
              "$lowerAction.";
      cta = 'Retake selfie';
      break;
    case FaceVerificationStatus.revoked:
      title = 'Re-verification needed';
      body = 'Your verified badge was revoked after a profile photo change. '
          'Verify again to unlock $lowerAction.';
      cta = 'Take selfie';
      break;
    case FaceVerificationStatus.notComplete:
    case FaceVerificationStatus.complete:
      title = 'Verify it’s really you';
      body = 'To keep Whossy safe, verify your photo to unlock $lowerAction.';
      cta = 'Take selfie';
      break;
  }

  return showConfirmationDialog(
    context,
    title: title,
    content: contentText(body),
    yes: cta,
    no: cta != null ? 'Not now' : 'Got it',
  ).then((confirmed) {
    if (confirmed == true && context.mounted) {
      startFaceVerificationFlow(context);
    }
  });
}
