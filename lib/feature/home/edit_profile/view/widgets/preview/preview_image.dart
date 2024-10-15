import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/feature/home/edit_profile/model/core_profile.dart';
import 'package:whossy_app/feature/home/edit_profile/view/widgets/edit/image_view.dart';
import 'package:whossy_app/provider/providers.dart';

import 'bottom_preview_image.dart';

class PreviewImage extends StatefulWidget {
  const PreviewImage({super.key});

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  int _activePage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _activePage);
  }

  void _onPageChange(int page) => setState(() => _activePage = page);

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
          Selector<EditProfileNotifier, CoreProfile>(
            selector: (_, editProfile) => editProfile.coreProfile!,
            builder: (_, profile, __) {
              final images = profile.profilePics;
              return ProfileCard(
                color: Colors.white,
                child: Stack(
                  children: [
                    PageView.builder(
                      key: const PageStorageKey("my_pageView"),
                      controller: _pageController,
                      onPageChanged: _onPageChange,
                      itemCount: profile.profilePics?.length,
                      itemBuilder: (_, index) {
                        return SizedBox.expand(
                          child: Preview(
                            image: images![index],
                          ),
                        );
                      },
                    ),
                    const ProfileShade(heightFactor: 0.35),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: BottomPreviewImage(
                        profile: profile,
                        activePage: _activePage,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
