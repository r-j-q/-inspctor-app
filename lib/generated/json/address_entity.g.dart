import 'package:inspector/app/data/address_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

AddressEntity $AddressEntityFromJson(Map<String, dynamic> json) {
  final AddressEntity addressEntity = AddressEntity();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    addressEntity.total = total;
  }
  final List<AddressRows>? rows = jsonConvert.convertListNotNull<AddressRows>(json['rows']);
  if (rows != null) {
    addressEntity.rows = rows;
  }
  return addressEntity;
}

Map<String, dynamic> $AddressEntityToJson(AddressEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['rows'] = entity.rows?.map((v) => v.toJson()).toList();
  return data;
}

AddressRows $AddressRowsFromJson(Map<String, dynamic> json) {
  final AddressRows addressRows = AddressRows();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    addressRows.id = id;
  }
  final int? userId = jsonConvert.convert<int>(json['userId']);
  if (userId != null) {
    addressRows.userId = userId;
  }
  final String? factoryName = jsonConvert.convert<String>(json['factoryName']);
  if (factoryName != null) {
    addressRows.factoryName = factoryName;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    addressRows.name = name;
  }
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    addressRows.phone = phone;
  }
  final String? email = jsonConvert.convert<String>(json['email']);
  if (email != null) {
    addressRows.email = email;
  }
  final String? province = jsonConvert.convert<String>(json['province']);
  if (province != null) {
    addressRows.province = province;
  }
  final String? city = jsonConvert.convert<String>(json['city']);
  if (city != null) {
    addressRows.city = city;
  }
  final String? area = jsonConvert.convert<String>(json['area']);
  if (area != null) {
    addressRows.area = area;
  }
  final double? lon = jsonConvert.convert<double>(json['lon']);
  if (lon != null) {
    addressRows.lon = lon;
  }
  final double? lat = jsonConvert.convert<double>(json['lat']);
  if (lat != null) {
    addressRows.lat = lat;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    addressRows.address = address;
  }
  final String? created = jsonConvert.convert<String>(json['created']);
  if (created != null) {
    addressRows.created = created;
  }
  return addressRows;
}

Map<String, dynamic> $AddressRowsToJson(AddressRows entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['userId'] = entity.userId;
  data['factoryName'] = entity.factoryName;
  data['name'] = entity.name;
  data['phone'] = entity.phone;
  data['email'] = entity.email;
  data['province'] = entity.province;
  data['city'] = entity.city;
  data['area'] = entity.area;
  data['lon'] = entity.lon;
  data['lat'] = entity.lat;
  data['address'] = entity.address;
  data['created'] = entity.created;
  return data;
}
