import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/model/drink_model.dart';

import '../common/utils/index.dart';
import '../feature/auth/onboarding/model/meet_model.dart';
import '../feature/auth/onboarding/model/preference_model.dart';
import '../feature/auth/onboarding/model/smoke_model.dart';
import '../feature/auth/onboarding/model/workout_model.dart';
import '../feature/home/model/extras.dart';
import 'index.dart';

class AppConstants {
  static final List<PreferenceModel> preferenceData = [
    PreferenceModel(
      leadingAsset: AppAssets.i1,
      value: Preference.lookingToDate,
      title: Preference.lookingToDate.name,
      subtitle: Preference.lookingToDate.subtitle,
    ),
    PreferenceModel(
      leadingAsset: AppAssets.i2,
      value: Preference.chattingAndConnecting,
      title: Preference.chattingAndConnecting.name,
      subtitle: Preference.chattingAndConnecting.subtitle,
    ),
    PreferenceModel(
      leadingAsset: AppAssets.i3,
      value: Preference.readyForCommitment,
      title: Preference.readyForCommitment.name,
      subtitle: Preference.readyForCommitment.subtitle,
    ),
    PreferenceModel(
      leadingAsset: AppAssets.i4,
      value: Preference.justForFun,
      title: Preference.justForFun.name,
      subtitle: Preference.justForFun.subtitle,
    ),
    PreferenceModel(
      leadingAsset: AppAssets.i5,
      value: Preference.undecidedOrExploring,
      title: Preference.undecidedOrExploring.name,
      subtitle: Preference.undecidedOrExploring.subtitle,
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
    DrinkModel(text: Drink.mindful.name, value: Drink.mindful),
    DrinkModel(text: Drink.sober.name, value: Drink.sober),
    DrinkModel(text: Drink.special.name, value: Drink.special),
    DrinkModel(text: Drink.regular.name, value: Drink.regular),
    DrinkModel(text: Drink.no.name, value: Drink.no),
  ];

  static final List<SmokeModel> smokeData = [
    SmokeModel(text: Smoke.working.name, value: Smoke.working),
    SmokeModel(text: Smoke.dAndS.name, value: Smoke.dAndS),
    SmokeModel(text: Smoke.occasional.name, value: Smoke.occasional),
    SmokeModel(text: Smoke.frequent.name, value: Smoke.frequent),
    SmokeModel(text: Smoke.no.name, value: Smoke.no),
  ];

  static final List<WorkoutModel> workOutData = [
    WorkoutModel(text: WorkOut.yes.name, value: WorkOut.yes),
    WorkoutModel(text: WorkOut.occasionally.name, value: WorkOut.occasionally),
    WorkoutModel(text: WorkOut.weekends.name, value: WorkOut.weekends),
    WorkoutModel(text: WorkOut.rarely.name, value: WorkOut.rarely),
    WorkoutModel(text: WorkOut.no.name, value: WorkOut.no),
  ];

  static final List<ExtraPreferences> extraPreferences = [
    ExtraPreferences<Preference>(
      header: 'Relationship preference',
      items: relPrefOptions,
    ),
    ExtraPreferences<School>(
      header: 'Education',
      items: schoolOptions,
    ),
    ExtraPreferences<LoveLanguage>(
      header: 'Love language',
      items: loveOptions,
    ),
    ExtraPreferences<Zodiac>(
      header: 'Zodiac',
      items: zodiacOptions,
    ),
    ExtraPreferences<FutureFamilyPlans>(
      header: 'Future family plans',
      items: familyPlanOptions,
    ),
    ExtraPreferences<CommunicationStyle>(
      header: 'How you communicate',
      items: communicationStyleOptions,
    ),
    ExtraPreferences<Smoke>(
      header: 'Smoker',
      items: smokeOptions,
    ),
    ExtraPreferences<Drink>(
      header: 'Drinking',
      items: drinkOptions,
    ),
    ExtraPreferences<WorkOut>(
      header: 'Workout',
      items: workoutOptions,
    ),
    ExtraPreferences<PetOwner>(
      header: 'Pet owner',
      items: petOwnerOptions,
    ),
  ];

  static final List<Data<PetOwner>> petOwnerOptions = [
    Data(
      text: PetOwner.dog.name,
      value: PetOwner.dog,
    ),
    Data(
      text: PetOwner.cat.name,
      value: PetOwner.cat,
    ),
    Data(
      text: PetOwner.reptile.name,
      value: PetOwner.reptile,
    ),
    Data(
      text: PetOwner.amphibian.name,
      value: PetOwner.amphibian,
    ),
    Data(
      text: PetOwner.bird.name,
      value: PetOwner.bird,
    ),
    Data(
      text: PetOwner.fish.name,
      value: PetOwner.fish,
    ),
    Data(
      text: PetOwner.dontLikePets.name,
      value: PetOwner.dontLikePets,
    ),
    Data(
      text: PetOwner.rabbits.name,
      value: PetOwner.rabbits,
    ),
    Data(
      text: PetOwner.mouse.name,
      value: PetOwner.mouse,
    ),
    Data(
      text: PetOwner.planningOnGetting.name,
      value: PetOwner.planningOnGetting,
    ),
    Data(
      text: PetOwner.allergic.name,
      value: PetOwner.allergic,
    ),
    Data(
      text: PetOwner.other.name,
      value: PetOwner.other,
    ),
    Data(
      text: PetOwner.wantAPet.name,
      value: PetOwner.wantAPet,
    ),
  ];

  static final List<Data<Preference>> relPrefOptions = [
    Data(
      text: Preference.lookingToDate.name,
      value: Preference.lookingToDate,
    ),
    Data(
      text: Preference.chattingAndConnecting.name,
      value: Preference.chattingAndConnecting,
    ),
    Data(
      text: Preference.readyForCommitment.name,
      value: Preference.readyForCommitment,
    ),
    Data(
      text: Preference.justForFun.name,
      value: Preference.justForFun,
    ),
    Data(
      text: Preference.undecidedOrExploring.name,
      value: Preference.undecidedOrExploring,
    ),
  ];

  static final List<Data<LoveLanguage>> loveOptions = [
    Data(
      text: LoveLanguage.givingAndReceivingGifts.name,
      value: LoveLanguage.givingAndReceivingGifts,
    ),
    Data(
      text: LoveLanguage.touchAndHugs.name,
      value: LoveLanguage.touchAndHugs,
    ),
    Data(
      text: LoveLanguage.heartfeltCompliments.name,
      value: LoveLanguage.heartfeltCompliments,
    ),
    Data(
      text: LoveLanguage.doingThingsForEachOther.name,
      value: LoveLanguage.doingThingsForEachOther,
    ),
    Data(
      text: LoveLanguage.spendingTimeTogether.name,
      value: LoveLanguage.spendingTimeTogether,
    ),
  ];

  static final List<Data<School>> schoolOptions = [
    Data(
      text: School.notInSchool.name,
      value: School.notInSchool,
    ),
    Data(
      text: School.currentlySchooling.name,
      value: School.currentlySchooling,
    ),
  ];

  static final List<Data<Zodiac>> zodiacOptions = [
    Data(
      text: Zodiac.aries.name,
      value: Zodiac.aries,
    ),
    Data(
      text: Zodiac.taurus.name,
      value: Zodiac.taurus,
    ),
    Data(
      text: Zodiac.gemini.name,
      value: Zodiac.gemini,
    ),
    Data(
      text: Zodiac.cancer.name,
      value: Zodiac.cancer,
    ),
    Data(
      text: Zodiac.leo.name,
      value: Zodiac.leo,
    ),
    Data(
      text: Zodiac.virgo.name,
      value: Zodiac.virgo,
    ),
    Data(
      text: Zodiac.libra.name,
      value: Zodiac.libra,
    ),
    Data(
      text: Zodiac.scorpio.name,
      value: Zodiac.scorpio,
    ),
    Data(
      text: Zodiac.sagittarius.name,
      value: Zodiac.sagittarius,
    ),
    Data(
      text: Zodiac.capricorn.name,
      value: Zodiac.capricorn,
    ),
    Data(
      text: Zodiac.aquarius.name,
      value: Zodiac.aquarius,
    ),
    Data(
      text: Zodiac.pisces.name,
      value: Zodiac.pisces,
    ),
  ];

  static final List<Data<CommunicationStyle>> communicationStyleOptions = [
    Data(
      text: CommunicationStyle.directAndToThePoint.name,
      value: CommunicationStyle.directAndToThePoint,
    ),
    Data(
      text: CommunicationStyle.friendlyAndOpen.name,
      value: CommunicationStyle.friendlyAndOpen,
    ),
    Data(
      text: CommunicationStyle.reservedAndThoughtful.name,
      value: CommunicationStyle.reservedAndThoughtful,
    ),
    Data(
      text: CommunicationStyle.humorousAndLighthearted.name,
      value: CommunicationStyle.humorousAndLighthearted,
    ),
    Data(
      text: CommunicationStyle.detailedAndDescriptive.name,
      value: CommunicationStyle.detailedAndDescriptive,
    ),
  ];

  static final List<Data<FutureFamilyPlans>> familyPlanOptions = [
    Data(
      text: FutureFamilyPlans.wantsChildren.name,
      value: FutureFamilyPlans.wantsChildren,
    ),
    Data(
      text: FutureFamilyPlans.notSureYet.name,
      value: FutureFamilyPlans.notSureYet,
    ),
    Data(
      text: FutureFamilyPlans.notInterestedForNow.name,
      value: FutureFamilyPlans.notInterestedForNow,
    ),
    Data(
      text: FutureFamilyPlans.doesntWantChildren.name,
      value: FutureFamilyPlans.doesntWantChildren,
    ),
    Data(
      text: FutureFamilyPlans.hasChildren.name,
      value: FutureFamilyPlans.hasChildren,
    ),
    Data(
      text: FutureFamilyPlans.wantsMoreChildren.name,
      value: FutureFamilyPlans.wantsMoreChildren,
    ),
  ];

  static final List<Data<Smoke>> smokeOptions = [
    Data(
      text: Smoke.working.name,
      value: Smoke.working,
    ),
    Data(
      text: Smoke.dAndS.name,
      value: Smoke.dAndS,
    ),
    Data(
      text: Smoke.occasional.name,
      value: Smoke.occasional,
    ),
    Data(
      text: Smoke.frequent.name,
      value: Smoke.frequent,
    ),
    Data(
      text: Smoke.no.name,
      value: Smoke.no,
    ),
  ];

  static final List<Data<WorkOut>> workoutOptions = [
    Data(
      text: WorkOut.yes.name,
      value: WorkOut.yes,
    ),
    Data(
      text: WorkOut.occasionally.name,
      value: WorkOut.occasionally,
    ),
    Data(
      text: WorkOut.weekends.name,
      value: WorkOut.weekends,
    ),
    Data(
      text: WorkOut.rarely.name,
      value: WorkOut.rarely,
    ),
    Data(
      text: WorkOut.no.name,
      value: WorkOut.no,
    ),
  ];

  static final List<Data<Drink>> drinkOptions = [
    Data(
      text: Drink.mindful.name,
      value: Drink.mindful,
    ),
    Data(
      text: Drink.sober.name,
      value: Drink.sober,
    ),
    Data(
      text: Drink.special.name,
      value: Drink.special,
    ),
    Data(
      text: Drink.regular.name,
      value: Drink.regular,
    ),
    Data(
      text: Drink.no.name,
      value: Drink.no,
    ),
  ];
}
