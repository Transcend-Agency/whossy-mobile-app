import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/components/components.dart';
import '../../../../../../common/utils/utils.dart';
import 'grid_view.dart';

class LoadingGridView extends StatelessWidget {
  final double? width;
  final double height;

  const LoadingGridView({
    super.key,
    this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerWidget.rectangular(
          height: height,
          width: width,
          border: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
        ),
        addHeight(14),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: buildGridDelegate(context),
            itemCount: 14,
            itemBuilder: (context, index) {
              return ShimmerWidget.rectangular(
                border: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
