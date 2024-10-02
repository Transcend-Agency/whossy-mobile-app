import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';
import 'package:whossy_app/common/styles/component_style.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import '../../../edit_profile/model/core_profile.dart';
import '../../../edit_profile/model/info_item.dart';
import '../../../edit_profile/view/widgets/_.dart';
import '../../../edit_profile/view/widgets/edit/image_view.dart';
import '../../../preferences/model/core_preferences.dart';

@RoutePage()
class MatchingScreen extends StatelessWidget {
  const MatchingScreen({
    super.key,
    required this.profile,
    required this.preferences,
  });

  final CoreProfile profile;
  final CorePreferences preferences;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      applyTop: false,
      useScrollView: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(32.r, 24.r, 32.r, 0),
                  child: const ProfileCard(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 0),
                  child: const ProfileCard(color: Color(0xFFE7E7E7)),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ProfileCard(
                      bottomOnly: true,
                      child: Stack(
                        children: [
                          SizedBox.expand(
                            child: Preview(
                              image: profile.profilePics![0],
                            ),
                          ),
                          const ProfileShade(heightFactor: 0.25),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: BottomPreviewImage(
                              showLess: true,
                              profile: profile,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -54,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MatchIconButton(
                            onTap: () {},
                            assetPath: AppAssets.cancel,
                            shadow: [matchButtonShadow],
                          ),
                          addWidth(40),
                          MatchIconButton(
                            onTap: () {},
                            assetPath: AppAssets.like,
                            shadow: [matchButtonShadow],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            addHeight(64),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (preferences.relationshipPreference != null)
                    ProfileDetailsCard(
                      title: 'Relationship preference',
                      titleImage: AppAssets.relPref,
                      content: Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Row(
                          children: [
                            SizedBox.square(
                              dimension: 36,
                              child: Image.asset(AppAssets.i4),
                            ),
                            addWidth(6),
                            Text(
                              preferences.relationshipPreference!.name,
                              style: TextStyles.prefText.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (profile.bio != null && profile.bio!.isNotEmpty)
                    ProfileDetailsCard(
                      title: 'Bio',
                      titleImage: AppAssets.bio,
                      content: ReadMoreText(
                        profile.bio!,
                        trimLines: 2,
                        trimMode: TrimMode.Line,
                        textAlign: TextAlign.left,
                        style: TextStyles.prefText,
                        moreStyle: TextStyles.prefText.copyWith(
                          color: Colors.grey,
                        ),
                        lessStyle: TextStyles.prefText.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ProfileDetailsCard(
                    title: 'About',
                    titleImage: AppAssets.about,
                    content: PreviewInfoColumn(
                      items: [
                        InfoItem(label: "Stays in", value: "Lagos, Nigeria"),
                        InfoItem(label: "Gender", value: profile.gender),
                        if (preferences.education != null)
                          InfoItem(
                              label: "Education",
                              value: preferences.education!.name),
                      ],
                    ),
                  ),
                  if (preferences.futureFamilyPlans != null ||
                      preferences.communicationStyle != null ||
                      preferences.loveLanguage != null)
                    ProfileDetailsCard(
                      title: 'Need to know',
                      titleImage: AppAssets.call,
                      content: PreviewInfoColumn(
                        items: [
                          if (preferences.futureFamilyPlans != null)
                            InfoItem(
                              label: "Future family goals",
                              value: preferences.futureFamilyPlans!.name,
                            ),
                          if (preferences.communicationStyle != null)
                            InfoItem(
                              label: "How you communicate",
                              value: preferences.communicationStyle!.name,
                            ),
                          if (preferences.loveLanguage != null)
                            InfoItem(
                              label: "Love language",
                              value: preferences.loveLanguage!.name,
                            ),
                        ],
                      ),
                    ),
                  if (profile.interests != null &&
                      profile.interests!.isNotEmpty)
                    ProfileDetailsCard(
                      title: 'Interests',
                      contentSpacing: 10,
                      titleImage: AppAssets.interests,
                      content: Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: profile.interests!.take(8).map((item) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xffE7E7E7),
                                    width: 1,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 6.r,
                                  horizontal: 8.r,
                                ),
                                child: Text(
                                  item,
                                  style: TextStyles.hintText.copyWith(
                                    fontSize: AppUtils.scale(10.sp),
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ProfileDetailsCard(
                    title: 'Personal habits',
                    titleImage: AppAssets.love,
                    content: PreviewInfoColumn(
                      items: [
                        if (preferences.smoker != null)
                          InfoItem(
                              label: "Smoker", value: preferences.smoker!.name),
                        if (preferences.drinking != null)
                          InfoItem(
                              label: "Do you drink",
                              value: preferences.drinking!.name),
                        if (preferences.workout != null)
                          InfoItem(
                              label: "Workout",
                              value: preferences.workout!.name),
                        if (preferences.petOwner != null)
                          InfoItem(
                              label: "Pet owner",
                              value: preferences.petOwner!.name),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
