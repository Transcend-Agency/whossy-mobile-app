import 'package:flutter/material.dart';

import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import '../../model/meet_model.dart';

List<MeetModel> meetData = [
  MeetModel(
    icon: Icons.male_rounded,
    text: 'I want to meet men',
    value: Meet.men,
  ),
  MeetModel(
    icon: Icons.female_rounded,
    text: 'I want to meet women',
    value: Meet.women,
  ),
  MeetModel(
    text: 'I want to meet everyone',
    value: Meet.everyone,
    asset: AppAssets.biGender,
  ),
];
