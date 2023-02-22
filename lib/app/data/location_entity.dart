import 'dart:convert';

import 'package:inspector/generated/json/base/json_field.dart';
import 'package:inspector/generated/json/location_entity.g.dart';

@JsonSerializable()
class LocationEntity {
  String? status;
  String? info;
  String? infocode;
  String? count;
  List<LocationGeocodes>? geocodes;

  LocationEntity();

  factory LocationEntity.fromJson(Map<String, dynamic> json) => $LocationEntityFromJson(json);

  Map<String, dynamic> toJson() => $LocationEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LocationGeocodes {
  @JSONField(name: "formatted_address")
  String? formattedAddress;
  String? country;
  String? province;
  String? citycode;
  String? city;
  String? district;
  List<dynamic>? township;
  LocationGeocodesNeighborhood? neighborhood;
  LocationGeocodesBuilding? building;
  String? adcode;
  List<dynamic>? street;
  List<dynamic>? number;
  String? location;
  String? level;

  LocationGeocodes();

  factory LocationGeocodes.fromJson(Map<String, dynamic> json) => $LocationGeocodesFromJson(json);

  Map<String, dynamic> toJson() => $LocationGeocodesToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LocationGeocodesNeighborhood {
  List<dynamic>? name;
  List<dynamic>? type;

  LocationGeocodesNeighborhood();

  factory LocationGeocodesNeighborhood.fromJson(Map<String, dynamic> json) =>
      $LocationGeocodesNeighborhoodFromJson(json);

  Map<String, dynamic> toJson() => $LocationGeocodesNeighborhoodToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class LocationGeocodesBuilding {
  List<dynamic>? name;
  List<dynamic>? type;

  LocationGeocodesBuilding();

  factory LocationGeocodesBuilding.fromJson(Map<String, dynamic> json) =>
      $LocationGeocodesBuildingFromJson(json);

  Map<String, dynamic> toJson() => $LocationGeocodesBuildingToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
