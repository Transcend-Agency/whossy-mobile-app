import '../../../../common/utils/utils.dart';

class PreferenceModel {
  final String leadingAsset;
  final Preference value;
  final String title;
  final String subtitle;

  PreferenceModel({
    required this.leadingAsset,
    required this.value,
    required this.title,
    required this.subtitle,
  });
}
