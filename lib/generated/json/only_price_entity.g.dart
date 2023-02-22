import 'package:inspector/app/data/only_price_entity.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

OnlyPriceEntity $OnlyPriceEntityFromJson(Map<String, dynamic> json) {
  final OnlyPriceEntity onlyPriceEntity = OnlyPriceEntity();
  final bool? isAuto = jsonConvert.convert<bool>(json['isAuto']);
  if (isAuto != null) {
    onlyPriceEntity.isAuto = isAuto;
  }
  final String? huiLv = jsonConvert.convert<String>(json['huiLv']);
  if (huiLv != null) {
    onlyPriceEntity.huiLv = huiLv;
  }
  final String? text = jsonConvert.convert<String>(json['text']);
  if (text != null) {
    onlyPriceEntity.text = text;
  }
  return onlyPriceEntity;
}

Map<String, dynamic> $OnlyPriceEntityToJson(OnlyPriceEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['isAuto'] = entity.isAuto;
  data['huiLv'] = entity.huiLv;
  data['text'] = entity.text;
  return data;
}
