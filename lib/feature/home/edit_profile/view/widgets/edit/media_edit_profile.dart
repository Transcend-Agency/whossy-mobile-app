import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/utils/index.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../constants/index.dart';

class MediaEditProfile extends StatelessWidget {
  const MediaEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // Fixed total height
    final double totalHeight = ScreenUtil().screenHeight * 0.4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: const BoxDecoration(color: AppColors.inputBackGround),
          padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: totalHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // First Row
                    Expanded(
                      flex: 66,
                      child: Row(
                        children: [
                          // Wide Container
                          Expanded(
                            flex: 6,
                            child: Container(color: Colors.blue),
                          ),

                          addWidth(6),
                          // Two Smaller Containers
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(color: Colors.red),
                                ),
                                addHeight(6),
                                Expanded(
                                  child: Container(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Spacing
                    addHeight(6),

                    // Second Row
                    Expanded(
                      flex: 34,
                      child: Row(
                        children: [
                          // Three Equal Containers
                          Expanded(
                            child: Container(
                              color: Colors.yellow,
                            ),
                          ),
                          addWidth(6),
                          Expanded(
                            child: Container(
                              color: Colors.orange,
                            ),
                          ),
                          addWidth(6),
                          Expanded(
                            child: Container(
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              addHeight(2),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Media(Photo and videos)',
                      style: TextStyles.prefText,
                    ),
                    addWidth(10),
                    AppChip(
                      data: '+40%',
                      isSelected: false,
                      outlined: false,
                      isBold: true,
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
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
        )
      ],
    );
  }
}
