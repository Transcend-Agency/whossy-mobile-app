import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whossy_app/common/components/cupertino_model_route.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/feature/home/tabs/profile/model/guide_detail.dart';
import 'package:whossy_app/feature/home/tabs/profile/view/widgets/modal_content.dart';

import '../../../../../common/styles/component_style.dart';
import '../../../../../constants/index.dart';
import '../data/source/safety_guide_data.dart';
import 'widgets/_.dart';

@RoutePage()
class SafetyGuide extends StatefulWidget {
  const SafetyGuide({super.key});

  @override
  State<SafetyGuide> createState() => _SafetyGuideState();
}

class _SafetyGuideState extends State<SafetyGuide> {
  Widget get $thisWidget => build(context);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        useScrollView: true,
        padding: pagePadding,
        appBar: CustomAppBar(
          title: 'Whossy Safety Guide',
          color: Colors.white,
          action: Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: SvgPicture.asset(AppAssets.guide, width: 20.r),
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
        ));
  }

  void onTileTap(GuideDetail data, int index) {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: 'General Safety Tips',
      barrierColor: Colors.blue,
      context: context,
      transitionDuration: const Duration(milliseconds: 500),

      /// Optionally provide the [transitionBuilder] to get the stacking effect
      /// as of iOS 13
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

Future<void> openView(BuildContext context, GuideDetail data, int index) async {
  await showSnapModelBottomSheet(
    context: context,
    enableDrag: true,
    useRootNavigator: true,
    elevation: 10,
    backgroundColor: Colors.black.withOpacity(.8),
    builder: (_) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.92,
      child: ModalContent(data: data, index: index),
    ),
  );
}
