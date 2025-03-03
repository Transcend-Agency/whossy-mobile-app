import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../common/utils/utils.dart';

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Geography &&
        other.geohash == geohash &&
        other.geopoint == geopoint;
  }

  @override
  int get hashCode {
    return Object.hash(geohash, geopoint);
  }

  @override
  String toString() {
    return 'Geography(\n'
        '  geohash: $geohash,\n'
        '  geopoint: {\n'
        '    latitude: ${geopoint?.latitude ?? "null"},\n'
        '    longitude: ${geopoint?.longitude ?? "null"}\n'
        '  }\n'
        ')';
  }
}
