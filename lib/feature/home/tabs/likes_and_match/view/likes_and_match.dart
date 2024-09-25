import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/feature/home/tabs/likes_and_match/view/widgets/likes.dart';
import 'package:whossy_app/feature/home/tabs/likes_and_match/view/widgets/matches.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';

class LikesAndMatch extends StatefulWidget {
  const LikesAndMatch({super.key});

  @override
  State<LikesAndMatch> createState() => _LikesAndMatchState();
}

class _LikesAndMatchState extends State<LikesAndMatch>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late List<Widget> _pages;

  int _activePage = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _pages = [
      const Likes(),
      const Matches(),
    ];
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
  }

  void _onPageChange(int page) {
    setState(() => _activePage = page);
  }

  void _onPageUpdate(int index) {
    if (index == _activePage) return;

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          addHeight(12),
          Padding(
            padding: pagePadding,
            child: HeaderBar(
              icon: CupertinoIcons.bell_fill,
              child: Row(
                children: [
                  _headerText(0, 'Likes'),
                  _headerText(1, 'Match'),
                ],
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: _onPageChange,
              itemBuilder: (_, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 16.h),
                  child: _pages[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerText(int page, String title) {
    return GestureDetector(
      onTap: () => _onPageUpdate(page),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6,
        ),
        child: Text(
          title,
          style: TextStyles.customStyle(_activePage == page),
        ),
      ),
    );
  }
}
