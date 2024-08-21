import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/styles/component_style.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../common/utils/router/router.gr.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/providers.dart';

class InterestsTile extends StatefulWidget {
  const InterestsTile({super.key});

  @override
  State<InterestsTile> createState() => _InterestsTileState();
}

class _InterestsTileState extends State<InterestsTile> {
  late EditProfileNotifier _editNotifier;
  late List<String>? _interests;

  void updateInterests() async {
    _interests = await context.router
            .push<List<String>>(InterestRoute(initialValues: _interests)) ??
        _interests;

    _editNotifier.updateProfile(interests: _interests);
  }

  @override
  void initState() {
    _editNotifier = Provider.of<EditProfileNotifier>(context, listen: false);

    _interests = _editNotifier.coreProfile.interests;
    super.initState();
  }

  String getSelectionStatus(List<String>? items) => items == null
      ? "Choose"
      : (items.length < 10 ? "${items.length} Selected" : "10+ Selected");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: updateInterests,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            color: AppColors.outlinedColor,
            height: 0,
          ),
          Container(
            decoration: const BoxDecoration(color: AppColors.inputBackGround),
            padding: pagePadding.copyWith(top: 13.r, bottom: 13.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Interests',
                      style: TextStyles.prefText,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SvgPicture.asset(AppAssets.interests, width: 18),
                    ),
                    AppChip(
                      data: '+40',
                      isSelected: false,
                      outlined: false,
                      isBold: true,
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Selector<EditProfileNotifier, List<String>?>(
                      selector: (_, edit) => edit.coreProfile.interests,
                      builder: (_, data, __) {
                        return Text(
                          getSelectionStatus(data),
                          style: (TextStyles.prefText).copyWith(
                            color: AppColors.hintTextColor,
                          ),
                        );
                      },
                    ),
                    addWidth(6),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.hintTextColor,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.outlinedColor,
            height: 0,
          ),
        ],
      ),
    );
  }
}