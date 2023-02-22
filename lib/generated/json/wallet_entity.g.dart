import 'package:inspector/app/data/wallet_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

WalletEntity $WalletEntityFromJson(Map<String, dynamic> json) {
  final WalletEntity walletEntity = WalletEntity();
  final double? rmbAmount = jsonConvert.convert<double>(json['rmbAmount']);
  if (rmbAmount != null) {
    walletEntity.rmbAmount = rmbAmount;
  }
  final double? usdAmount = jsonConvert.convert<double>(json['usdAmount']);
  if (usdAmount != null) {
    walletEntity.usdAmount = usdAmount;
  }
  return walletEntity;
}

Map<String, dynamic> $WalletEntityToJson(WalletEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['rmbAmount'] = entity.rmbAmount;
  data['usdAmount'] = entity.usdAmount;
  return data;
}
