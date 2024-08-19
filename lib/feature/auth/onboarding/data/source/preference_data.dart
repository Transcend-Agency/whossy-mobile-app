import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import '../../model/preference_model.dart';

List<PreferenceModel> preferenceData = [
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
