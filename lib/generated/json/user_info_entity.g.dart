import 'package:inspector/app/data/user_info_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

UserInfoEntity $UserInfoEntityFromJson(Map<String, dynamic> json) {
  final UserInfoEntity userInfoEntity = UserInfoEntity();
  final String? head = jsonConvert.convert<String>(json['head']);
  if (head != null) {
    userInfoEntity.head = head;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    userInfoEntity.name = name;
  }
  final dynamic? position = jsonConvert.convert<dynamic>(json['position']);
  if (position != null) {
    userInfoEntity.position = position;
  }
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    userInfoEntity.phone = phone;
  }
  final String? mobile = jsonConvert.convert<String>(json['mobile']);
  if (mobile != null) {
    userInfoEntity.phone = mobile;
  }
  final String? email = jsonConvert.convert<String>(json['email']);
  if (email != null) {
    userInfoEntity.email = email;
  }
  final String? wechatNum = jsonConvert.convert<String>(json['wechatNum']);
  if (wechatNum != null) {
    userInfoEntity.wechatNum = wechatNum;
  }
  final bool? isYanHuoYuan = jsonConvert.convert<bool>(json['isYanHuoYuan']);
  if (isYanHuoYuan != null) {
    userInfoEntity.isYanHuoYuan = isYanHuoYuan;
  }
  final String? token = jsonConvert.convert<String>(json['token']);
  if (token != null) {
    userInfoEntity.token = token;
  }
  //mydev
  final String? im_token = jsonConvert.convert<String>(json['im_token']);
  if (im_token != null) {
    userInfoEntity.im_token = im_token;
  }
  final int? checkStatus = jsonConvert.convert<int>(json['checkStatus']);
  if (checkStatus != null) {
    userInfoEntity.checkStatus = checkStatus;
  }
  final int? uid = jsonConvert.convert<int>(json['uid']);
  if (uid != null) {
    userInfoEntity.uid = uid;
  }
  return userInfoEntity;
}

Map<String, dynamic> $UserInfoEntityToJson(UserInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['head'] = entity.head;
  data['name'] = entity.name;
  data['position'] = entity.position;
  data['phone'] = entity.phone;
  data['email'] = entity.email;
  data['wechatNum'] = entity.wechatNum;
  data['isYanHuoYuan'] = entity.isYanHuoYuan;
  data['token'] = entity.token;
  data['checkStatus'] = entity.checkStatus;
  data['uid'] = entity.uid;
  //mydev
  data['im_token'] = entity.im_token;
  return data;
}
