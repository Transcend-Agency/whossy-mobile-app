import 'package:flutter/material.dart';
import 'package:whossy_app/common/components/components.dart';
import 'package:whossy_app/common/styles/text_style.dart';
import 'package:whossy_app/feature/home/tabs/chat/view/widgets/_.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        // Bold and larger than the other page titles, so it reads as the
        // heading of a list of bold names.
        titleWidget: Text(
          'Messages',
          style: TextStyles.pageHeader.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        automaticallyImplyLeading: false,
        color: Colors.white,
        borderColor: Colors.white,
        //addBarHeight: 4,
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 8.h),
          //   child: const LikesComponent(),
          // ),
          Chats(),
        ],
      ),
    );
  }
}
