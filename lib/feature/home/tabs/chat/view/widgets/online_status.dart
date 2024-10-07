import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:whossy_app/common/utils/index.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../data/repository/chat_repository.dart';
import '../../model/status.dart';

class OnlineStatus extends StatefulWidget {
  const OnlineStatus({super.key, required this.userId});

  final String userId;

  @override
  State<OnlineStatus> createState() => _OnlineStatusState();
}

class _OnlineStatusState extends State<OnlineStatus> {
  late Stream<DatabaseEvent> status;

  @override
  void initState() {
    status = ChatRepository.statusRef(widget.userId).onValue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: status,
      builder: (context, snapshot) {
        return AppAnimatedSwitcher(
          child: _buildStreamContent(snapshot, width),
        );
      },
    );
  }

  Widget _buildStreamContent(AsyncSnapshot snapshot, double width) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SizedBox.square(dimension: 14);
    }

    if (snapshot.hasError) {
      log('An error occurred while streaming status: ${snapshot.error}');
      return const SizedBox.shrink();
    }

    final data = snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;

    if (data == null) {
      return Text('Offline', style: TextStyles.hintThemeText);
    }

    final status = Status.fromJson(Map<String, dynamic>.from(data));

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
            style: TextStyles.hintThemeText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
  }
}
