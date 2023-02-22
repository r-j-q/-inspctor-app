import 'package:inspector/app/data/vip_price_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

VipPriceEntity $VipPriceEntityFromJson(Map<String, dynamic> json) {
  final VipPriceEntity vipPriceEntity = VipPriceEntity();
  final String? usdPrice = jsonConvert.convert<String>(json['usdPrice']);
  if (usdPrice != null) {
    vipPriceEntity.usdPrice = usdPrice;
  }
  final String? rmbPrice = jsonConvert.convert<String>(json['rmbPrice']);
  if (rmbPrice != null) {
    vipPriceEntity.rmbPrice = rmbPrice;
  }
  final String? rmbDesc = jsonConvert.convert<String>(json['rmbDesc']);
  if (rmbDesc != null) {
    vipPriceEntity.rmbDesc = rmbDesc;
  }
  final String? usdDesc = jsonConvert.convert<String>(json['usdDesc']);
  if (usdDesc != null) {
    vipPriceEntity.usdDesc = usdDesc;
  }
  return vipPriceEntity;
}

Map<String, dynamic> $VipPriceEntityToJson(VipPriceEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['usdPrice'] = entity.usdPrice;
  data['rmbPrice'] = entity.rmbPrice;
  data['rmbDesc'] = entity.rmbDesc;
  data['usdDesc'] = entity.usdDesc;
  return data;
}
