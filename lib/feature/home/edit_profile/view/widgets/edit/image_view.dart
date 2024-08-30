import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class ImageView extends StatelessWidget {
  const ImageView({
    super.key,
    this.iconSize,
    required this.profilePics,
    required this.index,
    this.fit = BoxFit.cover,
    this.isDragged = false,
    this.onEditTap,
  });

  final int index;
  final BoxFit fit;
  final double? iconSize;
  final bool isDragged;
  final List<String> profilePics;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    final imageLength = profilePics.length;
    final image = profilePics[index];

    Size dimensions = Size.zero;
    if (isDragged || !image.isUrl) dimensions = AppUtils.getDimensions(index);

    return Stack(
      children: [
        if (imageLength > index)
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: editMediaDecoration,
            child: image.isUrl
                ? CachedNetworkImage(
                    imageUrl: image,
                    imageBuilder: (_, imageProvider) {
                      return Container(
                        height: isDragged ? dimensions.height : null,
                        width: isDragged ? dimensions.width : null,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: fit,
                          ),
                        ),
                      );
                    },
                    placeholder: (_, __) => const ShimmerWidget.rectangular(),
                    errorWidget: (_, __, ___) {
                      return SizedBox.expand(
                        child: Icon(
                          Icons.cloud_off_rounded,
                          size: iconSize ?? 32.r,
                          color: AppColors.outlinedColor,
                        ),
                      );
                    },
                  )
                : Image.file(
                    File(image),
                    fit: BoxFit.cover,
                    width: dimensions.width,
                    height: dimensions.height,
                  ),
          )
        else
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: editMediaDecoration,
          ),
        if (!isDragged) ...[
          Positioned(
            child: Container(
              padding: EdgeInsets.only(
                bottom: 3.5.r,
                right: 3.5.r,
              ),
              decoration: const BoxDecoration(
                color: AppColors.listTileColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: SvgPicture.asset(
                AppAssets.dots,
                width: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.hintTextColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Positioned(
            child: SizedBox(
              height: 50,
              width: 50,
              child: GestureDetector(
                onTap: onEditTap,
              ),
            ),
          ),
        ]
      ],
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, this.onCamTap});

  final VoidCallback? onCamTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: editMediaDecoration,
      child: Stack(
        children: [
          Positioned(
            child: Container(
              padding: EdgeInsets.only(
                bottom: 3.5.r,
                right: 3.5.r,
              ),
              decoration: const BoxDecoration(
                color: AppColors.listTileColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: SvgPicture.asset(
                AppAssets.cam1,
                width: 28,
                colorFilter: const ColorFilter.mode(
                  AppColors.hintTextColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Positioned(
            child: SizedBox(
              height: 50,
              width: 50,
              child: GestureDetector(
                onTap: onCamTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
