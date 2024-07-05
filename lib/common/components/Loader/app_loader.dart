import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.size = 24,
  });
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: size.r,
        child: const CircularProgressIndicator.adaptive(
          strokeWidth: 2.5,
        ),
      ), //
    );
  }
}
