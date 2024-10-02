import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../utils/index.dart';
import '../index.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.radius = 22,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius.r,
        backgroundColor: AppColors.listTileColor,
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                imageBuilder: (_, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                placeholder: (context, url) => const ShimmerWidget.circular(),
                errorWidget: (_, __, ___) => offline(size: 28),
              )
            : user(size: 30.r));
  }
}
