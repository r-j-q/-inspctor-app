import 'package:inspector/app/data/baidu_ocr_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

BaiduOcrEntity $BaiduOcrEntityFromJson(Map<String, dynamic> json) {
  final BaiduOcrEntity baiduOcrEntity = BaiduOcrEntity();
  final String? province = jsonConvert.convert<String>(json['province']);
  if (province != null) {
    baiduOcrEntity.province = province;
  }
  final String? city = jsonConvert.convert<String>(json['city']);
  if (city != null) {
    baiduOcrEntity.city = city;
  }
  final String? provinceCode = jsonConvert.convert<String>(json['province_code']);
  if (provinceCode != null) {
    baiduOcrEntity.provinceCode = provinceCode;
  }
  final int? logId = jsonConvert.convert<int>(json['log_id']);
  if (logId != null) {
    baiduOcrEntity.logId = logId;
  }
  final String? text = jsonConvert.convert<String>(json['text']);
  if (text != null) {
    baiduOcrEntity.text = text;
  }
  final String? town = jsonConvert.convert<String>(json['town']);
  if (town != null) {
    baiduOcrEntity.town = town;
  }
  final String? phonenum = jsonConvert.convert<String>(json['phonenum']);
  if (phonenum != null) {
    baiduOcrEntity.phonenum = phonenum;
  }
  final String? detail = jsonConvert.convert<String>(json['detail']);
  if (detail != null) {
    baiduOcrEntity.detail = detail;
  }
  final String? county = jsonConvert.convert<String>(json['county']);
  if (county != null) {
    baiduOcrEntity.county = county;
  }
  final String? person = jsonConvert.convert<String>(json['person']);
  if (person != null) {
    baiduOcrEntity.person = person;
  }
  final double? lat = jsonConvert.convert<double>(json['lat']);
  if (lat != null) {
    baiduOcrEntity.lat = lat;
  }
  final double? lng = jsonConvert.convert<double>(json['lng']);
  if (lng != null) {
    baiduOcrEntity.lng = lng;
  }
  final String? townCode = jsonConvert.convert<String>(json['town_code']);
  if (townCode != null) {
    baiduOcrEntity.townCode = townCode;
  }
  final String? countyCode = jsonConvert.convert<String>(json['county_code']);
  if (countyCode != null) {
    baiduOcrEntity.countyCode = countyCode;
  }
  final String? cityCode = jsonConvert.convert<String>(json['city_code']);
  if (cityCode != null) {
    baiduOcrEntity.cityCode = cityCode;
  }
  return baiduOcrEntity;
}

Map<String, dynamic> $BaiduOcrEntityToJson(BaiduOcrEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['province'] = entity.province;
  data['city'] = entity.city;
  data['province_code'] = entity.provinceCode;
  data['log_id'] = entity.logId;
  data['text'] = entity.text;
  data['town'] = entity.town;
  data['phonenum'] = entity.phonenum;
  data['detail'] = entity.detail;
  data['county'] = entity.county;
  data['person'] = entity.person;
  data['lat'] = entity.lat;
  data['lng'] = entity.lng;
  data['town_code'] = entity.townCode;
  data['county_code'] = entity.countyCode;
  data['city_code'] = entity.cityCode;
  return data;
}
