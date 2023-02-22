import 'package:inspector/app/data/publish_order_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

PublishOrderEntity $PublishOrderEntityFromJson(Map<String, dynamic> json) {
  final PublishOrderEntity publishOrderEntity = PublishOrderEntity();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    publishOrderEntity.total = total;
  }
  final List<PublishOrderRows>? rows =
      jsonConvert.convertListNotNull<PublishOrderRows>(json['rows']);
  if (rows != null) {
    publishOrderEntity.rows = rows;
  }
  return publishOrderEntity;
}

Map<String, dynamic> $PublishOrderEntityToJson(PublishOrderEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['rows'] = entity.rows?.map((v) => v.toJson()).toList();
  return data;
}

PublishOrderRows $PublishOrderRowsFromJson(Map<String, dynamic> json) {
  final PublishOrderRows publishOrderRows = PublishOrderRows();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    publishOrderRows.id = id;
  }
  final int? orderId = jsonConvert.convert<int>(json['orderId']);
  if (orderId != null) {
    publishOrderRows.orderId = orderId;
  }
  final String? provinceCity = jsonConvert.convert<String>(json['provinceCity']);
  if (provinceCity != null) {
    publishOrderRows.provinceCity = provinceCity;
  }
  final String? province = jsonConvert.convert<String>(json['province']);
  if (province != null) {
    publishOrderRows.province = province;
  }
  final String? city = jsonConvert.convert<String>(json['city']);
  if (city != null) {
    publishOrderRows.city = city;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    publishOrderRows.address = address;
  }
  if (address == null) {
    final String? inspAddress = jsonConvert.convert<String>(json['inspAddress']);
    if (inspAddress != null) {
      publishOrderRows.address = inspAddress;
    }
  }
  final int? userAccount = jsonConvert.convert<int>(json['userAccount']);
  if (userAccount != null) {
    publishOrderRows.userAccount = userAccount;
  }
  final double? lat = jsonConvert.convert<double>(json['lat']);
  if (lat != null) {
    publishOrderRows.lat = lat;
  }
  final double? lon = jsonConvert.convert<double>(json['lon']);
  if (lon != null) {
    publishOrderRows.lon = lon;
  }
  final String? productName = jsonConvert.convert<String>(json['productName']);
  if (productName != null) {
    publishOrderRows.productName = productName;
  }
  final String? date = jsonConvert.convert<String>(json['date']);
  if (date != null) {
    publishOrderRows.date = date;
  }
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    publishOrderRows.price = price;
  }
  final int? flag = jsonConvert.convert<int>(json['flag']);
  if (flag != null) {
    publishOrderRows.flag = flag;
  }
  final int? addTime = jsonConvert.convert<int>(json['addTime']);
  if (addTime != null) {
    publishOrderRows.addTime = addTime;
  }
  return publishOrderRows;
}

Map<String, dynamic> $PublishOrderRowsToJson(PublishOrderRows entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['orderId'] = entity.orderId;
  data['provinceCity'] = entity.provinceCity;
  data['province'] = entity.province;
  data['city'] = entity.city;
  data['address'] = entity.address;
  data['userAccount'] = entity.userAccount;
  data['productName'] = entity.productName;
  data['date'] = entity.date;
  data['price'] = entity.price;
  data['flag'] = entity.flag;
  data['lat'] = entity.lat;
  data['lon'] = entity.lon;
  data['addTime'] = entity.addTime;
  return data;
}
