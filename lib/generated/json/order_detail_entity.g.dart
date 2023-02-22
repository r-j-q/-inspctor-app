import 'package:inspector/app/data/order_detail_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

OrderDetailEntity $OrderDetailEntityFromJson(Map<String, dynamic> json) {
  final OrderDetailEntity orderDetailEntity = OrderDetailEntity();
  final String? orderNo = jsonConvert.convert<String>(json['orderNo']);
  if (orderNo != null) {
    orderDetailEntity.orderNo = orderNo;
  }
  final int? userAccount = jsonConvert.convert<int>(json['userAccount']);
  if (userAccount != null) {
    orderDetailEntity.userAccount = userAccount;
  }
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    orderDetailEntity.price = price;
  }
  final String? inspectTime = jsonConvert.convert<String>(json['inspectTime']);
  if (inspectTime != null) {
    orderDetailEntity.inspectTime = inspectTime;
  }
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    orderDetailEntity.type = type;
  }
  final String? provinceCity =
      jsonConvert.convert<String>(json['provinceCity']);
  if (provinceCity != null) {
    orderDetailEntity.provinceCity = provinceCity;
  }
  final String? factoryName = jsonConvert.convert<String>(json['factoryName']);
  if (factoryName != null) {
    orderDetailEntity.factoryName = factoryName;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    orderDetailEntity.name = name;
  }
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    orderDetailEntity.phone = phone;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    orderDetailEntity.address = address;
  }
  final String? email = jsonConvert.convert<String>(json['email']);
  if (email != null) {
    orderDetailEntity.email = email;
  }
  final List<OrderDateEntity>? timeBeans =
      jsonConvert.convertListNotNull<OrderDateEntity>(json['timeBeans']);
  if (timeBeans != null) {
    orderDetailEntity.timeBeans = timeBeans;
  }
  final String? remark = jsonConvert.convert<String>(json['remark']);
  if (remark != null) {
    orderDetailEntity.remark = remark;
  }
  final String? productName = jsonConvert.convert<String>(json['productName']);
  if (productName != null) {
    orderDetailEntity.productName = productName;
  }
  final List<String>? imageFile =
      jsonConvert.convertListNotNull<String>(json['imageFile']);
  if (imageFile != null) {
    orderDetailEntity.imageFile = imageFile;
  } else {
    orderDetailEntity.imageFile = [];
  }
  final List<String>? file =
      jsonConvert.convertListNotNull<String>(json['file']);
  if (file != null) {
    orderDetailEntity.file = file;
  } else {
    orderDetailEntity.file = [];
  }
  final bool? isLookInspection =
      jsonConvert.convert<bool>(json['isLookInspection']);
  if (isLookInspection != null) {
    orderDetailEntity.isLookInspection = isLookInspection;
  }
  final bool? isApply = jsonConvert.convert<bool>(json['isApply']);
  if (isApply != null) {
    orderDetailEntity.isApply = isApply;
  }
  final bool? isSelf = jsonConvert.convert<bool>(json['isSelf']);
  if (isSelf != null) {
    orderDetailEntity.isSelf = isSelf;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    orderDetailEntity.status = status;
  }
  final int? payType = jsonConvert.convert<int>(json['payType']);
  if (payType != null) {
    orderDetailEntity.payType = payType;
  }
  final int? addressId = jsonConvert.convert<int>(json['addressId']);
  if (addressId != null) {
    orderDetailEntity.addressId = addressId;
  }
  final int? reportStatus = jsonConvert.convert<int>(json['reportStatus']);
  if (reportStatus != null) {
    orderDetailEntity.reportStatus = reportStatus;
  }
  final int? priceType = jsonConvert.convert<int>(json['priceType']);
  if (priceType != null) {
    orderDetailEntity.priceType = priceType;
  }
  final String? city = jsonConvert.convert<String>(json['city']);
  if (city != null) {
    orderDetailEntity.city = city;
  }
  final int? inspectType = jsonConvert.convert<int>(json['inspectType']);
  if (inspectType != null) {
    orderDetailEntity.inspectType = inspectType;
  }
  final String? createdTime = jsonConvert.convert<String>(json['createdTime']);
  if (createdTime != null) {
    orderDetailEntity.createdTime = createdTime;
  }

  return orderDetailEntity;
}

Map<String, dynamic> $OrderDetailEntityToJson(OrderDetailEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['orderNo'] = entity.orderNo;
  data['userAccount'] = entity.userAccount;
  data['price'] = entity.price;
  data['inspectTime'] = entity.inspectTime;
  data['type'] = entity.type;
  data['provinceCity'] = entity.provinceCity;
  data['factoryName'] = entity.factoryName;
  data['name'] = entity.name;
  data['phone'] = entity.phone;
  data['address'] = entity.address;
  data['email'] = entity.email;
  data['remark'] = entity.remark;
  data['productName'] = entity.productName;
  data['imageFile'] = entity.imageFile;
  data['file'] = entity.file;
  data['isLookInspection'] = entity.isLookInspection;
  data['isApply'] = entity.isApply;
  data['isSelf'] = entity.isSelf;
  data['status'] = entity.status;
  data['payType'] = entity.payType;
  data['reportStatus'] = entity.reportStatus;
  data['addressId'] = entity.addressId;
  data['priceType'] = entity.priceType;
  data['city'] = entity.city;
  data['inspectType'] = entity.inspectType;
  data['createdTime'] = entity.createdTime;
  data['timeBeans'] = entity.timeBeans?.map((v) => v.toJson()).toList();

  return data;
}

OrderDateEntity $OrderDateEntityFromJson(Map<String, dynamic> json) {
  final OrderDateEntity orderDetailEntity = OrderDateEntity();
  final String? date = jsonConvert.convert<String>(json['date']);
  if (date != null) {
    orderDetailEntity.date = date;
  }
  final int? inspectNum = jsonConvert.convert<int>(json['inspectNum']);
  if (inspectNum != null) {
    orderDetailEntity.inspectNum = inspectNum;
  }

  return orderDetailEntity;
}

Map<String, dynamic> $OrderDateEntityToJson(OrderDateEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['inspectNum'] = entity.inspectNum;
  data['date'] = entity.date;

  return data;
}
