import 'dart:convert';

import 'package:inspector/generated/json/base/json_field.dart';
import 'package:inspector/generated/json/report_entity.g.dart';

@JsonSerializable()
class ReportEntity {
  dynamic? orderId;
  List<ReportFileModels>? fileModels;
  String? inspUrl;
  String? lianzheng;
  //报告状态：0-未上传1-待审核2-通过3-不通过  5上传了
  int? status;

  ReportEntity();

  factory ReportEntity.fromJson(Map<String, dynamic> json) => $ReportEntityFromJson(json);

  Map<String, dynamic> toJson() => $ReportEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ReportFileModels {
  String? file;
  String? desc;

  ReportFileModels();

  factory ReportFileModels.fromJson(Map<String, dynamic> json) => $ReportFileModelsFromJson(json);

  Map<String, dynamic> toJson() => $ReportFileModelsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
