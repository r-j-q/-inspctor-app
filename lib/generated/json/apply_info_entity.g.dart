import 'package:inspector/app/data/apply_info_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

ApplyInfoEntity $ApplyInfoEntityFromJson(Map<String, dynamic> json) {
  final ApplyInfoEntity applyInfoEntity = ApplyInfoEntity();
  final String? province = jsonConvert.convert<String>(json['province']);
  if (province != null) {
    applyInfoEntity.province = province;
  }
  final String? city = jsonConvert.convert<String>(json['city']);
  if (city != null) {
    applyInfoEntity.city = city;
  }
  final String? area = jsonConvert.convert<String>(json['area']);
  if (area != null) {
    applyInfoEntity.area = area;
  }
  final String? price = jsonConvert.convert<String>(json['price']);
  if (price != null) {
    applyInfoEntity.price = price;
  }
  final String? education = jsonConvert.convert<String>(json['education']);
  if (education != null) {
    applyInfoEntity.education = education;
  }
  final String? idCardNum = jsonConvert.convert<String>(json['idCardNum']);
  if (idCardNum != null) {
    applyInfoEntity.idCardNum = idCardNum;
  }
  final String? idCardFront = jsonConvert.convert<String>(json['idCardFront']);
  if (idCardFront != null) {
    applyInfoEntity.idCardFront = idCardFront;
  }
  final String? idCardBack = jsonConvert.convert<String>(json['idCardBack']);
  if (idCardBack != null) {
    applyInfoEntity.idCardBack = idCardBack;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    applyInfoEntity.content = content;
  }
  final int? accountType = jsonConvert.convert<int>(json['accountType']);
  if (accountType != null) {
    applyInfoEntity.accountType = accountType;
  }
  final bool? socialSecurity = jsonConvert.convert<bool>(json['socialSecurity']);
  if (accountType != null) {
    applyInfoEntity.socialSecurity = socialSecurity;
  }

  return applyInfoEntity;
}

Map<String, dynamic> $ApplyInfoEntityToJson(ApplyInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['province'] = entity.province;
  data['city'] = entity.city;
  data['area'] = entity.area;
  data['price'] = entity.price;
  data['education'] = entity.education;
  data['idCardNum'] = entity.idCardNum;
  data['idCardFront'] = entity.idCardFront;
  data['idCardBack'] = entity.idCardBack;
  data['content'] = entity.content;
  data['accountType'] = entity.accountType;
  data['socialSecurity'] = entity.socialSecurity;
  return data;
}
