import 'package:inspector/app/data/bill_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

BillEntity $BillEntityFromJson(Map<String, dynamic> json) {
  final BillEntity billEntity = BillEntity();
  final double? rmbExpenditureAccount =
      jsonConvert.convert<double>(json['rmbExpenditureAccount']);
  if (rmbExpenditureAccount != null) {
    billEntity.rmbExpenditureAccount = rmbExpenditureAccount;
  }
  final double? usaExpenditureAccount =
      jsonConvert.convert<double>(json['usExpenditureAccount']);
  if (usaExpenditureAccount != null) {
    billEntity.usaExpenditureAccount = usaExpenditureAccount;
  }
  final double? rmbIncomeAccount =
      jsonConvert.convert<double>(json['rmbIncomeAccount']);
  if (rmbIncomeAccount != null) {
    billEntity.rmbIncomeAccount = rmbIncomeAccount;
  }
  final double? usaIncomeAccount =
      jsonConvert.convert<double>(json['usIncomeAccount']);
  if (usaIncomeAccount != null) {
    billEntity.usaIncomeAccount = usaIncomeAccount;
  }
  final List<BillCapitalModelList>? capitalModelList = jsonConvert
      .convertListNotNull<BillCapitalModelList>(json['capitalModelList']);
  if (capitalModelList != null) {
    billEntity.capitalModelList = capitalModelList;
  }
  return billEntity;
}

Map<String, dynamic> $BillEntityToJson(BillEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['rmbExpenditureAccount'] = entity.rmbExpenditureAccount;
  data['usaExpenditureAccount'] = entity.usaExpenditureAccount;
  data['rmbIncomeAccount'] = entity.rmbIncomeAccount;
  data['usaIncomeAccount'] = entity.usaIncomeAccount;
  data['capitalModelList'] =
      entity.capitalModelList?.map((v) => v.toJson()).toList();
  return data;
}

BillCapitalModelList $BillCapitalModelListFromJson(Map<String, dynamic> json) {
  final BillCapitalModelList billCapitalModelList = BillCapitalModelList();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    billCapitalModelList.title = title;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    billCapitalModelList.type = type;
  }
  final String? time = jsonConvert.convert<String>(json['time']);
  if (time != null) {
    billCapitalModelList.time = time;
  }
  final double? account = jsonConvert.convert<double>(json['account']);
  if (account != null) {
    billCapitalModelList.account = account;
  }
  final int? userAccount = jsonConvert.convert<int>(json['userAccount']);
  if (userAccount != null) {
    billCapitalModelList.userAccount = userAccount;
  }
  return billCapitalModelList;
}

Map<String, dynamic> $BillCapitalModelListToJson(BillCapitalModelList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['type'] = entity.type;
  data['time'] = entity.time;
  data['account'] = entity.account;
  data['userAccount'] = entity.userAccount;
  return data;
}
