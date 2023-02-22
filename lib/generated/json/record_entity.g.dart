import 'package:inspector/app/data/publish_conv_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

RecordEntity $PublishConvEntityFromJson(Map<String, dynamic> json) {
  final PublishConvEntity publishConvEntity = PublishConvEntity();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    publishConvEntity.total = total;
  }
  final List<PublishConvRows>? rows =
      jsonConvert.convertListNotNull<PublishConvRows>(json['rows']);

  if (rows != null) {
    publishConvEntity.rows = rows;
  }
  return publishConvEntity;
}

Map<String, dynamic> $PublishConvEntityToJson(PublishConvEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['rows'] = entity.rows?.map((v) => v.toJson()).toList();
  return data;
}

PublishConvRows $PublishConvRowsFromJson(Map<String, dynamic> json) {
  final PublishConvRows publishConvRows = PublishConvRows();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    publishConvRows.id = id;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    publishConvRows.status = status;
  }
  final int? unread = jsonConvert.convert<int>(json['unread']);
  if (unread != null) {
    publishConvRows.unread = unread;
  }
  final String? datetime = jsonConvert.convert<String>(json['datetime']);
  if (datetime != null) {
    publishConvRows.datetime = datetime;
  }
  //publishConvRows.record = json['record']?.map((v) => v.toJson()).toList();
  return publishConvRows;
}

Map<String, dynamic> $PublishConvRowsToJson(PublishConvRows entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['status'] = entity.status;
  data['unread'] = entity.unread;
  data['datetime'] = entity.datetime;
  //data['record'] = entity.record;
  return data;
}
