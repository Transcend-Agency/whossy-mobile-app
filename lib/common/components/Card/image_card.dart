import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    super.key,
    this.aspectRatio = 0.85,
    required this.heightFactor,
    required this.rotationAngle,
    required this.x,
    required this.y,
    required this.color,
  });

  final double aspectRatio;
  final double heightFactor;
  final double rotationAngle;
  final double x;
  final double y;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: FractionallySizedBox(
        alignment: Alignment.bottomRight,
        heightFactor: heightFactor,
        child: Transform(
          transform: Matrix4.identity()
            ..translate(x, y)
            ..rotateZ(rotationAngle),
          alignment: Alignment.bottomRight,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18.r),
            ),
          ),
        ),
      ),
    );
  }
}
