import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/utils/router/router.gr.dart';

import '../../../../common/styles/text_style.dart';
import '../../settings/view/widgets/_.dart';
import 'widgets/_.dart';

@RoutePage()
class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      useScrollView: true,
      appBar: const CustomAppBar(
        title: 'Edit Profile',
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
