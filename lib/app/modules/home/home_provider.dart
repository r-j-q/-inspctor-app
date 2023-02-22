import 'package:inspector/app/config/api.dart';
import 'package:inspector/app/data/order_list_entity.dart';
import 'package:inspector/app/data/public_model.dart';
import 'package:inspector/app/tools/public_provider.dart';

class HomeProvider {
  //获取验货列表
  Future<BaseModel<OrderListEntity>> takeOrderList(int orderType,
      {int page = 0, int limit = 10, double? lat, double? lon}) {
    return PublicProvider.request<OrderListEntity>(
        path: Api.orderList,
        params: {'orderType': orderType, 'page': page, 'limit': limit, 'lat': lat, 'lon': lon});
  }

  //获取标准价格
  Future<BaseModel<dynamic>> takePrice(int id) {
    return PublicProvider.request<dynamic>(path: Api.standPrice + '/$id', isPost: false);
  }

  //申请
  Future<BaseModel<dynamic>> takeApply(int orderId, String price, int accountType) {
    return PublicProvider.request<dynamic>(
        path: Api.orderApply,
        params: {'orderId': orderId, 'price': price, 'accountType': accountType});
  }

  //获取申请列表
  Future<BaseModel<OrderListEntity>> takeRecordList({int page = 0, int limit = 10}) {
    return PublicProvider.request<OrderListEntity>(
        path: Api.applyList, params: {'page': page, 'limit': limit});
  }
}
