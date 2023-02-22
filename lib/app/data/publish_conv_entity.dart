import 'dart:convert';
import 'package:inspector/generated/json/base/json_field.dart';
import 'package:inspector/generated/json/publish_conv_entity.g.dart';

@JsonSerializable()
class PublishConvEntity {
  int? total;
  List<PublishConvRows>? rows;

  PublishConvEntity();

  factory PublishConvEntity.fromJson(Map<String, dynamic> json) =>
      $PublishConvEntityFromJson(json);

  Map<String, dynamic> toJson() => $PublishConvEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class PublishConvRows {
  int? id;
  int? status;
  int? unread;
  String? datetime;
  Map? record;
  // ignore: non_constant_identifier_names
  Map? object_info;

  PublishConvRows();

  factory PublishConvRows.fromJson(Map<String, dynamic> json) =>
      $PublishConvRowsFromJson(json);

  Map<String, dynamic> toJson() => $PublishConvRowsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

/*@JsonSerializable()
class RecordRows {
  int? id;
  String? brief;
  RecordRows();

  factory RecordRows.fromJson(Map<String, dynamic> json) =>
      $RecordRowsFromJson(json);

  Map<String, dynamic> toJson() => $RecordRowsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}*/
