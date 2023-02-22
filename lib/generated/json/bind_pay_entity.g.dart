import 'package:inspector/app/data/bind_pay_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

BindPayEntity $BindPayEntityFromJson(Map<String, dynamic> json) {
  final BindPayEntity bindPayEntity = BindPayEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    bindPayEntity.id = id;
  }
  final int? userId = jsonConvert.convert<int>(json['userId']);
  if (userId != null) {
    bindPayEntity.userId = userId;
  }
  final String? account = jsonConvert.convert<String>(json['account']);
  if (account != null) {
    bindPayEntity.account = account;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    bindPayEntity.type = type;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    bindPayEntity.name = name;
  }
  final String? image = jsonConvert.convert<String>(json['image']);
  if (image != null) {
    bindPayEntity.image = image;
  }
  final String? created = jsonConvert.convert<String>(json['created']);
  if (created != null) {
    bindPayEntity.created = created;
  }
  final String? updated = jsonConvert.convert<String>(json['updated']);
  if (updated != null) {
    bindPayEntity.updated = updated;
  }
  return bindPayEntity;
}

Map<String, dynamic> $BindPayEntityToJson(BindPayEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['userId'] = entity.userId;
  data['account'] = entity.account;
  data['type'] = entity.type;
  data['name'] = entity.name;
  data['image'] = entity.image;
  data['created'] = entity.created;
  data['updated'] = entity.updated;
  return data;
}
