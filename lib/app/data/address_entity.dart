import 'dart:convert';

import 'package:inspector/generated/json/address_entity.g.dart';
import 'package:inspector/generated/json/base/json_field.dart';

@JsonSerializable()
class AddressEntity {
  int? total;
  List<AddressRows>? rows;

  AddressEntity();

  factory AddressEntity.fromJson(Map<String, dynamic> json) => $AddressEntityFromJson(json);

  Map<String, dynamic> toJson() => $AddressEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class AddressRows {
  int? id;
  int? userId;
  String? factoryName;
  String? name;
  String? phone;
  String? email;
  String? province;
  String? city;
  String? area;
  double? lon;
  double? lat;
  String? address;
  String? created;

  AddressRows();

  factory AddressRows.fromJson(Map<String, dynamic> json) => $AddressRowsFromJson(json);

  Map<String, dynamic> toJson() => $AddressRowsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
