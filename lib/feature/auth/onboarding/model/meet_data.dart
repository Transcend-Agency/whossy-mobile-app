import 'package:flutter/material.dart';

import '../../../../common/utils/index.dart';

class MeetData {
  final IconData? icon;
  final String text;
  final Meet value;
  final String? asset;

  MeetData({
    this.icon,
    required this.text,
    required this.value,
    this.asset,
  });
}
