import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    this.size = 25,
    this.icon,
    this.onTap,
    this.margin = 8,
    this.path,
  });

  final double size;
  final double margin;
  final IconData? icon;
  final String? path;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(margin),
        child: path != null
            ? SvgPicture.asset(path!, width: size)
            : Icon(icon, size: size),
      ),
    );
  }
}
