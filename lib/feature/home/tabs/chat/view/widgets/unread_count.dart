import 'package:flutter/material.dart';

import '../../../../../../constants/index.dart';

class UnreadCount extends StatelessWidget {
  const UnreadCount({
    super.key,
    required this.unread,
  });

  final num unread;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor,
      ),
      child: Text(
        unread.toString(),
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
