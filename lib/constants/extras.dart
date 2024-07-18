import 'package:flutter/material.dart';

import '../common/utils/index.dart';
import '../models/meet_data.dart';
import '../models/preference_data.dart';
import 'index.dart';

class AppConstants {
  static final List<PreferenceData> preferenceData = [
    PreferenceData(
      leadingAsset: AppAssets.i1,
      value: Preference.lookingToDate,
      title: "Looking to date",
      subtitle: "Seeking casual dating experience",
    ),
    PreferenceData(
      leadingAsset: AppAssets.i2,
      value: Preference.chattingAndConnecting,
      title: "Chatting and connecting",
      subtitle: "Open to conversations and getting to know new people",
    ),
    PreferenceData(
      leadingAsset: AppAssets.i3,
      value: Preference.readyForCommitment,
      title: "Ready for commitment",
      subtitle:
          "For those who are looking for a serious, committed relationship",
    ),
    PreferenceData(
      leadingAsset: AppAssets.i4,
      value: Preference.justForFun,
      title: "Just for fun",
      subtitle: "Seeking fun and carefree connections without long term plans",
    ),
    PreferenceData(
      leadingAsset: AppAssets.i5,
      value: Preference.undecidedOrExploring,
      title: "Undecided or exploring",
      subtitle:
          "Not sure what you're looking for ? Discover what feels right for you",
    ),
  ];

  static final List<MeetData> meetData = [
    MeetData(
      icon: Icons.male_rounded,
      text: 'I want to meet men',
      value: Meet.men,
    ),
    MeetData(
      icon: Icons.female_rounded,
      text: 'I want to meet women',
      value: Meet.women,
    ),
    MeetData(
      text: 'I want to meet everyone',
      value: Meet.everyone,
      asset: AppAssets.biGender,
    ),
  ];
}
