import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../data/source/likes_mock_data.dart';

class LikesGridView extends StatelessWidget {
  const LikesGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (MediaQuery.of(context).size.width ~/ 160.r).toInt(),
          crossAxisSpacing: 8.w, // Spacing between columns
          mainAxisSpacing: 8.h, // Spacing between rows
          childAspectRatio: 1.15,
        ),
        itemCount: likeItems.length,
        itemBuilder: (context, index) {
          final item = likeItems[index];
          return Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  item.imageUrl,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  color: Colors.white.withOpacity(0.2),
                                  child: Text(
                                    'View',
                                    style: TextStyles.hintThemeText.copyWith(
                                      fontSize: AppUtils.scale(9.sp) ?? 13.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${item.name}, ',
                                  style: TextStyles.profileHead.copyWith(
                                    fontSize: AppUtils.scale(14.sp),
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${item.age}',
                                  style: TextStyles.profileHead.copyWith(
                                    fontSize: AppUtils.scale(12.sp) ?? 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                addWidth(6),
                                if (item.isVerified)
                                  SvgPicture.asset(
                                    AppAssets.tick,
                                    width: 18,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
