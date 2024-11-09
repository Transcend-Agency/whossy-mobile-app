import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constants/index.dart';
import '../../utils/index.dart';
import '../index.dart';

class RectangleAppAvatar extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const RectangleAppAvatar({
    super.key,
    this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.listTileColor,
        borderRadius: borderRadius,
      ),
      child: imageUrl != null
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              imageBuilder: (_, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              placeholder: (context, url) => ShimmerWidget.rectangular(
                border: RoundedRectangleBorder(borderRadius: borderRadius),
              ),
              errorWidget: (_, __, ___) => offline(size: height * 0.4),
            )
          : user(size: height * 0.4),
    );
  }
}
