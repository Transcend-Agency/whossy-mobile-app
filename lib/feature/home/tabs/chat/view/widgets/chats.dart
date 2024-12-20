import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/chat_with_user.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../common/utils/router/router.gr.dart';
import '../../../../../../constants/index.dart';
import 'chat_tile.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  bool isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Selector<ChatsNotifier, Stream<List<ChatWithUser>>>(
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
                      child: _buildStreamContent(snapshot, context),
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
  Widget _buildStreamContent(
    AsyncSnapshot<List<ChatWithUser>> snapshot,
    BuildContext context,
  ) {
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
          final oppIndex =
              tile.chat.participants.indexOf(currentUser) == 0 ? 1 : 0;

          return ChatTile(
            data: tile.chat,
            images: tile.userProfile?.pictures,
            name: tile.userProfile?.user.firstName,
            oppIndex: oppIndex,
            onTileTap: () => onTileTap(context, tile, oppIndex),
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
          return const ShimmerChatTile();
        },
      );
    }
  }

  void onTileTap(BuildContext context, ChatWithUser data, int oppIndex) {
    var notifier = context.read<ChatsNotifier>();

    notifier.setCurrentChat(
      username: data.userProfile?.user.firstName ?? 'Deleted Account',
      uidUser1: currentUser,
      uidUser2: data.chat.participants[oppIndex],
      profilePicUrl: (data.userProfile?.pictures.isNotEmpty ?? false)
          ? data.userProfile?.pictures[0]
          : null,
      oppIndex: oppIndex,
    );

    toChat(context);
  }

  void toChat(BuildContext context) {
    if (!isNavigating) {
      isNavigating = true;

      Nav.push(context, const ChatRoom()).then(
        (_) => isNavigating = false,
      );
    }
  }

  // Build the header for the messages page
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 6.h,
            horizontal: 14.w,
          ),
          child: Text(
            'Messages',
            style: TextStyles.pageHeader,
          ),
        ),
      ),
    );
  }
}
