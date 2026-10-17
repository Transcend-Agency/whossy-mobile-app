import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/components.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';

import '../../../../common/utils/utils.dart';
import '../../../../constants/index.dart';
import '../../../../provider/provider.dart';
import '../model/app_notification.dart';
import 'widgets/notification_bell.dart';
import 'widgets/notification_tile.dart';

@RoutePage()
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const name = 'notification';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const CustomAppBar(
        addBarHeight: 4,
        title: 'Notifications',
        color: Colors.white,
        action: NotificationBell(),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                Selector<NotificationNotifier, Stream<List<AppNotification>>>(
              selector: (_, notifier) => notifier.notificationStream,
              builder: (_, notifications, __) {
                return StreamBuilder(
                  stream: notifications,
                  builder: (context, snapshot) {
                    return AppAnimatedSwitcher(
                      child: _buildStreamContent(snapshot, context),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamContent(
    AsyncSnapshot<List<AppNotification>> snapshot,
    BuildContext context,
  ) {
    if (snapshot.hasData) {
      final tileData = snapshot.data!;

      if (tileData.isEmpty) {
        return const EmptyDataBox(
          key: ValueKey('empty'),
          image: AppAssets.noNotifications,
          text: 'No notifications',
          imageSize: 100,
          spacing: 10,
        );
      }

      return AppListBuilder(
        key: const ValueKey('data'),
        padding: EdgeInsets.zero,
        itemCount: tileData.length,
        itemBuilder: (_, index) {
          final tile = tileData[index];

          return NotificationTile(
            notification: tile,
            onTap: () => onTileTap(context, tile),
          );
        },
      );
    } else if (snapshot.hasError) {
      log('Error fetching notifications: ${snapshot.error}');

      return const BadNetworkDialog(
        key: ValueKey('error'),
      );
    } else {
      return const AppLoader(
        key: ValueKey('loading'),
        color: AppColors.primaryColor,
      );
    }
  }

  // B3: each notification type routes to its own subject instead of only
  // like/match opening a profile preview and everything else being a no-op.
  void onTileTap(BuildContext context, AppNotification notification) {
    switch (notification.notificationType) {
      case NotificationType.like:
      case NotificationType.match:
        final id = notification.interactingUserId;
        if (id != null) Nav.push(context, NotificationProfilePreview(id: id));
        return;

      case NotificationType.message:
        final senderId = notification.senderId;
        final currentUser = FirebaseAuth.instance.currentUser?.uid;
        if (senderId == null || currentUser == null) return;

        context.read<ChatsNotifier>().setCurrentChat(
              username: notification.senderName ?? 'User',
              uidUser1: currentUser,
              uidUser2: senderId,
              profilePicUrl: notification.senderProfilePicture,
              oppIndex: 1,
            );
        Nav.push(context, const ChatRoom());
        return;

      case NotificationType.verification:
        Nav.push(context, const EditProfile());
        return;

      case NotificationType.unknown:
        return;
    }
  }
}
