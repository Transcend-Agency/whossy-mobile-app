import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/feature/home/tabs/chat/view/widgets/_.dart';

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
        addBarHeight: 4,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: const LikesComponent(),
          ),
          const Messages(),
        ],
      ),
    );
  }
}
