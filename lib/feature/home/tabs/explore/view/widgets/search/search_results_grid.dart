import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../../../../../common/components/components.dart';
import '../../../../../../../common/styles/text_style.dart';
import '../../../../../../../common/utils/router/router.gr.dart';
import '../../../../../../../common/utils/utils.dart';
import '../../../../../../../constants/index.dart';
import '../../../data/state/user_search_notifier.dart';
import '../../../model/user_search_result.dart';
import '../grid/helpers/index.dart';

/// Replaces the Explore grid while a name is typed in the search box.
class SearchResultsGrid extends StatelessWidget {
  const SearchResultsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final search = context.watch<UserSearchNotifier>();

    final Widget child = switch (search.status) {
      UserSearchStatus.idle => const SizedBox.shrink(key: ValueKey('search-idle')),
      UserSearchStatus.tooShort => const _SearchMessage(
          key: ValueKey('search-short'),
          title: 'Type at least $minSearchLetters letters',
          message: 'Search by first name, last name, or both.',
        ),
      UserSearchStatus.loading => const LoadingGrid(key: ValueKey('search-loading')),
      UserSearchStatus.error => _SearchMessage(
          key: const ValueKey('search-error'),
          title: "Search didn't work",
          message: search.error ?? 'Please try again.',
        ),
      UserSearchStatus.done when search.results.isEmpty => _SearchMessage(
          key: const ValueKey('search-empty'),
          title: 'No one found for “${search.term.trim()}”',
          message:
              "Check the spelling, or try just their first or last name. People who've turned off Public search don't appear.",
        ),
      UserSearchStatus.done => _ResultsGrid(
          key: ValueKey('search-results-${search.term}'),
          results: search.results,
        ),
    };

    return AppAnimatedSwitcher(child: child);
  }
}

class _ResultsGrid extends StatefulWidget {
  final List<UserSearchResult> results;

  const _ResultsGrid({super.key, required this.results});

  @override
  State<_ResultsGrid> createState() => _ResultsGridState();
}

class _ResultsGridState extends State<_ResultsGrid> {
  static const pageName = 'ExploreSearch';
  String? _opening;

  Future<void> _open(UserSearchResult result) async {
    if (_opening != null) return;
    setState(() => _opening = result.uid);
    try {
      final liked = await context.read<UserSearchNotifier>().openProfile(result.uid);
      if (!mounted) return;
      if (liked == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This profile is no longer available.')),
        );
        return;
      }
      await Nav.push(
        context,
        MatchingProfilePreview(
          index: 0,
          userProfile: liked.profile,
          pageName: pageName,
          isLiked: liked.isLiked,
          usePageView: true,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't open this profile. Please try again.")),
      );
    } finally {
      if (mounted) setState(() => _opening = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int columns = (MediaQuery.sizeOf(context).width ~/ 160.r).toInt();
    final heights = [180.h, 220.h, 240.h];
    final count = widget.results.length;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              count == 1 ? '1 person' : '$count people',
              style: TextStyles.prefText.copyWith(fontSize: 13, color: AppColors.hintTextColor),
            ),
          ),
        ),
        SliverMasonryGrid.count(
          crossAxisCount: columns,
          crossAxisSpacing: 7.w,
          childCount: count,
          itemBuilder: (context, index) {
            final result = widget.results[index];
            return Hero(
              tag: '${result.uid}$pageName',
              child: GestureDetector(
                onTap: () => _open(result),
                child: Container(
                  margin: EdgeInsets.only(bottom: 7.h),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
                  height: heights[index % heights.length],
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      result.photo == null
                          ? offline(size: 24)
                          : CachedNetworkImage(
                              imageUrl: result.photo!,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => const ShimmerWidget.rectangular(),
                              errorWidget: (_, __, ___) => offline(size: 24),
                            ),
                      ProfileShade(heightFactor: 0.35, gradient: AppColors.likesAndMatchShade),
                      _ResultName(result: result),
                      if (_opening == result.uid)
                        const ColoredBox(
                          color: Color(0x55000000),
                          child: Center(
                            child: SizedBox.square(
                              dimension: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ResultName extends StatelessWidget {
  final UserSearchResult result;

  const _ResultName({required this.result});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 6, right: 10),
        child: Material(
          type: MaterialType.transparency,
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: result.age != null ? '${result.firstName}, ' : result.firstName,
              style: TextStyles.profileHead.copyWith(
                fontSize: AppUtils.scale(14.sp),
                color: Colors.white,
              ),
              children: [
                if (result.age != null)
                  TextSpan(
                    text: '${result.age}',
                    style: TextStyles.profileHead.copyWith(
                      fontSize: AppUtils.scale(12.sp) ?? 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchMessage extends StatelessWidget {
  final String title;
  final String message;

  const _SearchMessage({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppAssets.noLikes, height: 100.r),
            addHeight(12),
            Text(
              title,
              style: TextStyles.prefText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            addHeight(6),
            Text(
              message,
              style: TextStyles.prefText.copyWith(fontSize: 13, color: AppColors.hintTextColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
