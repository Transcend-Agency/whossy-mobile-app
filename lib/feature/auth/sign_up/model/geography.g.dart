// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geography.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Geography _$GeographyFromJson(Map<String, dynamic> json) => Geography(
      geohash: json['geohash'] as String?,
      geopoint: AppUtils.geoPointFromJson(json['geopoint']),
    );

Map<String, dynamic> _$GeographyToJson(Geography instance) => <String, dynamic>{
      if (instance.geohash case final value?) 'geohash': value,
      if (AppUtils.geoPointToJson(instance.geopoint) case final value?)
        'geopoint': value,
    };
