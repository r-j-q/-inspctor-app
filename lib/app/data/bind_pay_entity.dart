import 'dart:convert';

import 'package:inspector/generated/json/base/json_field.dart';
import 'package:inspector/generated/json/bind_pay_entity.g.dart';

@JsonSerializable()
class BindPayEntity {
  int? id;
  int? userId;
  String? account;
  int? type;
  String? name;
  String? image;
  String? created;
  String? updated;

  BindPayEntity();

  factory BindPayEntity.fromJson(Map<String, dynamic> json) => $BindPayEntityFromJson(json);

  Map<String, dynamic> toJson() => $BindPayEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
