import 'dart:convert';

import 'package:inspector/generated/json/baidu_ocr_entity.g.dart';
import 'package:inspector/generated/json/base/json_field.dart';

@JsonSerializable()
class BaiduOcrEntity {
  String? province;
  String? city;
  @JSONField(name: "province_code")
  String? provinceCode;
  @JSONField(name: "log_id")
  int? logId;
  String? text;
  String? town;
  String? phonenum;
  String? detail;
  String? county;
  String? person;
  double? lat;
  double? lng;
  @JSONField(name: "town_code")
  String? townCode;
  @JSONField(name: "county_code")
  String? countyCode;
  @JSONField(name: "city_code")
  String? cityCode;

  BaiduOcrEntity();

  factory BaiduOcrEntity.fromJson(Map<String, dynamic> json) => $BaiduOcrEntityFromJson(json);

  Map<String, dynamic> toJson() => $BaiduOcrEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
