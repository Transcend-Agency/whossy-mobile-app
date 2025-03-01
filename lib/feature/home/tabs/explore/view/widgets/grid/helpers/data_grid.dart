import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../common/components/index.dart';
import '../../../../../../../../common/utils/index.dart';
import '../../../../../../../../common/utils/router/router.gr.dart';
import '../../../../../../../../constants/index.dart';
import '../../../../data/state/scroll_visibility_notifier.dart';
import '../../../../model/liked_user_profile.dart';
import 'like_icon.dart';
import 'user_details.dart';
import 'user_tags.dart';

class DataGrid extends StatefulWidget {
  final List<LikedUserProfile> tileData;

  const DataGrid({super.key, required this.tileData});

  @override
  State<DataGrid> createState() => _DataGridState();
}

class _DataGridState extends State<DataGrid> {
  final String pageName = 'Explore';
  final List<double> predefinedHeights = [180.h, 220.h, 240.h];

  late ScrollController _scrollController;
  late ScrollVisibilityNotifier _scrollNotifier;

  double _previousOffset = 0;
  DateTime _lastScrollTime = DateTime.now();
  bool _isAppBarHidden = false; // Tracks app bar visibility state

  @override
  void initState() {
    super.initState();
    _scrollNotifier = context.read<ScrollVisibilityNotifier>();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    final currentOffset = _scrollController.offset;
    final currentTime = DateTime.now();

    final timeDiff =
        currentTime.difference(_lastScrollTime).inMilliseconds.abs();
    if (timeDiff == 0) return; // Prevent division by zero

    final speed = (currentOffset - _previousOffset) / timeDiff;

    _previousOffset = currentOffset;
    _lastScrollTime = currentTime;

    // If user is scrolling down fast, hide the app bar
    if (speed > 0.5 && !_isAppBarHidden) {
      _isAppBarHidden = true;
      _scrollNotifier.updateVisibility(false);
    }
    // If user scrolls up fast, show the app bar
    else if (speed < -0.5 && _isAppBarHidden) {
      _isAppBarHidden = false;
      _scrollNotifier.updateVisibility(true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int columns = (MediaQuery.sizeOf(context).width ~/ 160.r).toInt();

    return MasonryGridView.count(
      controller: _scrollController,
      key: const ValueKey('data'),
      crossAxisCount: columns,
      crossAxisSpacing: 7.w,
      itemCount: widget.tileData.length,
      itemBuilder: (context, index) {
        final item = widget.tileData[index];
        final height = predefinedHeights[index % predefinedHeights.length];

        return Hero(
          tag: '${item.profile.user.uid!}$pageName',
          child: GestureDetector(
            onTap: () => Nav.push(
              context,
              MatchingProfilePreview(
                index: 0,
                userProfile: item.profile,
                pageName: pageName,
                isLiked: item.isLiked,
                usePageView: true,
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(bottom: 7.h),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
              ),
              height: height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  (item.profile.preferences.profilePics?.isEmpty ?? true)
                      ? offline(size: 24)
                      : CachedNetworkImage(
                          imageUrl: item.profile.preferences.profilePics![0],
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
                              const ShimmerWidget.rectangular(),
                          errorWidget: (context, url, error) {
                            log('Error loading image: ${error.toString()}');
                            return offline(size: 24);
                          },
                        ),
                  ProfileShade(
                    heightFactor: 0.35,
                    gradient: AppColors.likesAndMatchShade,
                  ),
                  UserTags(userProfile: item.profile),
                  if (item.isLiked) const LikeIcon(),
                  UserDetails(
                    userProfile: item.profile,
                    columnCount: columns,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
