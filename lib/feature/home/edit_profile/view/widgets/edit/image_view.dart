import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';

import '../../../../../../common/components/components.dart';
import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/utils/utils.dart';
import '../../../../../../constants/index.dart';

class ImageView extends StatelessWidget {
  const ImageView({
    super.key,
    required this.profilePics,
    required this.index,
    this.fit = BoxFit.cover,
    this.isDragged = false,
    this.onEditTap,
  });

  final int index;
  final BoxFit fit;
  final bool isDragged;
  final List<String> profilePics;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    final imageLength = profilePics.length;
    final image = profilePics[index];

    Size dimensions = AppUtils.getDimensions(index);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isDragged ? null : onEditTap,
      child: Stack(
        children: [
          if (imageLength > index)
            Container(
              height: dimensions.height,
              width: dimensions.width,
              clipBehavior: Clip.antiAlias,
              decoration: editMediaDecoration,
              child: image.isUrl
                  ? CachedNetworkImage(
                      imageUrl: image,
                      imageBuilder: (_, imageProvider) {
                        return Container(
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
                      errorWidget: (_, __, ___) => offline(),
                    )
                  : Image.file(File(image), fit: BoxFit.cover),
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
                  width: 22,
                  colorFilter: const ColorFilter.mode(
                    AppColors.hintTextColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const Positioned(
              bottom: 6,
              right: 6,
              child: EditBadge(),
            ),
          ]
        ],
      ),
    );
  }
}

/// Always-visible affordance telling the user a photo tile is tappable
/// (opens the edit sheet). Rendered on every filled tile.
class EditBadge extends StatelessWidget {
  const EditBadge({super.key, this.icon});

  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.r,
      height: 28.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
      ),
      child: SvgPicture.asset(
        icon ?? AppAssets.edit,
        width: 14.r,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.onActionTap,
    this.noConnection = false,
    this.imagePath,
  });

  final VoidCallback? onActionTap;

  final String? imagePath;
  final bool noConnection;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onActionTap,
      child: Container(
        decoration: editMediaDecoration,
        child: Stack(
          children: [
            if (imagePath != null && !imagePath!.isUrl)
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: editMediaDecoration,
                child: SizedBox.expand(
                  child: Image.file(File(imagePath!), fit: BoxFit.cover),
                ),
              )
            else if (noConnection)
              SizedBox.expand(child: offline()),
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
                  noConnection ? AppAssets.dots : AppAssets.cam1,
                  width: noConnection ? 22 : 26,
                  colorFilter: const ColorFilter.mode(
                    AppColors.hintTextColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Preview extends StatelessWidget {
  final String image;

  const Preview({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: editMediaDecoration,
      child: image.isUrl
          ? CachedNetworkImage(
              imageUrl: image,
              imageBuilder: (_, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              placeholder: (_, __) => const ShimmerWidget.rectangular(),
              errorWidget: (_, __, ___) => offline(),
            )
          : Image.file(File(image), fit: BoxFit.cover),
    );
  }
}
