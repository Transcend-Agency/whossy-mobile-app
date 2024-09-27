import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/feature/home/tabs/chat/view/widgets/shimmer_tile.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../constants/index.dart';
import '../../model/chat.dart';
import 'chat_tile.dart'; // for ChatTile

class Messages extends StatelessWidget {
  Messages({super.key});

  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Selector<ChatsNotifier, Stream<List<Chat>>>(
        selector: (_, chatsNotifier) => chatsNotifier.chatStream,
        builder: (_, chats, __) {
          return StreamBuilder(
            stream: chats,
            builder: (context, snapshot) {
              return Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: AppAnimatedSwitcher(
                      child: _buildStreamContent(snapshot),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // Build content for the StreamBuilder
  Widget _buildStreamContent(AsyncSnapshot<List<Chat>> snapshot) {
    if (snapshot.hasData) {
      final tileData = snapshot.data!;
      if (tileData.isEmpty) {
        return const EmptyDataBox(
          key: ValueKey('empty'),
          image: AppAssets.noMessages,
          text: 'No messages yet',
        );
      }

      return AppListBuilder(
        key: const ValueKey('data'),
        padding: pagePadding,
        itemCount: tileData.length,
        itemBuilder: (_, index) {
          final tile = tileData[index];
          final int oppIndex =
              tile.participants.indexOf(currentUser) == 0 ? 1 : 0;

          return Column(
            children: [
              ChatTile(tileData: tile, oppIndex: oppIndex),
              Padding(
                padding: EdgeInsets.only(left: 68.w),
                child: const AppDivider(),
              ),
            ],
          );
        },
      );
    } else if (snapshot.hasError) {
      log('Error fetching chat tiles: ${snapshot.error}');
      return const Text(
        'Sorry, try again later',
        key: ValueKey('error'),
      ); //
    } else {
      return AppListBuilder(
        key: const ValueKey('loading'),
        padding: pagePadding,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const ShimmerTile(),
              Padding(
                padding: EdgeInsets.only(left: 68.w),
                child: const AppDivider(),
              ),
            ],
          );
        },
      );
    }
  }

  // Build the header for the messages page
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 6.h,
            horizontal: 14.w,
          ),
          child: Text(
            'Messages',
            style: TextStyles.boldPrefText,
          ),
        ),
      ),
    );
  }
}
