import 'package:inspector/app/data/area_list_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

AreaListEntity $AreaListEntityFromJson(Map<String, dynamic> json) {
  final AreaListEntity areaListEntity = AreaListEntity();
  final double? id = jsonConvert.convert<double>(json['id']);
  if (id != null) {
    areaListEntity.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    areaListEntity.name = name;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    areaListEntity.code = code;
  }
  return areaListEntity;
}

Map<String, dynamic> $AreaListEntityToJson(AreaListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['code'] = entity.code;
  return data;
}
