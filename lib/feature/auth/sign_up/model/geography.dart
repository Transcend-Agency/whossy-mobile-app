import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../common/utils/index.dart';

part 'geography.g.dart';

@JsonSerializable()
class Geography {
  @JsonKey(name: 'geohash')
  String? geohash;

  @JsonKey(
    name: 'geopoint',
    toJson: AppUtils.geoPointToJson,
    fromJson: AppUtils.geoPointFromJson,
  )
  GeoPoint? geopoint;

  Geography({
    this.geohash,
    this.geopoint,
  });

  factory Geography.fromJson(Map<String, dynamic> json) =>
      _$GeographyFromJson(json);

  Map<String, dynamic> toJson() => _$GeographyToJson(this);
}
