import 'package:inspector/app/data/report_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

ReportEntity $ReportEntityFromJson(Map<String, dynamic> json) {
  final ReportEntity reportEntity = ReportEntity();
  final dynamic? orderId = jsonConvert.convert<dynamic>(json['orderId']);
  if (orderId != null) {
    reportEntity.orderId = orderId;
  }
  final List<ReportFileModels>? fileModels =
      jsonConvert.convertListNotNull<ReportFileModels>(json['fileModels']);
  if (fileModels != null) {
    reportEntity.fileModels = fileModels;
  }
  final String? inspUrl = jsonConvert.convert<String>(json['inspUrl']);
  if (inspUrl != null) {
    reportEntity.inspUrl = inspUrl;
  }
  final String? lianzheng = jsonConvert.convert<String>(json['lianzheng']);
  if (lianzheng != null) {
    reportEntity.lianzheng = lianzheng;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    reportEntity.status = status;
  }
  return reportEntity;
}

Map<String, dynamic> $ReportEntityToJson(ReportEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['orderId'] = entity.orderId;
  data['fileModels'] = entity.fileModels?.map((v) => v.toJson()).toList();
  data['inspUrl'] = entity.inspUrl;
  data['lianzheng'] = entity.lianzheng;
  data['status'] = entity.status;
  return data;
}

ReportFileModels $ReportFileModelsFromJson(Map<String, dynamic> json) {
  final ReportFileModels reportFileModels = ReportFileModels();
  final String? file = jsonConvert.convert<String>(json['file']);
  if (file != null) {
    reportFileModels.file = file;
  }
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    reportFileModels.desc = desc;
  }
  return reportFileModels;
}

Map<String, dynamic> $ReportFileModelsToJson(ReportFileModels entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['file'] = entity.file;
  data['desc'] = entity.desc;
  return data;
}
