import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:whossy_app/common/utils/index.dart';
import 'package:whossy_app/feature/home/edit_profile/data/state/edit_profile_notifier.dart';
import 'package:whossy_app/feature/home/edit_profile/view/widgets/_.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../constants/index.dart';
import '../model/edit_profile_data.dart';
import '../model/info_item.dart';
import 'widgets/edit/image_view.dart';

@RoutePage()
class PreviewProfileMore extends StatefulWidget {
  const PreviewProfileMore({super.key, required this.index});

  final int index;

  @override
  State<PreviewProfileMore> createState() => _PreviewProfileMoreState();
}

class _PreviewProfileMoreState extends State<PreviewProfileMore> {
  late final ScrollController _scrollController;
  bool _isAtTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      applyTop: false,
      useScrollView: false,
      body: NotificationListener<ScrollNotification>(
        onNotification: (_) {
          if (_ is ScrollUpdateNotification) {
            _isAtTop = _scrollController.position.pixels ==
                _scrollController.position.minScrollExtent;

            if (_isAtTop) Navigator.pop(context);
          }
          return true;
        },
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Selector<EditProfileNotifier, EditProfileData>(
              selector: (_, editProfile) => EditProfileData(
                editProfile.coreProfile!,
                editProfile.corePrefs!,
              ),
              builder: (_, data, __) {
                final profile = data.profile;
                final preferences = data.preferences;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Hero(
                      tag: 'preview',
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(32.r, 24.r, 32.r, 0),
                            child: const ProfileCard(),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 0),
                            child: const ProfileCard(color: Color(0xFFE7E7E7)),
                          ),
                          ProfileCard(
                            bottomOnly: true,
                            child: Stack(
                              children: [
                                SizedBox.expand(
                                  child: Preview(
                                    image: profile.profilePics![widget.index],
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
                        ],
                      ),
                    ),
                    addHeight(20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                                    preferences.relationshipPreference?.name ??
                                        'Not set',
                                    style: TextStyles.prefText.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                                InfoItem(
                                    label: "Stays in", value: "Lagos, Nigeria"),
                                InfoItem(
                                  label: "Gender",
                                  value: profile.gender,
                                ),
                                if (preferences.education != null)
                                  InfoItem(
                                    label: "Education",
                                    value: preferences.education!.name,
                                  ),
                              ],
                            ),
                          ),
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
                                children:
                                    profile.interests!.take(8).map((item) {
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
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
                                      // if (item.isSimilar)
                                      //   Positioned(
                                      //     top: -2,
                                      //     right: -6,
                                      //     child: SvgPicture.asset(
                                      //       AppAssets.star,
                                      //       width: 16.r,
                                      //     ),
                                      //   ),
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
                                    label: "Smoker",
                                    value: preferences.smoker!.name,
                                  ),
                                if (preferences.drinking != null)
                                  InfoItem(
                                    label: "Do you drink",
                                    value: preferences.drinking!.name,
                                  ),
                                if (preferences.workout != null)
                                  InfoItem(
                                    label: "Workout",
                                    value: preferences.workout!.name,
                                  ),
                                if (preferences.petOwner != null)
                                  InfoItem(
                                    label: "Pet owner",
                                    value: preferences.petOwner!.name,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            )),
      ),
    );
  }
}

final List<Interest> interestData = [
  Interest(name: "Netflix", isSimilar: true),
  Interest(name: "Travelling"),
  Interest(name: "Hiking", isSimilar: true),
  Interest(name: "Chilling"),
  Interest(name: "Skating"),
  Interest(name: "Dancing", isSimilar: true),
];
