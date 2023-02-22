import 'package:inspector/app/data/order_list_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

OrderListEntity $OrderListEntityFromJson(Map<String, dynamic> json) {
  final OrderListEntity orderListEntity = OrderListEntity();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    orderListEntity.total = total;
  }
  final List<OrderListRows>? rows =
      jsonConvert.convertListNotNull<OrderListRows>(json['rows']);
  if (rows != null) {
    orderListEntity.rows = rows;
  }
  return orderListEntity;
}

Map<String, dynamic> $OrderListEntityToJson(OrderListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['rows'] = entity.rows?.map((v) => v.toJson()).toList();
  return data;
}

OrderListRows $OrderListRowsFromJson(Map<String, dynamic> json) {
  final OrderListRows orderListRows = OrderListRows();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    orderListRows.id = id;
  }
  final String? provinceCity =
      jsonConvert.convert<String>(json['provinceCity']);
  if (provinceCity != null) {
    orderListRows.provinceCity = provinceCity;
  }
  final String? date = jsonConvert.convert<String>(json['date']);
  if (date != null) {
    orderListRows.date = date;
  }
  final String? distance = jsonConvert.convert<String>(json['distance']);
  if (distance != null) {
    orderListRows.distance = distance;
  }
  final String? award = jsonConvert.convert<String>(json['award']);
  if (award != null) {
    orderListRows.award = award;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    orderListRows.address = address;
  }
  final String? inspectionDate =
      jsonConvert.convert<String>(json['inspectionDate']);
  if (inspectionDate != null) {
    orderListRows.inspectionDate = inspectionDate;
  }
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    orderListRows.type = type;
  }
  final int? inspNumber = jsonConvert.convert<int>(json['inspNumber']);
  if (inspNumber != null) {
    orderListRows.inspNumber = inspNumber;
  }
  final int? inspDay = jsonConvert.convert<int>(json['inspDay']);
  if (inspDay != null) {
    orderListRows.inspDay = inspDay;
  }
  final String? reportType = jsonConvert.convert<String>(json['reportType']);
  if (reportType != null) {
    orderListRows.reportType = reportType;
  }
  final String? productName = jsonConvert.convert<String>(json['productName']);
  if (productName != null) {
    orderListRows.productName = productName;
  }
  final String? applyStatus = jsonConvert.convert<String>(json['applyStatus']);
  if (applyStatus != null) {
    orderListRows.applyStatus = applyStatus;
  }
  final int? applyNum = jsonConvert.convert<int>(json['applyNum']);
  if (applyNum != null) {
    orderListRows.applyNum = applyNum;
  }
  final double? lon = jsonConvert.convert<double>(json['lon']);
  if (lon != null) {
    orderListRows.lon = lon;
  }
  final double? lat = jsonConvert.convert<double>(json['lat']);
  if (lat != null) {
    orderListRows.lat = lat;
  }
  final int? multipleDate = jsonConvert.convert<int>(json['multipleDate']);
  if (multipleDate != null) {
    orderListRows.multipleDate = multipleDate;
  }
  final List<OrderListRows>? children =
      jsonConvert.convertListNotNull<OrderListRows>(json['children']);
  if (children != null) {
    orderListRows.children = children;
  }
  return orderListRows;
}

Map<String, dynamic> $OrderListRowsToJson(OrderListRows entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['provinceCity'] = entity.provinceCity;
  data['distance'] = entity.distance;
  data['award'] = entity.award;
  data['address'] = entity.address;
  data['inspectionDate'] = entity.inspectionDate;
  data['date'] = entity.date;
  data['type'] = entity.type;
  data['inspNumber'] = entity.inspNumber;
  data['inspDay'] = entity.inspDay;
  data['reportType'] = entity.reportType;
  data['productName'] = entity.productName;
  data['applyStatus'] = entity.applyStatus;
  data['applyNum'] = entity.applyNum;
  data['lon'] = entity.lon;
  data['lat'] = entity.lat;
  return data;
}
