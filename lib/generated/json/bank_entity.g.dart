import 'package:inspector/app/data/bank_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

BankEntity $BankEntityFromJson(Map<String, dynamic> json) {
  final BankEntity bankEntity = BankEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    bankEntity.id = id;
  }
  final String? userName = jsonConvert.convert<String>(json['userName']);
  if (userName != null) {
    bankEntity.userName = userName;
  }
  final String? bankName = jsonConvert.convert<String>(json['bankName']);
  if (bankName != null) {
    bankEntity.bankName = bankName;
  }
  final String? bankCode = jsonConvert.convert<String>(json['bankCode']);
  if (bankCode != null) {
    bankEntity.bankCode = bankCode;
  }
  final String? bankHang = jsonConvert.convert<String>(json['bankHang']);
  if (bankHang != null) {
    bankEntity.bankHang = bankHang;
  }
  final String? bankAddress = jsonConvert.convert<String>(json['bankAddress']);
  if (bankAddress != null) {
    bankEntity.bankAddress = bankAddress;
  }
  return bankEntity;
}

Map<String, dynamic> $BankEntityToJson(BankEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['userName'] = entity.userName;
  data['bankName'] = entity.bankName;
  data['bankCode'] = entity.bankCode;
  data['bankHang'] = entity.bankHang;
  data['bankAddress'] = entity.bankAddress;
  return data;
}
