import 'dart:convert';
import 'package:inspector/generated/json/base/json_field.dart';
import 'package:inspector/generated/json/bill_entity.g.dart';

@JsonSerializable()
class BillEntity {
  double? rmbExpenditureAccount;
  double? usaExpenditureAccount;
  double? rmbIncomeAccount;
  double? usaIncomeAccount;
  List<BillCapitalModelList>? capitalModelList;

  BillEntity();

  factory BillEntity.fromJson(Map<String, dynamic> json) =>
      $BillEntityFromJson(json);

  Map<String, dynamic> toJson() => $BillEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class BillCapitalModelList {
  String? title;
  int? type;
  String? time;
  double? account;
  int? userAccount;

  BillCapitalModelList();

  factory BillCapitalModelList.fromJson(Map<String, dynamic> json) =>
      $BillCapitalModelListFromJson(json);

  Map<String, dynamic> toJson() => $BillCapitalModelListToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
