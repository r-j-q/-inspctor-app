import 'package:inspector/app/data/publish_conv_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

PublishConvEntity $PublishConvEntityFromJson(Map<String, dynamic> json) {
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
  final Map? record = jsonConvert.convert<Map>(json['record']);

  if (record != null) {
    publishConvRows.record = record;
  }
  final Map? object_info =
      jsonConvert.convert<Map<String, dynamic>>(json['object_info']);

  if (object_info != null) {
    publishConvRows.object_info = object_info;
  }
  return publishConvRows;
}

Map<String, dynamic> $PublishConvRowsToJson(PublishConvRows entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['status'] = entity.status;
  data['unread'] = entity.unread;
  data['datetime'] = entity.datetime;
  data['record'] = entity.record;
  data['object_info'] = entity.object_info;
  return data;
}

/*RecordRows $RecordRowsFromJson(Map<String, dynamic> json) {
  final RecordRows recordRows = RecordRows();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    recordRows.id = id;
  }
  final String? brief = jsonConvert.convert<String>(json['brief']);
  if (brief != null) {
    recordRows.brief = brief;
  }
 
  return recordRows;
}

Map<String, dynamic> $RecordRowsToJson(RecordRows entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['brief'] = entity.brief;
  return data;
}*/
