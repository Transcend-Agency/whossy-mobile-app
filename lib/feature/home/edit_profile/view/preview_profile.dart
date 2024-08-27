import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/utils/index.dart';

import 'widgets/_.dart';

@RoutePage()
class PreviewProfile extends StatelessWidget {
  const PreviewProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      useScrollView: true,
      padding: EdgeInsets.symmetric(horizontal: 8.r),
      appBar: const CustomAppBar(
        title: 'Preview Profile',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          addHeight(24),
          const PreviewImage(),
        ],
      ),
    );
  }
}
