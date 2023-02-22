import 'dart:convert';

import 'package:inspector/generated/json/area_list_entity.g.dart';
import 'package:inspector/generated/json/base/json_field.dart';

@JsonSerializable()
class AreaListEntity {
  late double id;
  late String name;
  late String code;

  AreaListEntity();

  factory AreaListEntity.fromJson(Map<String, dynamic> json) =>
      $AreaListEntityFromJson(json);

  Map<String, dynamic> toJson() => $AreaListEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
