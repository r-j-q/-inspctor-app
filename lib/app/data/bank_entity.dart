import 'dart:convert';

import 'package:inspector/generated/json/bank_entity.g.dart';
import 'package:inspector/generated/json/base/json_field.dart';

@JsonSerializable()
class BankEntity {
  int? id;
  String? userName;
  String? bankName;
  String? bankCode;
  String? bankHang;
  String? bankAddress;

  BankEntity();

  factory BankEntity.fromJson(Map<String, dynamic> json) => $BankEntityFromJson(json);

  Map<String, dynamic> toJson() => $BankEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
