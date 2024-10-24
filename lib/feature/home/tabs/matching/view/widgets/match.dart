import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class Match extends StatefulWidget {
  const Match({super.key});

  @override
  State<Match> createState() => _MatchState();
}

class _MatchState extends State<Match> {
  final CardSwiperController controller = CardSwiperController();

  final List<Widget> cards = [
    const ProfileCard(color: AppColors.outlinedColor),
    const ProfileCard(color: AppColors.inputBackGround),
    const ProfileCard(color: AppColors.taintedWhite),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Flexible(
              child: CardSwiper(
                controller: controller,
                padding: const EdgeInsets.only(top: 32, bottom: 20),
                cardsCount: cards.length,
                numberOfCardsDisplayed: 3,
                cardBuilder: (
                  context,
                  index,
                  percentThresholdX,
                  percentThresholdY,
                ) =>
                    cards[index],
                backCardOffset: const Offset(0, 46),
                allowedSwipeDirection:
                    const AllowedSwipeDirection.symmetric(horizontal: true),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MatchIconButton(
              size: 26,
              padding: 8,
              onTap: () => controller.undo(),
              assetPath: AppAssets.redo,
            ),
            addWidth(16),
            MatchIconButton(
              onTap: () => controller.swipe(CardSwiperDirection.left),
              assetPath: AppAssets.cancel,
            ),
            addWidth(24),
            MatchIconButton(
              onTap: () => controller.swipe(CardSwiperDirection.right),
              assetPath: AppAssets.like,
            ),
          ],
        ),
      ],
    );
  }
}
