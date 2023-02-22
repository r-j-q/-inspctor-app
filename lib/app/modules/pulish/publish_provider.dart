import 'package:inspector/app/config/api.dart';
import 'package:inspector/app/data/only_price_entity.dart';
import 'package:inspector/app/data/public_model.dart';
import 'package:inspector/app/data/vip_price_entity.dart';
import 'package:inspector/app/tools/public_provider.dart';

class PublishProvider {
  //一口价查询
  Future<BaseModel<OnlyPriceEntity>> onlyPrice() {
    return PublicProvider.request<OnlyPriceEntity>(path: Api.onlyPrice);
  }

  //vip价查询
  Future<BaseModel<VipPriceEntity>> vipPrice(
      int day, String city, int person, type) {
    return PublicProvider.request<VipPriceEntity>(path: Api.vipPrice, params: {
      'day': day,
      'inspectCity': city,
      'inspectNum': person,
      'inspectType': type
    });
  }

  //提交订单
  Future<BaseModel<dynamic>> submitOrder(
      int addressId,
      List<Map<String, dynamic>> dateList,
      List<String> file,
      List<String> imageFile,
      int inspectType,
      num price,
      String productName,
      String? remark,
      int userAccount,
      int priceType,
      {int? orderId}) {
    var api = Api.submitOrder;
    if (orderId != null) {
      api = Api.orderEdit;
    }
    return PublicProvider.request<dynamic>(path: api, params: {
      'addressId': addressId,
      'timeBeans': dateList,
      'file': file,
      'imageFile': imageFile,
      'inspectType': inspectType,
      'price': price,
      'productName': productName,
      'remark': remark,
      'userAccount': userAccount,
      'priceType': priceType,
      'orderId': orderId,
    });
  }

  //订单支付
  Future<BaseModel<dynamic>> payOrder(int payType, String orderId) {
    return PublicProvider.request<dynamic>(
        path: Api.payOrder, params: {'payType': payType, 'orderId': orderId});
  }

  //充值支付
  Future<BaseModel<dynamic>> payCharge(int payType, String orderId) {
    return PublicProvider.request<dynamic>(
        path: Api.payCharge, params: {'payType': payType, 'orderId': orderId});
  }
}
