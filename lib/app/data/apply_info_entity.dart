import 'dart:convert';

import 'package:inspector/generated/json/apply_info_entity.g.dart';
import 'package:inspector/generated/json/base/json_field.dart';

@JsonSerializable()
class ApplyInfoEntity {
  String? province;
  String? city;
  String? area;
  String? price;
  String? education;
  String? idCardNum;
  String? idCardFront;
  String? idCardBack;
  String? content;
  int? accountType;
  bool? socialSecurity;

  ApplyInfoEntity();

  factory ApplyInfoEntity.fromJson(Map<String, dynamic> json) => $ApplyInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $ApplyInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
