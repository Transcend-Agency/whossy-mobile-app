import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/index.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../model/status.dart';

class OnlineStatus extends HookWidget {
  const OnlineStatus({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    final chatsNotifier = context.read<ChatsNotifier>();

    final statusStream = useMemoized(
      () => chatsNotifier.statusStream(userId),
      [userId],
    );

    // Use useStream to manage stream subscription and update state on new data
    final snapshot = useStream(statusStream);

    return AppAnimatedSwitcher(
      child: _buildStreamContent(snapshot, width),
    );
  }

  Widget _buildStreamContent(
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
    double width,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SizedBox.square(dimension: 14);
    }

    if (snapshot.hasError) {
      log('An error occurred while streaming status: ${snapshot.error}');
      return const SizedBox.shrink();
    }

    final data = snapshot.data?.data();
    if (data == null || data['status'] == null) {
      return Text('Offline', style: TextStyles.hintThemeText);
    }

    final status = Status.fromJson(Map<String, dynamic>.from(data['status']));

    return status.online
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Online',
                style: TextStyles.hintThemeText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              addWidth(4),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: greenDot(),
              ),
            ],
          )
        : Text(
            status.getLastSeen(Timestamp.now()),
            style: TextStyles.hintThemeText.copyWith(
              fontSize: 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
  }
}
