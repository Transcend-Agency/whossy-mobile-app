import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../common/utils/router/router.gr.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/providers.dart';
import '../../../../edit_profile/view/widgets/edit/image_view.dart';
import '../../../../tutorial.dart';
import '../../model/user_profile.dart';

class Match extends StatefulWidget {
  const Match({super.key});

  @override
  State<Match> createState() => _MatchState();
}

class _MatchState extends State<Match> {
  final CardSwiperController controller = CardSwiperController();
  final PageController _pageController = PageController();
  late SwipeAndMatchNotifier matchNotifier;

  final currentProfile = ValueNotifier<UserProfile?>(null);
  final fetchedProfiles = ValueNotifier<List<UserProfile>>([]);

  double thresholdX = 0.0;
  int _activePage = 0;
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
      matchNotifier = context.read<SwipeAndMatchNotifier>();

      matchNotifier.fetchProfiles();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChange(int page) => setState(() => _activePage = page);

  showSnackbar(String message) {
    if (mounted) {
      showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
    }
  }

  void like({String? id}) {
    if (currentProfile.value != null) {
      matchNotifier.addLike(
        id ?? currentProfile.value!.user.uid!,
        showSnackbar: showSnackbar,
      );
    }
  }

  void dislike({String? id}) {
    if (currentProfile.value != null) {
      matchNotifier.addDislike(
        id ?? currentProfile.value!.user.uid!,
        showSnackbar: showSnackbar,
      );
    }
  }

  void undo() {
    matchNotifier.undoLastAction(showSnackbar: showSnackbar);
  }

  Future<bool> handleSwipe(
    int index,
    int? previousIndex,
    CardSwiperDirection direction,
  ) async {
    log('Index: $index and previous index  $previousIndex');
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
      like(id: fetchedProfiles.value[index].user.uid);
    }

    if (direction == CardSwiperDirection.left) {
      dislike(id: fetchedProfiles.value[index].user.uid);
    }

    return true;
  }

  void handleSwipeDirectionChange(
    CardSwiperDirection currentDirection,
    CardSwiperDirection initialDirection,
  ) {
    if (currentDirection == CardSwiperDirection.left ||
        currentDirection == CardSwiperDirection.right) {
      isSwiping = true;
    } else if (currentDirection == CardSwiperDirection.none) {
      isSwiping = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<SwipeAndMatchNotifier, Stream<List<UserProfile>>>(
      selector: (_, notifier) => notifier.profileStream,
      builder: (_, stream, __) {
        return StreamBuilder<List<UserProfile>>(
          stream: stream,
          builder: (context, snapshot) {
            return AppAnimatedSwitcher(
              child: _buildContentBasedOnSnapshot(context, snapshot),
            );
          },
        );
      },
    );
  }

  Widget _buildContentBasedOnSnapshot(
    BuildContext context,
    AsyncSnapshot<List<UserProfile>> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return buildLoadingIndicator();
    } else if (snapshot.hasError) {
      return buildErrorWidget(snapshot.error);
    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
      return buildEmptyData();
    } else if (snapshot.hasData) {
      return buildCardSwiper(snapshot.data!);
    } else {
      return const Text('No data found');
    }
  }

  Widget buildLoadingIndicator() {
    return const Center(
      key: ValueKey('loading'),
      child: AppLoader(color: AppColors.primaryColor, size: 24),
    );
  }

  Widget buildErrorWidget(Object? error) {
    return Center(
      key: const ValueKey('error'),
      child: Text('Error: $error'),
    );
  }

  Widget buildEmptyData() {
    return const EmptyDataBox(
      key: ValueKey('empty'),
      imageSize: 100,
      spacing: 10,
      image: AppAssets.noLikes,
      text: 'All out of profiles! Try again soon',
    );
  }

  Widget buildCardSwiper(List<UserProfile> profiles) {
    fetchedProfiles.value = profiles;
    return Stack(
      key: const ValueKey('data'),
      children: [
        Column(
          children: [
            Flexible(
              child: Hero(
                tag: "preview",
                child: CardSwiper(
                  controller: controller,
                  padding: const EdgeInsets.only(top: 32, bottom: 20),
                  cardsCount: profiles.length,
                  numberOfCardsDisplayed:
                      profiles.length < 3 ? profiles.length : 3,
                  threshold: 100,
                  onSwipe: handleSwipe,
                  onSwipeDirectionChange: handleSwipeDirectionChange,
                  cardBuilder: (
                    context,
                    index,
                    percentThresholdX,
                    percentThresholdY,
                  ) {
                    updateThresholds(percentThresholdX.toDouble());

                    final profileData = profiles[index];

                    currentProfile.value = profileData;

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
                                  image: profileData
                                          .preferences.profilePics?[index] ??
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
                            child: ProfileFooterScaffold(
                              data: profileData,
                              onTap: (context, index) => Nav.push(
                                context,
                                MatchingProfilePreview(
                                  index: index,
                                  userProfile: profileData,
                                  useDefaultTag: true,
                                ),
                              ),
                              activePage: _activePage,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  backCardOffset: Offset(0, 41.r),
                  allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
                    horizontal: true,
                  ),
                ),
              ),
            ),
          ],
        ),
        _buildTopIcons(),
      ],
    );
  }

  Widget _buildTopIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: !_isSwiping ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: MatchIconButton(
            key: GlobalKeys.undoButtonKey,
            size: 24,
            padding: 8,
            onTap: () {
              controller.undo();

              undo();
            },
            assetPath: AppAssets.redo,
          ),
        ),
        addWidth(16),
        AnimatedOpacity(
          opacity: (!_isSwiping || thresholdX < 0) ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: MatchIconButton(
            key: GlobalKeys.dislikeButtonKey,
            onTap: () {
              controller.swipe(CardSwiperDirection.left);
              dislike();
            },
            assetPath: AppAssets.cancel,
          ),
        ),
        addWidth(24),
        AnimatedOpacity(
          opacity: (!_isSwiping || thresholdX > 0) ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: MatchIconButton(
            key: GlobalKeys.likeButtonKey,
            onTap: () {
              controller.swipe(CardSwiperDirection.right);
              like();
            },
            assetPath: AppAssets.like,
          ),
        ),
      ],
    );
  }
}
