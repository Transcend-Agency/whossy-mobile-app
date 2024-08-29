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

  @override
  void initState() {
    super.initState();

    _profileNotifier = Provider.of<EditProfileNotifier>(context, listen: false);

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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      useScrollView: true,
      appBar: CustomAppBar(
        title: 'Edit Profile',
        action: Consumer<EditProfileNotifier>(
          builder: (_, editProfile, __) {
            return Selector<EditProfileNotifier, bool>(
              selector: (_, pref) => pref.hasChanges,
              builder: (_, save, __) {
                return save
                    ? Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: TextButton(
                          onPressed: () {
                            editProfile.saveUserProfile(
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
            );
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
    );
  }
}
