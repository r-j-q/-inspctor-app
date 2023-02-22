import 'package:inspector/app/config/api.dart';
import 'package:inspector/app/data/order_detail_entity.dart';
import 'package:inspector/app/data/public_model.dart';
import 'package:inspector/app/data/publish_order_entity.dart';
import 'package:inspector/app/data/report_entity.dart';
import 'package:inspector/app/tools/public_provider.dart';

class OrderProvider {
  //我的验货列表
  Future<BaseModel<PublishOrderEntity>> takeInspections(int? type, int page, int pageSize) {
    var params = {'limit': pageSize, 'page': page};
    if (type != null) {
      params['flag'] = type;
    }
    return PublicProvider.request<PublishOrderEntity>(path: Api.inspectionList, params: params);
  }

  //我的发布列表
  Future<BaseModel<PublishOrderEntity>> takePublish(int? type, int page, int pageSize) {
    var params = {'limit': pageSize, 'page': page};
    if (type != null) {
      params['flag'] = type;
    }
    return PublicProvider.request<PublishOrderEntity>(path: Api.publishList, params: params);
  }

  //订单详情
  Future<BaseModel<OrderDetailEntity>> takeOrderDetail(int id) {
    return PublicProvider.request<OrderDetailEntity>(
        path: Api.orderDetail + '/$id/desc', isPost: false);
  }

  //开始验货
  Future<BaseModel<dynamic>> takeOrderStart(int id) {
    return PublicProvider.request<dynamic>(path: Api.startOrder + '/$id', isPost: false);
  }

  //验货员取消订单
  Future<BaseModel<dynamic>> takeOrderCancel(int id, bool ins) {
    if (ins) {
      return PublicProvider.request<dynamic>(path: Api.cancelInsOrder + '/$id', isDelete: true);
    }
    return PublicProvider.request<dynamic>(path: Api.cancelOrder + '/$id', isDelete: true);
  }

  //获取报告信息
  Future<BaseModel<ReportEntity>> takeReportInfo(int id) {
    return PublicProvider.request<ReportEntity>(path: Api.reportInfo + '/$id', isPost: false);
  }

  //提交报告信息
  Future<BaseModel<dynamic>> takeReportSave(
      int id, List<Map<String, String>> pictures, String report, String file) {
    return PublicProvider.request<dynamic>(path: Api.reportSave, params: {
      'fileModels': pictures,
      'inspUrl': report,
      'lianzheng': file,
      'orderId': id,
    });
  }

  //提交评价
  Future<BaseModel<dynamic>> takeCommentSave(
      int id, List<String> pictures, String content, int score) {
    return PublicProvider.request<dynamic>(path: Api.orderComment, params: {
      'image': pictures,
      'score': score,
      'content': content,
      'orderId': id,
    });
  }

  //获取群聊信息
  Future<BaseModel<dynamic>> takeImGroup(int id) {
    return PublicProvider.request<dynamic>(path: Api.imGroup + '/$id', isPost: false);
  }
}
