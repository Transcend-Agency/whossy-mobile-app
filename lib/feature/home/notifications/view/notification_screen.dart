import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/index.dart';

import '../../../../constants/index.dart';
import '../../../../provider/providers.dart';
import '../model/app_notification.dart';
import 'widgets/notification_bell.dart';
import 'widgets/notification_tile.dart';

@RoutePage()
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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

          return NotificationTile(notification: tile);
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
}
