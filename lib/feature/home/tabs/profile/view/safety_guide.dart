import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/utils/index.dart';

import '../../../../../common/styles/component_style.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/providers.dart';
import '../data/source/safety_guide_data.dart';
import '../model/guide_detail.dart';
import 'widgets/_.dart';
import 'widgets/modal_content.dart';

@RoutePage()
class SafetyGuide extends StatefulWidget {
  const SafetyGuide({super.key});

  @override
  State<SafetyGuide> createState() => _SafetyGuideState();
}

class _SafetyGuideState extends State<SafetyGuide> {
  late bool isPrevOpened;
  late EditProfileNotifier _editProfileNotifier;

  Widget get $thisWidget => build(context);

  onGuidelineTap() async {
    await showConfirmationDialog(
      yes: 'Continue',
      headerImage: Padding(
        padding: EdgeInsets.only(bottom: 6.h),
        child: Image.asset(
          AppAssets.welcome,
          height: 120,
        ), //
      ),
      context,
      title: 'Welcome to Whossy',
      content: contentText(AppStrings.mission),
    );
  }

  @override
  void initState() {
    super.initState();
    _editProfileNotifier = context.read<EditProfileNotifier>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        isPrevOpened = _editProfileNotifier.hasSafetyGuideOpened;

        if (!isPrevOpened) {
          await onGuidelineTap();

          _editProfileNotifier.hasSafetyGuideOpened = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      useScrollView: true,
      padding: pagePadding,
      appBar: CustomAppBar(
        addBarHeight: 4,
        title: 'Whossy Safety Guide',
        color: Colors.white,
        action: GestureDetector(
          onTap: onGuidelineTap,
          child: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(AppAssets.guide, width: 20.r),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: guideDetails.asMap().entries.map((entry) {
          int index = entry.key; // Get the index
          GuideDetail guide = entry.value; // Get the guide item
          return GuideTile(
            onPressed: () => onTileTap(guide, index),
            imageAssetPath: guide.imageAssetPath,
            mainText: guide.header,
          );
        }).toList(),
      ),
    );
  }

  void onTileTap(GuideDetail data, int index) {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: 'General Safety Tips',
      context: context,
      transitionDuration: const Duration(milliseconds: 500),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return CupertinoModalTransition(
          animation: animation,
          behindChild: $thisWidget,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return CupertinoFullscreenDialogTransition(
          primaryRouteAnimation: animation,
          secondaryRouteAnimation: secondaryAnimation,
          linearTransition: true,
          child: CupertinoDialogBody(
            child: ModalContent(
              data: data,
              index: index,
            ),
          ),
        );
      },
    );
  }
}
