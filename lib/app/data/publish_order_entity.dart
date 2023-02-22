import 'dart:convert';

import 'package:inspector/generated/json/base/json_field.dart';
import 'package:inspector/generated/json/publish_order_entity.g.dart';

@JsonSerializable()
class PublishOrderEntity {
  int? total;
  List<PublishOrderRows>? rows;

  PublishOrderEntity();

  factory PublishOrderEntity.fromJson(Map<String, dynamic> json) =>
      $PublishOrderEntityFromJson(json);

  Map<String, dynamic> toJson() => $PublishOrderEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PublishOrderRows {
  int? id;
  int? orderId;
  String? provinceCity;
  String? province;
  String? city;
  String? address;
  int? userAccount;
  String? productName;
  String? date;
  double? price;
  int? flag;
  double? lat;
  double? lon;
  int? addTime;

  PublishOrderRows();

  factory PublishOrderRows.fromJson(Map<String, dynamic> json) => $PublishOrderRowsFromJson(json);

  Map<String, dynamic> toJson() => $PublishOrderRowsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
