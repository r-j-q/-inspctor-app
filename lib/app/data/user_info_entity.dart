import 'dart:convert';

import 'package:inspector/generated/json/base/json_field.dart';
import 'package:inspector/generated/json/user_info_entity.g.dart';

@JsonSerializable()
class UserInfoEntity {
  String? head;
  String? name;
  dynamic position;
  String? phone;
  String? email;
  String? wechatNum;
  bool? isYanHuoYuan;
  String? token;
  //mydev
  String? im_token;
  //0: 未提交 1:未审核 2：已审核  3:审核被拒
  int? checkStatus;
  int? uid;
  bool get emailHold {
    if (email == null || email!.isEmpty) {
      return false;
    }
    return true;
  }

  UserInfoEntity();

  factory UserInfoEntity.fromJson(Map<String, dynamic> json) =>
      $UserInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $UserInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
