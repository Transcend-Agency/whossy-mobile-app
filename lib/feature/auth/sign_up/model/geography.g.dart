// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geography.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Geography _$GeographyFromJson(Map<String, dynamic> json) => Geography(
      geohash: json['geohash'] as String?,
      geopoint: AppUtils.geoPointFromJson(json['geopoint']),
    );

Map<String, dynamic> _$GeographyToJson(Geography instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('geohash', instance.geohash);
  writeNotNull('geopoint', AppUtils.geoPointToJson(instance.geopoint));
  return val;
}
