import 'package:inspector/app/data/location_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

LocationEntity $LocationEntityFromJson(Map<String, dynamic> json) {
  final LocationEntity locationEntity = LocationEntity();
  final String? status = jsonConvert.convert<String>(json['status']);
  if (status != null) {
    locationEntity.status = status;
  }
  final String? info = jsonConvert.convert<String>(json['info']);
  if (info != null) {
    locationEntity.info = info;
  }
  final String? infocode = jsonConvert.convert<String>(json['infocode']);
  if (infocode != null) {
    locationEntity.infocode = infocode;
  }
  final String? count = jsonConvert.convert<String>(json['count']);
  if (count != null) {
    locationEntity.count = count;
  }
  final List<LocationGeocodes>? geocodes =
      jsonConvert.convertListNotNull<LocationGeocodes>(json['geocodes']);
  if (geocodes != null) {
    locationEntity.geocodes = geocodes;
  }
  return locationEntity;
}

Map<String, dynamic> $LocationEntityToJson(LocationEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['status'] = entity.status;
  data['info'] = entity.info;
  data['infocode'] = entity.infocode;
  data['count'] = entity.count;
  data['geocodes'] = entity.geocodes?.map((v) => v.toJson()).toList();
  return data;
}

LocationGeocodes $LocationGeocodesFromJson(Map<String, dynamic> json) {
  final LocationGeocodes locationGeocodes = LocationGeocodes();
  final String? formattedAddress = jsonConvert.convert<String>(json['formatted_address']);
  if (formattedAddress != null) {
    locationGeocodes.formattedAddress = formattedAddress;
  }
  final String? country = jsonConvert.convert<String>(json['country']);
  if (country != null) {
    locationGeocodes.country = country;
  }
  final String? province = jsonConvert.convert<String>(json['province']);
  if (province != null) {
    locationGeocodes.province = province;
  }
  final String? citycode = jsonConvert.convert<String>(json['citycode']);
  if (citycode != null) {
    locationGeocodes.citycode = citycode;
  }
  final String? city = jsonConvert.convert<String>(json['city']);
  if (city != null) {
    locationGeocodes.city = city;
  }
  final String? district = jsonConvert.convert<String>(json['district']);
  if (district != null) {
    locationGeocodes.district = district;
  }
  final List<dynamic>? township = jsonConvert.convertListNotNull<dynamic>(json['township']);
  if (township != null) {
    locationGeocodes.township = township;
  }
  final LocationGeocodesNeighborhood? neighborhood =
      jsonConvert.convert<LocationGeocodesNeighborhood>(json['neighborhood']);
  if (neighborhood != null) {
    locationGeocodes.neighborhood = neighborhood;
  }
  final LocationGeocodesBuilding? building =
      jsonConvert.convert<LocationGeocodesBuilding>(json['building']);
  if (building != null) {
    locationGeocodes.building = building;
  }
  final String? adcode = jsonConvert.convert<String>(json['adcode']);
  if (adcode != null) {
    locationGeocodes.adcode = adcode;
  }
  final List<dynamic>? street = jsonConvert.convertListNotNull<dynamic>(json['street']);
  if (street != null) {
    locationGeocodes.street = street;
  }
  final List<dynamic>? number = jsonConvert.convertListNotNull<dynamic>(json['number']);
  if (number != null) {
    locationGeocodes.number = number;
  }
  final String? location = jsonConvert.convert<String>(json['location']);
  if (location != null) {
    locationGeocodes.location = location;
  }
  final String? level = jsonConvert.convert<String>(json['level']);
  if (level != null) {
    locationGeocodes.level = level;
  }
  return locationGeocodes;
}

Map<String, dynamic> $LocationGeocodesToJson(LocationGeocodes entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['formatted_address'] = entity.formattedAddress;
  data['country'] = entity.country;
  data['province'] = entity.province;
  data['citycode'] = entity.citycode;
  data['city'] = entity.city;
  data['district'] = entity.district;
  data['township'] = entity.township;
  data['neighborhood'] = entity.neighborhood?.toJson();
  data['building'] = entity.building?.toJson();
  data['adcode'] = entity.adcode;
  data['street'] = entity.street;
  data['number'] = entity.number;
  data['location'] = entity.location;
  data['level'] = entity.level;
  return data;
}

LocationGeocodesNeighborhood $LocationGeocodesNeighborhoodFromJson(Map<String, dynamic> json) {
  final LocationGeocodesNeighborhood locationGeocodesNeighborhood = LocationGeocodesNeighborhood();
  final List<dynamic>? name = jsonConvert.convertListNotNull<dynamic>(json['name']);
  if (name != null) {
    locationGeocodesNeighborhood.name = name;
  }
  final List<dynamic>? type = jsonConvert.convertListNotNull<dynamic>(json['type']);
  if (type != null) {
    locationGeocodesNeighborhood.type = type;
  }
  return locationGeocodesNeighborhood;
}

Map<String, dynamic> $LocationGeocodesNeighborhoodToJson(LocationGeocodesNeighborhood entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['type'] = entity.type;
  return data;
}

LocationGeocodesBuilding $LocationGeocodesBuildingFromJson(Map<String, dynamic> json) {
  final LocationGeocodesBuilding locationGeocodesBuilding = LocationGeocodesBuilding();
  final List<dynamic>? name = jsonConvert.convertListNotNull<dynamic>(json['name']);
  if (name != null) {
    locationGeocodesBuilding.name = name;
  }
  final List<dynamic>? type = jsonConvert.convertListNotNull<dynamic>(json['type']);
  if (type != null) {
    locationGeocodesBuilding.type = type;
  }
  return locationGeocodesBuilding;
}

Map<String, dynamic> $LocationGeocodesBuildingToJson(LocationGeocodesBuilding entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['type'] = entity.type;
  return data;
}
