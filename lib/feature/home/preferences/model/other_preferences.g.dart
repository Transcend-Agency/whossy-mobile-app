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
      distance: (json['distance'] as num?)?.toInt(),
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

Map<String, dynamic> _$OtherPreferencesToJson(OtherPreferences instance) =>
    <String, dynamic>{
      if (instance.meet case final value?) 'meet': value,
      if (instance.similarInterest case final value?) 'similar_interest': value,
      if (instance.hasBio case final value?) 'has_bio': value,
      if (instance.ageRange case final value?) 'age_range': value,
      if (instance.interests case final value?) 'interests': value,
      if (instance.distance case final value?) 'distance': value,
      if (instance.outreach case final value?) 'outreach': value,
      if (instance.country case final value?) 'country': value,
      if (instance.city case final value?) 'city': value,
      if (instance.heightRange case final value?) 'height_range': value,
      if (instance.weightRange case final value?) 'weight_range': value,
    };
