import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/feature/home/tabs/chat/view/widgets/_.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../constants/index.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const CustomAppBar(
        title: 'New Likes and Matches',
        automaticallyImplyLeading: false,
        color: Colors.white,
        borderColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
            child: const LikesAndMatches(),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppAssets.noMessages,
                    height: 110.r,
                  ),
                  Text(
                    'No messages yet',
                    style: TextStyles.boldPrefText,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
