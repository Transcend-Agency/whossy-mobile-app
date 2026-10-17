import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/profile_data_footer.dart';

import '../../../../../constants/index.dart';
import '../../../../../provider/provider.dart';
import '../../../../styles/text_style.dart';
import '../../../../utils/utils.dart';
import '../../../components.dart';

typedef TapCallback = void Function(BuildContext context, int index);

class ProfileFooterScaffold extends StatelessWidget {
  const ProfileFooterScaffold({
    super.key,
    this.showLess = false,
    this.isSameUser = false,
    this.activePage,
    required this.data,
    this.onTap,
  }) : assert(showLess && onTap == null || !showLess && onTap != null,
            'onTap must be null when showLess is true, and must not be null when showLess is false.'); // Assign the callback after the assertion

  final bool showLess;
  final int? activePage;
  final bool isSameUser;
  final TapCallback? onTap;
  final ProfileDataFooter data;

  @override
  Widget build(BuildContext context) {
    bool hasBio = data.userBio != null && data.userBio!.isNotEmpty;
    bool hasInterests = data.userInterests.isNotEmpty;
    bool hasRelationshipPreference = data.relationshipPreference != null;

    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (data.isOnline)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF103B24),
                        border: Border.all(
                          color: const Color(0xFF09B45A),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 2.h,
                        horizontal: 8.w,
                      ),
                      child: Text(
                        'Active',
                        style: TextStyles.prefText.copyWith(
                          color: const Color(0xFF09B45A),
                          fontSize: AppUtils.scale(9.5.sp) ?? 12.sp,
                        ),
                      ),
                    )
                  else if (data.newUser ?? false)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6.r)),
                        color: AppColors.buttonColor,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.leaf,
                            width: 14,
                          ),
                          addWidth(4),
                          Text(
                            'New',
                            style: TextStyles.prefText.copyWith(
                              color: Colors.white,
                              fontSize: AppUtils.scale(9.5.sp) ?? 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (data.location != null)
                    Selector<EditProfileNotifier, GeoPoint?>(
                      selector: (_, edit) =>
                          edit.staticProfile?.geography?.geopoint,
                      builder: (_, location, __) {
                        if (location == null) return const SizedBox.shrink();

                        final distance = Geolocator.distanceBetween(
                              location.latitude,
                              location.longitude,
                              data.location!.latitude,
                              data.location!.longitude,
                            ) /
                            1000;

                        return Text(
                          "  ~ ${distance.formatDistance()} mi away",
                          style: TextStyles.prefText.copyWith(
                            color: Colors.white,
                            fontSize: AppUtils.scale(9.5.sp) ?? 12.sp,
                          ),
                        );
                      },
                    )
                ],
              ),
              addHeight(2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${data.name}, ',
                        style: TextStyles.profileHead.copyWith(
                          fontSize: AppUtils.scale(23.sp) ?? 25.sp,
                          color: Colors.white,
                        ),
                      ),
                      if (data.userAge != 0) ...[
                        addWidth(4),
                        Text(
                          "${data.userAge}",
                          style: TextStyles.profileHead.copyWith(
                            fontSize: AppUtils.scale(19.sp) ?? 21.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (!showLess &&
                      !hasBio &&
                      !hasInterests &&
                      !hasRelationshipPreference)
                    GestureDetector(
                      onTap: () {
                        if (onTap != null && activePage != null) {
                          onTap!(context, activePage!);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Transform.rotate(
                          angle: 0,
                          child: SvgPicture.asset(
                            AppAssets.down,
                            width: 21,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (showLess)
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Transform.rotate(
                          angle: math.pi,
                          child: SvgPicture.asset(
                            AppAssets.down,
                            width: 21,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (!showLess && hasBio)
                Padding(
                  padding: EdgeInsets.only(bottom: 0.r),
                  child: Row(
                    children: [
                      Expanded(
                        child: ReadMoreText(
                          data.userBio!,
                          trimLines: 2,
                          trimMode: TrimMode.Line,
                          textAlign: TextAlign.left,
                          style: TextStyles.prefText.copyWith(
                            color: Colors.white,
                          ),
                          moreStyle: TextStyles.prefText.copyWith(
                            color: Colors.grey,
                          ),
                          lessStyle: TextStyles.prefText.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      if (!hasInterests && !hasRelationshipPreference)
                        GestureDetector(
                          onTap: () {
                            if (onTap != null && activePage != null) {
                              onTap!(context, activePage!);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Transform.rotate(
                              angle: 0,
                              child: SvgPicture.asset(
                                AppAssets.down,
                                width: 21,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              if (!showLess && (hasInterests || hasRelationshipPreference))
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 14, top: 8),
                      child: SvgPicture.asset(
                        AppAssets.interests,
                        width: 23,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                    Expanded(
                      child: data.userInterests.isNotEmpty ||
                              hasRelationshipPreference
                          ? Interests(
                              interests: data.userInterests,
                              isSameUser: isSameUser,
                              relPreference: data.relationshipPreference ?? 4,
                            )
                          : Container(color: Colors.transparent),
                    ),
                    addWidth(4),
                    GestureDetector(
                      onTap: () {
                        if (onTap != null && activePage != null) {
                          onTap!(context, activePage!);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Transform.rotate(
                          angle: 0,
                          child: SvgPicture.asset(
                            AppAssets.down,
                            width: 21,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (!showLess)
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 20.h),
                  child: PageIndicator(
                    activePage: activePage!,
                    pageNo: data.pictures.length,
                    height: 4,
                    activeColor: Colors.white,
                    inActiveColor: Colors.white.withOpacity(0.5),
                  ),
                )
              else
                addHeight(20)
            ],
          ),
        ),
      ),
    );
  }
}

class Interests extends HookWidget {
  const Interests({
    super.key,
    required this.interests,
    required this.isSameUser,
    required this.relPreference,
    this.limit = 4,
  });

  final List<String> interests;
  final bool isSameUser;
  final int relPreference;
  final int limit;

  @override
  Widget build(BuildContext context) {
    final showAll = useState(false);

    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: Selector<EditProfileNotifier, List<String>?>(
        selector: (_, editProfile) => editProfile.coreProfile?.interests,
        builder: (_, interests, __) {
          // Determine which interests to show based on the state
          final displayedInterests = showAll.value
              ? this.interests
              : this.interests.take(limit).toList();

          return Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: const Color(0xFF101010),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.r),
                      child: Image.asset(
                        'assets/icons/i${relPreference + 1}.png',
                        height: 28.r,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 6.r,
                        horizontal: 8.r,
                      ),
                      child: Text(
                        Preference.values[relPreference].name,
                        style: TextStyles.hintText.copyWith(
                          fontSize: AppUtils.scale(10.sp),
                          color: AppColors.hintTextColor,
                        ),
                      ),
                    ),
                    addWidth(3),
                  ],
                ),
              ),
              ...displayedInterests.map((item) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: const Color(0xFF101010),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 6.r,
                        horizontal: 8.r,
                      ),
                      child: Text(
                        item,
                        style: TextStyles.hintText.copyWith(
                          fontSize: AppUtils.scale(10.sp),
                          color: AppColors.hintTextColor,
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
              if (this.interests.length > limit)
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
          );
        },
      ),
    );
  }
}
