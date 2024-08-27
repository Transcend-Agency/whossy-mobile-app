// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtherPreferences _$OtherPreferencesFromJson(Map<String, dynamic> json) =>
    OtherPreferences(
      meet: (json['meet'] as num?)?.toInt(),
      similarInterest: json['similarInterest'] as bool?,
      hasBio: json['hasBio'] as bool?,
      ageRange: (json['ageRange'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      distance: (json['distance'] as num?)?.toDouble(),
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      outreach: json['outreach'] as bool?,
      heightRange: (json['heightRange'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      weightRange: (json['weightRange'] as Map<String, dynamic>?)?.map(
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
  writeNotNull('similarInterest', instance.similarInterest);
  writeNotNull('hasBio', instance.hasBio);
  writeNotNull('ageRange', instance.ageRange);
  writeNotNull('interests', instance.interests);
  writeNotNull('distance', instance.distance);
  writeNotNull('outreach', instance.outreach);
  writeNotNull('country', instance.country);
  writeNotNull('city', instance.city);
  writeNotNull('heightRange', instance.heightRange);
  writeNotNull('weightRange', instance.weightRange);
  return val;
}
