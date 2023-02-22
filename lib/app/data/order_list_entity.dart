import 'dart:convert';

import 'package:inspector/generated/json/base/json_field.dart';
import 'package:inspector/generated/json/order_list_entity.g.dart';

@JsonSerializable()
class OrderListEntity {
  int? total;
  List<OrderListRows>? rows;

  OrderListEntity();

  factory OrderListEntity.fromJson(Map<String, dynamic> json) =>
      $OrderListEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderListEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderListRows {
  int? id;
  String? provinceCity;
  String? distance;
  String? award;
  String? date;
  String? address;
  String? inspectionDate;
  String? type;
  int? inspNumber;
  int? inspDay;
  String? reportType;
  String? productName;
  String? applyStatus;
  int? applyNum;
  double? lon;
  double? lat;
  int? multipleDate;
  List<OrderListRows>? children;
  bool connectLast = false;
  bool connectNext = false;

  OrderListRows();

  factory OrderListRows.fromJson(Map<String, dynamic> json) =>
      $OrderListRowsFromJson(json);

  Map<String, dynamic> toJson() => $OrderListRowsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
