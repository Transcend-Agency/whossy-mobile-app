import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/constants/extras.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/data/state/onboarding_notifier.dart';

import '../../../../common/utils/index.dart';

class MeetScreen extends StatefulWidget {
  final int pageIndex;

  const MeetScreen({
    super.key,
    required this.pageIndex,
  });

  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen>
    with AutomaticKeepAliveClientMixin<MeetScreen> {
  Meet? _meet;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            return Consumer<OnboardingNotifier>(
              builder: (_, onboarding, __) {
                return GenericTile(
                  value: data.value,
                  groupValue: _meet,
                  onChanged: (value) {
                    setState(() => _meet = value);
                    onboarding.select(widget.pageIndex);
                    onboarding.updateUserProfile(meet: value?.index);
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
              },
            );
          }).toList(),
        ),
        const Spacer(),
      ],
    );
  }
}