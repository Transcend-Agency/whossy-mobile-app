import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final String assetPath;
  final double size;
  final double padding;
  final Color backgroundColor;
  final List<BoxShadow>? shadow;

  const MatchIconButton({
    super.key,
    required this.onTap,
    required this.assetPath,
    this.size = 40.0,
    this.padding = 12.0,
    this.backgroundColor = Colors.white,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          boxShadow: shadow,
        ),
        child: Image.asset(
          assetPath,
          width: size.r,
        ),
      ),
    );
  }
}
