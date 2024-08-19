import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/components/index.dart';

import 'widgets/_.dart';

@RoutePage()
class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      useScrollView: true,
      appBar: const CustomAppBar(
        title: 'Preferences',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: const DistanceAgeComponent(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: const MeetComponent(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: const InterestBioComponent(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: const ExtrasComponent(),
          ),
        ],
      ),
    );
  }
}
