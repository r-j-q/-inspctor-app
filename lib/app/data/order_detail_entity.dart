import 'dart:convert';

import 'package:inspector/generated/json/base/json_field.dart';
import 'package:inspector/generated/json/order_detail_entity.g.dart';

@JsonSerializable()
class OrderDetailEntity {
  int? orderId;
  String? orderNo;
  int? userAccount;
  double? price;
  String? inspectTime;
  String? type;
  String? provinceCity;
  String? factoryName;
  String? name;
  String? phone;
  String? address;
  int? addressId;
  String? email;
  List<OrderDateEntity>? timeBeans;
  String? remark;
  String? productName;
  List<String> imageFile = [];
  List<String> file = [];
  String? city;
  int? inspectType;
  int? priceType;
  bool? isLookInspection;
  bool? isApply;
  String? createdTime;

  ///是否是我发布的订单
  bool? isSelf;

  ///1-草稿 2-待接单 3-待验货 4-验货完成 5-取消 6-验货中
  int? status;

  ///支付方式1-平台 2-paypal 3-支付宝 4-其他
  int? payType;
  //报告状态：0-未上传1-待审核2-通过3-不通过  5上传了,"
  int? reportStatus;

  OrderDetailEntity();

  factory OrderDetailEntity.fromJson(Map<String, dynamic> json) =>
      $OrderDetailEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderDetailEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class OrderDateEntity {
  String? date;
  int? inspectNum;

  OrderDateEntity();

  factory OrderDateEntity.fromJson(Map<String, dynamic> json) =>
      $OrderDateEntityFromJson(json);

  Map<String, dynamic> toJson() => $OrderDateEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
