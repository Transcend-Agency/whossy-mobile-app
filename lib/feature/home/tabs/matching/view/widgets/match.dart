import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/feature/home/tabs/matching/view/widgets/bottom_profile_preview.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/providers.dart';
import '../../../../edit_profile/view/widgets/edit/image_view.dart';

class Match extends StatefulWidget {
  const Match({super.key});

  @override
  State<Match> createState() => _MatchState();
}

class _MatchState extends State<Match> {
  final CardSwiperController controller = CardSwiperController();
  double thresholdX = 0.0;
  int _activePage = 0;
  late PageController _pageController;

  bool _isSwiping = false;

  // Setter for isSwiping
  set isSwiping(bool value) => setState(() => _isSwiping = value);

  void updateThresholds(double x) {
    if (x != 0) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => setState(() => thresholdX = x));
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatchNotifier>().fetchInitialProfiles();
    });

    _pageController = PageController(initialPage: _activePage);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onPageChange(int page) => setState(() => _activePage = page);

  showSnackbar(String message) {
    if (mounted) {
      showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
    }
  }

  // double _calculateScale(double thresholdX) {
  //   // You can adjust these values to fit your design
  //   return 1 +
  //       (thresholdX / 100)
  //           .clamp(0.0, 1.0); // Scale increases as thresholdX increases
  // }
  //
  // double _calculateOpacity(double thresholdX) {
  //   // Fades out based on thresholdX
  //   return (1 - (thresholdX / 100))
  //       .clamp(0.0, 1.0); // Fades out as thresholdX increases
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchNotifier>(
      builder: (context, matchNotifier, child) {
        return Stack(
          children: [
            Column(
              children: [
                if (matchNotifier.isLoading)
                  const Flexible(
                    child: Center(
                      child: AppLoader(color: AppColors.primaryColor),
                    ),
                  )
                else if (matchNotifier.profiles.isEmpty)
                  const SizedBox.shrink()
                else
                  Flexible(
                    child: CardSwiper(
                      controller: controller,
                      padding: const EdgeInsets.only(top: 32, bottom: 20),
                      cardsCount: matchNotifier.profiles.length,
                      numberOfCardsDisplayed: 3,
                      threshold: 100,
                      onSwipe: (index, previousIndex, direction) async {
                        if (direction == CardSwiperDirection.right ||
                            direction == CardSwiperDirection.left ||
                            direction == CardSwiperDirection.none) {
                          isSwiping = false;
                        }
                        if (direction == CardSwiperDirection.right ||
                            direction == CardSwiperDirection.left) {
                          _onPageChange(0);
                        }

                        if (direction == CardSwiperDirection.right) {
                          matchNotifier.addLike(
                            matchNotifier.profiles[index].user.uid!,
                            showSnackbar: showSnackbar,
                          );
                        }

                        // Pagination trigger when near the end
                        if (index >= matchNotifier.profiles.length - 2 &&
                            matchNotifier.hasMoreProfiles) {
                          await matchNotifier.fetchMoreProfiles();
                        }
                        return true; // Proceed with swipe
                      },
                      onSwipeDirectionChange:
                          (currentDirection, initialDirection) {
                        if (currentDirection == CardSwiperDirection.left ||
                            currentDirection == CardSwiperDirection.right) {
                          isSwiping = true;
                        } else if (currentDirection ==
                            CardSwiperDirection.none) {
                          isSwiping = false;
                        }
                      },
                      cardBuilder: (
                        context,
                        index,
                        percentThresholdX,
                        percentThresholdY,
                      ) {
                        updateThresholds(percentThresholdX.toDouble());

                        final profileData = matchNotifier.profiles[index];

                        return ProfileCard(
                          color: Colors.white,
                          child: Stack(
                            children: [
                              PageView.builder(
                                key: const PageStorageKey("my_pageView"),
                                controller: _pageController,
                                onPageChanged: _onPageChange,
                                itemCount:
                                    profileData.preferences.profilePics?.length,
                                itemBuilder: (_, index) {
                                  return SizedBox.expand(
                                    child: Preview(
                                      image: profileData.preferences
                                              .profilePics?[index] ??
                                          '',
                                    ),
                                  );
                                },
                              ),
                              ProfileShade(
                                heightFactor: 0.35,
                                gradient: AppColors.profileShade,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: BottomProfilePreview(
                                  userProfile: profileData,
                                  activePage: _activePage,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      backCardOffset: const Offset(0, 46),
                      allowedSwipeDirection:
                          const AllowedSwipeDirection.symmetric(
                              horizontal: true),
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: !_isSwiping ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: MatchIconButton(
                    size: 24,
                    padding: 8,
                    onTap: () => controller.undo(),
                    assetPath: AppAssets.redo,
                  ),
                ),
                addWidth(16),
                AnimatedOpacity(
                  opacity: (!_isSwiping || thresholdX < 0) ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: MatchIconButton(
                    onTap: () => controller.swipe(CardSwiperDirection.left),
                    assetPath: AppAssets.cancel,
                  ),
                ),
                addWidth(24),
                AnimatedOpacity(
                  opacity: (!_isSwiping || thresholdX > 0) ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: MatchIconButton(
                    onTap: () => controller.swipe(CardSwiperDirection.right),
                    assetPath: AppAssets.like,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
