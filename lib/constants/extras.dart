import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/model/drink_model.dart';

import '../common/utils/index.dart';
import '../feature/auth/onboarding/model/meet_model.dart';
import '../feature/auth/onboarding/model/preference_model.dart';
import '../feature/auth/onboarding/model/smoke_model.dart';
import '../feature/auth/onboarding/model/workout_model.dart';
import 'index.dart';

class AppConstants {
  static final List<PreferenceModel> preferenceData = [
    PreferenceModel(
      leadingAsset: AppAssets.i1,
      value: Preference.lookingToDate,
      title: "Looking to date",
      subtitle: "Seeking casual dating experience",
    ),
    PreferenceModel(
      leadingAsset: AppAssets.i2,
      value: Preference.chattingAndConnecting,
      title: "Chatting and connecting",
      subtitle: "Open to conversations and getting to know new people",
    ),
    PreferenceModel(
      leadingAsset: AppAssets.i3,
      value: Preference.readyForCommitment,
      title: "Ready for commitment",
      subtitle:
          "For those who are looking for a serious, committed relationship",
    ),
    PreferenceModel(
      leadingAsset: AppAssets.i4,
      value: Preference.justForFun,
      title: "Just for fun",
      subtitle: "Seeking fun and carefree connections without long term plans",
    ),
    PreferenceModel(
      leadingAsset: AppAssets.i5,
      value: Preference.undecidedOrExploring,
      title: "Undecided or exploring",
      subtitle:
          "Not sure what you're looking for ? Discover what feels right for you",
    ),
  ];

  static final List<MeetModel> meetData = [
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

  static final List<DrinkModel> drinkData = [
    DrinkModel(text: 'Mindful Drinking', value: Drink.mindful),
    DrinkModel(text: '100% Sober', value: Drink.sober),
    DrinkModel(text: 'Special moments only', value: Drink.special),
    DrinkModel(text: 'Regular nights out', value: Drink.regular),
    DrinkModel(text: 'Not my thing', value: Drink.no),
  ];

  static final List<SmokeModel> smokeData = [
    SmokeModel(text: "Working on quitting", value: Smoke.working),
    SmokeModel(text: "Drinks and smoke", value: Smoke.dAndS),
    SmokeModel(text: "Occasional smoker", value: Smoke.occasional),
    SmokeModel(text: "Frequent smoker", value: Smoke.frequent),
    SmokeModel(text: "Doesn't smoke", value: Smoke.no),
  ];

  static final List<WorkoutModel> workOutData = [
    WorkoutModel(text: "Yes, regularly", value: WorkOut.yes),
    WorkoutModel(text: "Occasionally", value: WorkOut.occasionally),
    WorkoutModel(text: "Only on weekends ", value: WorkOut.weekends),
    WorkoutModel(text: "Rarely", value: WorkOut.rarely),
    WorkoutModel(text: "Not at all", value: WorkOut.no),
  ];
}
