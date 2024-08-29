// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtherPreferences _$OtherPreferencesFromJson(Map<String, dynamic> json) =>
    OtherPreferences(
      meet: (json['meet'] as num?)?.toInt(),
      similarInterest: json['similar_interest'] as bool?,
      hasBio: json['has_bio'] as bool?,
      ageRange: (json['age_range'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      distance: (json['distance'] as num?)?.toDouble(),
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      outreach: json['outreach'] as bool?,
      heightRange: (json['height_range'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      weightRange: (json['weight_range'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      country: json['country'] as String?,
      city: json['city'] as String?,
    );

Map<String, dynamic> _$OtherPreferencesToJson(OtherPreferences instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('meet', instance.meet);
  writeNotNull('similar_interest', instance.similarInterest);
  writeNotNull('has_bio', instance.hasBio);
  writeNotNull('age_range', instance.ageRange);
  writeNotNull('interests', instance.interests);
  writeNotNull('distance', instance.distance);
  writeNotNull('outreach', instance.outreach);
  writeNotNull('country', instance.country);
  writeNotNull('city', instance.city);
  writeNotNull('height_range', instance.heightRange);
  writeNotNull('weight_range', instance.weightRange);
  return val;
}
