import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';

import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import 'bottom_preview_image.dart';

class PreviewImage extends StatefulWidget {
  const PreviewImage({super.key});

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  double _dragExtent = 0.0;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'preview',
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(32.r, 24.r, 32.r, 0),
            child: const ProfileCard(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 0),
            child: const ProfileCard(color: Color(0xFFE7E7E7)),
          ),
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy < 0) {
                _dragExtent += details.primaryDelta!.abs();
              }
            },
            onVerticalDragEnd: (details) {
              if (_dragExtent > 20) {
                Nav.push(context, const PreviewProfileMore());
              }
              _dragExtent = 0;
            },
            child: ProfileCard(
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: Image.asset(
                      AppAssets.profilePic,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const ProfileShade(heightFactor: 0.35),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: BottomPreviewImage(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
