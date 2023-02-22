import 'dart:convert';

import 'package:inspector/generated/json/base/json_field.dart';
import 'package:inspector/generated/json/wallet_entity.g.dart';

@JsonSerializable()
class WalletEntity {
  double? rmbAmount;
  double? usdAmount;

  WalletEntity();

  factory WalletEntity.fromJson(Map<String, dynamic> json) => $WalletEntityFromJson(json);

  Map<String, dynamic> toJson() => $WalletEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
