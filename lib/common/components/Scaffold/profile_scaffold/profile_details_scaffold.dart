import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../../../constants/index.dart';
import '../../../../feature/home/edit_profile/model/info_item.dart';
import '../../../../feature/home/edit_profile/view/widgets/_.dart';
import '../../../../feature/home/edit_profile/view/widgets/edit/image_view.dart';
import '../../../../feature/home/tabs/matching/model/profile_data.dart';
import '../../../../provider/providers.dart';
import '../../../styles/text_style.dart';
import '../../../utils/index.dart';
import '../../index.dart';

class ProfileDetailsScaffold extends StatelessWidget {
  const ProfileDetailsScaffold({
    super.key,
    required this.preferences,
    this.interests,
    required this.country,
    required this.gender,
    required this.bio,
    required this.bottomWidget,
    required this.image,
    required this.options,
    this.isSameUser = false,
    this.addedHeight = 0,
    required this.name,
    this.tagId,
    this.pageName,
    this.blockUser,
  });

  final Widget bottomWidget;
  final Widget? options;
  final ProfileData preferences;
  final List<String>? interests;
  final String? country;
  final String? gender;
  final String? bio;
  final String image;
  final String name;
  final String? tagId;
  final String? pageName;
  final double addedHeight;
  final VoidCallback? blockUser;

  final bool isSameUser;

  @override
  Widget build(BuildContext context) {
    final tag = (tagId != null && pageName != null)
        ? '$tagId$pageName'
        : (tagId ?? 'preview');

    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(32.r, 24.r, 32.r, 0),
              child: ProfileCard(addedHeight: addedHeight),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 0),
              child: const ProfileCard(color: Color(0xFFE7E7E7)),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Hero(
                  tag: tag,
                  child: ProfileCard(
                    bottomOnly: true,
                    child: Stack(
                      children: [
                        SizedBox.expand(
                          child: Preview(image: image),
                        ),
                        ProfileShade(
                          heightFactor: 0.4,
                          gradient: AppColors.profileShade2,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: bottomWidget,
                        ),
                      ],
                    ), //
                  ),
                ),
              ],
            ), //
            if (options != null) options!,
          ],
        ),
        addHeight(40 - addedHeight),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (preferences.hasRelationshipPreference)
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
                          preferences.getRelationshipPreference(),
                          style: TextStyles.prefText.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (bio != null)
                ProfileDetailsCard(
                  title: 'Bio',
                  titleImage: AppAssets.bio,
                  content: ReadMoreText(
                    bio!,
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
                    if (country != null)
                      InfoItem(
                        label: "Stays in",
                        value: country,
                      ),
                    if (gender != null)
                      InfoItem(
                        label: "Gender",
                        value: gender,
                      ),
                    if (preferences.hasEducation)
                      InfoItem(
                        label: "Education",
                        value: preferences.getEducation(),
                      ),
                  ],
                ),
              ),
              if (preferences.hasFutureFamilyPlans ||
                  preferences.hasCommunicationStyle ||
                  preferences.hasLoveLanguage)
                ProfileDetailsCard(
                  title: 'Need to know',
                  titleImage: AppAssets.call,
                  content: PreviewInfoColumn(
                    items: [
                      if (preferences.hasFutureFamilyPlans)
                        InfoItem(
                          label: "Future family goals",
                          value: preferences.getFutureFamilyPlans(),
                        ),
                      if (preferences.hasCommunicationStyle)
                        InfoItem(
                          label: "How you communicate",
                          value: preferences.getCommunicationStyle(),
                        ),
                      if (preferences.hasLoveLanguage)
                        InfoItem(
                          label: "Love language",
                          value: preferences.getLoveLanguage(),
                        ),
                    ],
                  ),
                ),
              if (interests != null && interests!.isNotEmpty)
                Interests(isSameUser: isSameUser, interests: interests!),
              if (preferences.isSmoker ||
                  preferences.isDrinker ||
                  preferences.isWorkout ||
                  preferences.isPetOwner)
                ProfileDetailsCard(
                  title: 'Personal habits',
                  titleImage: AppAssets.love,
                  content: PreviewInfoColumn(
                    items: [
                      if (preferences.isSmoker)
                        InfoItem(
                          label: "Smoker",
                          value: preferences.getSmoke(),
                        ),
                      if (preferences.isDrinker)
                        InfoItem(
                          label: "Do you drink",
                          value: preferences.getDrink(),
                        ),
                      if (preferences.isWorkout)
                        InfoItem(
                          label: "Workout",
                          value: preferences.getWorkOut(),
                        ),
                      if (preferences.isPetOwner)
                        InfoItem(
                          label: "Pet owner",
                          value: preferences.getPetOwner(),
                        ),
                    ],
                  ),
                ),
              if (!isSameUser) ...[
                AppButton(
                  color: AppColors.listTileColor,
                  onPress: blockUser,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      svgIcon(AppAssets.blockUser,
                          color: Colors.black, size: 21.r),
                      addWidth(10),
                      Text(
                        'Block $name',
                        style: TextStyles.prefText.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                addHeight(14),
                AppButton(
                  color: AppColors.listTileColor,
                  onPress: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.report, height: 26),
                      addWidth(10),
                      Text(
                        "Report $name",
                        style: TextStyles.buttonText.copyWith(
                          fontSize: AppUtils.scale(17),
                          color: AppColors.buttonColor,
                        ),
                      ),
                    ],
                  ),
                ),
                addHeight(28),
              ],
            ],
          ),
        )
      ],
    );
  }
}

class Interests extends HookWidget {
  const Interests({
    super.key,
    required this.interests,
    required this.isSameUser,
  });

  final List<String> interests;
  final bool isSameUser;

  @override
  Widget build(BuildContext context) {
    final showAll = useState(false);

    return ProfileDetailsCard(
      title: 'Interests',
      contentSpacing: 10,
      titleImage: AppAssets.interests,
      content: Selector<EditProfileNotifier, List<String>?>(
        selector: (_, editProfile) => editProfile.coreProfile?.interests,
        builder: (_, interests, __) {
          // Determine which interests to show based on the state
          final displayedInterests =
              showAll.value ? this.interests : this.interests.take(6).toList();

          return Column(
            children: [
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  ...displayedInterests.map((item) {
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
                        // Show star if item exists in interests
                        if (!isSameUser &&
                            interests != null &&
                            interests.contains(item))
                          Positioned(
                            top: -2,
                            right: -6,
                            child: SvgPicture.asset(
                              AppAssets.star,
                              width: 14,
                            ),
                          ),
                      ],
                    );
                  }),
                  if (this.interests.length > 6)
                    GestureDetector(
                      onTap: () => showAll.value = !showAll.value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.transparent,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 6.r,
                          horizontal: 2.r,
                        ),
                        child: Text(
                          showAll.value ? 'see less' : 'see all',
                          style: TextStyles.hintText.copyWith(
                            fontSize: AppUtils.scale(10.sp),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
