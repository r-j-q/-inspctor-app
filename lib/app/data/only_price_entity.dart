import 'dart:convert';

import 'package:inspector/generated/json/base/json_field.dart';
import 'package:inspector/generated/json/only_price_entity.g.dart';

@JsonSerializable()
class OnlyPriceEntity {
  bool? isAuto;
  String? huiLv;
  String? text;

  OnlyPriceEntity();

  factory OnlyPriceEntity.fromJson(Map<String, dynamic> json) => $OnlyPriceEntityFromJson(json);

  Map<String, dynamic> toJson() => $OnlyPriceEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
