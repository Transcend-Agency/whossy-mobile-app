import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../../../../../common/components/index.dart';

class LoadingGrid extends StatelessWidget {
  const LoadingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    int columns = (MediaQuery.sizeOf(context).width ~/ 160.r).toInt();
    final List<double> predefinedHeights = [180.h, 220.h, 240.h];

    return MasonryGridView.count(
      key: const ValueKey('loading'),
      crossAxisCount: columns,
      mainAxisSpacing: 6.h,
      crossAxisSpacing: 6.w,
      itemCount: 12,
      itemBuilder: (context, index) {
        final height = predefinedHeights[index % predefinedHeights.length];

        return ShimmerWidget.rectangular(
          height: height,
          border: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        );
      },
    );
  }
}
