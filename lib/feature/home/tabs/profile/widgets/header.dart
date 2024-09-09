import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../../../constants/index.dart';
import '../../../../../common/components/Shimmer/shimmer_widget.dart';
import '../../../../../common/utils/router/router.dart';
import '../../../../../common/utils/router/router.gr.dart';
import '../../../../../common/utils/widget_functions.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: 140.r,
        child: GestureDetector(
          onTap: () => Nav.push(context, const EditProfile()),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.square(
                      dimension: 140.r,
                      child: Transform.rotate(
                        angle: pi,
                        child: const CircularProgressIndicator(
                          value: 0.25,
                          strokeCap: StrokeCap.round,
                          strokeWidth: 6,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor,
                          ),
                          backgroundColor: AppColors.selectedFieldColor,
                        ),
                      ),
                    ),
                    SizedBox.square(
                      dimension: 136.r,
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Selector<EditProfileNotifier, List<String>?>(
                          selector: (_, profile) =>
                              profile.staticProfile?.profilePics,
                          builder: (_, profilePics, __) {
                            if (profilePics != null && profilePics.isNotEmpty) {
                              final image = profilePics[0];
                              return CachedNetworkImage(
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
                                placeholder: (_, __) =>
                                    const ShimmerWidget.circular(),
                                errorWidget: (_, __, ___) => offline(size: 28),
                              );
                            } else {
                              // Handle case where there are no profile pics
                              return user(size: 40.r);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -6,
                top: -8,
                child: GestureDetector(
                  onTap: () => Nav.push(context, const EditProfile()),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    child: SvgPicture.asset(
                      AppAssets.edit,
                      height: 40.r,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
