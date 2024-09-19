import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '_helper.dart';

class Marquee extends StatelessWidget {
  const Marquee({
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
            padding: const EdgeInsets.fromLTRB(1.5, 4, 1.5, 0),
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Image.asset(
                paths[index],
                fit: BoxFit.fill,
                width: 100.r,
              ),
            ), //
          );
        },
      ),
    );
  }
}
