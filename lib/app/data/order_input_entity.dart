import 'dart:convert';

import 'package:inspector/generated/json/base/json_field.dart';
import 'package:inspector/generated/json/order_input_entity.g.dart';

@JsonSerializable()
class OrderInputEntity {
  int? addressId;
  List<DateTime>? dateList;
  String? file;
  String? imageFile;
  int? inspectNum;
  int? inspectType;
  int? payType;
  num? price;
  String? productName;
  String? remark;
  String? payText;
  bool? isUSD;
  String? orderId;

  OrderInputEntity();

  factory OrderInputEntity.fromJson(Map<String, dynamic> json) => $OrderInputEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderInputEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
