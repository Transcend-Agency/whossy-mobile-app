import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.radius = 23,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 30.r,
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
