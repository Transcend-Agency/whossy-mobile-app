import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/constants/extras.dart';

import '../../../common/utils/index.dart';

class MeetScreen extends StatefulWidget {
  const MeetScreen({super.key});

  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> {
  Meet? _meet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "Who do you want to meet ?",
          subtitle:
              'This allows us to suggest the right people for you. You can always change this later.',
        ),
        addHeight(24),
        ListView(
          shrinkWrap: true,
          children: AppConstants.meetData.map((data) {
            return GenderTile(
              value: data.value,
              groupValue: _meet,
              onChanged: (value) {
                setState(() => _meet = value);
              },
              title: data.text,
              leadingWidget: data.icon != null
                  ? Icon(
                      data.icon,
                      size: 26.r,
                    )
                  : Padding(
                      padding: EdgeInsets.only(left: 6.w),
                      child: SvgPicture.asset(
                        data.asset!,
                        width: 20.r,
                        height: 20.r,
                      ),
                    ),
            );
          }).toList(),
        ),
        const Spacer(),
      ],
    );
  }
}
