import 'package:inspector/app/data/order_input_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

OrderInputEntity $OrderInputEntityFromJson(Map<String, dynamic> json) {
  final OrderInputEntity orderInputEntity = OrderInputEntity();
  final int? addressId = jsonConvert.convert<int>(json['addressId']);
  if (addressId != null) {
    orderInputEntity.addressId = addressId;
  }
  final List<DateTime>? dateList = jsonConvert.convertListNotNull<DateTime>(json['dateList']);
  if (dateList != null) {
    orderInputEntity.dateList = dateList;
  }
  final String? file = jsonConvert.convert<String>(json['file']);
  if (file != null) {
    orderInputEntity.file = file;
  }
  final String? imageFile = jsonConvert.convert<String>(json['imageFile']);
  if (imageFile != null) {
    orderInputEntity.imageFile = imageFile;
  }
  final int? inspectNum = jsonConvert.convert<int>(json['inspectNum']);
  if (inspectNum != null) {
    orderInputEntity.inspectNum = inspectNum;
  }
  final int? inspectType = jsonConvert.convert<int>(json['inspectType']);
  if (inspectType != null) {
    orderInputEntity.inspectType = inspectType;
  }
  final int? payType = jsonConvert.convert<int>(json['payType']);
  if (payType != null) {
    orderInputEntity.payType = payType;
  }
  final num? price = jsonConvert.convert<num>(json['price']);
  if (price != null) {
    orderInputEntity.price = price;
  }
  final String? productName = jsonConvert.convert<String>(json['productName']);
  if (productName != null) {
    orderInputEntity.productName = productName;
  }
  final String? remark = jsonConvert.convert<String>(json['remark']);
  if (remark != null) {
    orderInputEntity.remark = remark;
  }
  final String? payText = jsonConvert.convert<String>(json['payText']);
  if (payText != null) {
    orderInputEntity.payText = payText;
  }
  final bool? isUSD = jsonConvert.convert<bool>(json['isUSD']);
  if (isUSD != null) {
    orderInputEntity.isUSD = isUSD;
  }
  final String? orderId = jsonConvert.convert<String>(json['orderId']);
  if (orderId != null) {
    orderInputEntity.orderId = orderId;
  }
  return orderInputEntity;
}

Map<String, dynamic> $OrderInputEntityToJson(OrderInputEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['addressId'] = entity.addressId;
  data['dateList'] = entity.dateList?.map((v) => v.toIso8601String()).toList();
  data['file'] = entity.file;
  data['imageFile'] = entity.imageFile;
  data['inspectNum'] = entity.inspectNum;
  data['inspectType'] = entity.inspectType;
  data['payType'] = entity.payType;
  data['price'] = entity.price;
  data['productName'] = entity.productName;
  data['remark'] = entity.remark;
  data['payText'] = entity.payText;
  data['isUSD'] = entity.isUSD;
  data['orderId'] = entity.orderId;
  return data;
}
