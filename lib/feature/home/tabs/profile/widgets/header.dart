import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../constants/index.dart';
import '../../../../../common/utils/router/router.dart';
import '../../../../../common/utils/router/router.gr.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: 130.r,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.square(
                    dimension: 120.r,
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
                    dimension: 115.r,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset('assets/images/sp_1_2.png'),
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
    );
  }
}
