import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/utils/index.dart';
import 'package:whossy_mobile_app/provider/providers.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../constants/index.dart';
import '../../../../auth/onboarding/model/meet_model.dart';

class MeetComponent extends StatefulWidget {
  const MeetComponent({super.key});

  @override
  State<MeetComponent> createState() => _MeetComponentState();
}

class _MeetComponentState extends State<MeetComponent> {
  Meet? meet;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(
          color: AppColors.outlinedColor,
          height: 0,
        ),
        Container(
          decoration: const BoxDecoration(color: AppColors.inputBackGround),
          padding: EdgeInsets.all(14.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'I want to meet',
                style: TextStyles.prefText,
              ),
              addHeight(10.h),
              Consumer<UserNotifier>(
                builder: (_, user, __) {
                  return Wrap(
                    spacing: 10,
                    runSpacing: 8.0,
                    children: AppConstants.meetData
                        .map((_) => _buildGenderChip(_, user))
                        .toList(),
                  );
                },
              )
            ],
          ),
        ),
        const Divider(
          color: AppColors.outlinedColor,
          height: 0,
        ),
      ],
    );
  }

  Widget _buildGenderChip(MeetModel data, UserNotifier user) {
    return GenderChip(
      value: data.value,
      groupValue: meet,
      onChanged: (_) {
        setState(() => meet = _);
        user.updatePreferences(meet: _?.index);
      },
      title: data.value.name,
      leadingWidget: data.icon != null
          ? Icon(
              data.icon,
              size: 24.r,
              color: data.value == meet ? Colors.white : null,
            )
          : Padding(
              padding: const EdgeInsets.only(right: 3, left: 2),
              child: Transform.scale(
                scale: 0.85,
                child: SvgPicture.asset(
                  data.asset!,
                  width: 20.r,
                  height: 20.r,
                  colorFilter: ColorFilter.mode(
                    data.value == meet ? Colors.white : Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
    );
  }
}
