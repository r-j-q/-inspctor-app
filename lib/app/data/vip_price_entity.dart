import 'dart:convert';

import 'package:inspector/generated/json/base/json_field.dart';
import 'package:inspector/generated/json/vip_price_entity.g.dart';

@JsonSerializable()
class VipPriceEntity {
  String? usdPrice;
  String? rmbPrice;
  String? rmbDesc;
  String? usdDesc;

  VipPriceEntity();

  factory VipPriceEntity.fromJson(Map<String, dynamic> json) => $VipPriceEntityFromJson(json);

  Map<String, dynamic> toJson() => $VipPriceEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
