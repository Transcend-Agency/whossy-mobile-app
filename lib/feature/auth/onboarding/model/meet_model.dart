import 'package:flutter/material.dart';

import '../../../../common/utils/index.dart';

class MeetModel {
  final IconData? icon;
  final String text;
  final Meet value;
  final String? asset;

  MeetModel({
    this.icon,
    required this.text,
    required this.value,
    this.asset,
  });
}
