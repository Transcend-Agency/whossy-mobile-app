import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '_helper.dart';

class SplashSlider extends StatelessWidget {
  const SplashSlider({
    super.key,
    required this.scrollController,
    required this.row,
  });

  final ScrollController scrollController;
  final int row;

  @override
  Widget build(BuildContext context) {
    var paths = ImageHelper.getImagePathsForRow(row);

    return SizedBox(
      height: 100.r,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: paths.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(1.5, 6, 1.5, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: Image.asset(
                paths[index],
                fit: BoxFit.fill,
                width: 100.r,
              ),
            ),
          );
        },
      ),
    );
  }
}
