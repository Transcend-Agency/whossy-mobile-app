import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/edit_profile/data/state/edit_profile_notifier.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../constants/index.dart';
import '../../settings/view/widgets/_.dart';
import 'widgets/_.dart';

@RoutePage()
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late EditProfileNotifier _profileNotifier;
  bool _isPopped = false;

  @override
  void initState() {
    super.initState();

    // Using context.read to avoid listening for changes
    _profileNotifier = context.read<EditProfileNotifier>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_profileNotifier.hasEditFetched) {
        _profileNotifier.getUserData(showSnackbar: showSnackbar);
      } else {
        _profileNotifier.hasEditFetched = true;
      }
    });
  }

  showSnackbar(String message) {
    showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
  }

  onPopInvoked(bool didPop) {
    if (didPop && !_isPopped) {
      _isPopped = true;
      _profileNotifier.resetToStatic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: onPopInvoked,
      child: AppScaffold(
        useScrollView: true,
        appBar: CustomAppBar(
          title: 'Edit Profile',
          action: Selector<EditProfileNotifier, bool>(
            selector: (_, pref) => pref.hasChanges,
            builder: (_, save, __) {
              return save
                  ? Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: TextButton(
                        onPressed: () {
                          // Fetch notifier directly in onPressed
                          context.read<EditProfileNotifier>().saveUserProfile(
                                showSnackbar: showSnackbar,
                              );
                        },
                        child: Text(
                          'Save',
                          style: TextStyles.boldPrefText.copyWith(
                            color: AppColors.saveColor,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: ExtraCoreSettings(
                route: const PreviewProfile(),
                customChildren: [
                  Text(
                    'Preview Profile',
                    style: TextStyles.prefText.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: const MediaEditProfile(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: const CoreEditProfileList(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: const BioEditProfile(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: const InterestsTile(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: const ExtraEditProfileList(),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showCustomConfirmationDialog(BuildContext context) {
  return showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return DiscardDialog(
        title: 'Confirm Exit',
        content: 'Are you sure you want to exit?',
        onConfirm: () {
          Navigator.pop(context, true);
        },
        onCancel: () {
          Navigator.pop(context, false);
        },
      );
    },
  );
}
