import 'package:get/get.dart';
import 'package:inspector/app/config/constant.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';

class BaseModel<T> {
  int? status;
  String? statusMsg;

  int? code;
  String? message;
  bool? flag;
  dynamic oriResponse;
  T? data;
  bool isSuccess = false;

  BaseModel({this.code, this.message, this.flag, this.data});

  BaseModel.fromJson(response) {
    status = response?.statusCode;
    statusMsg = response?.statusMessage;

    if (status != 200 || response?.data == null) {
      return;
    }

    try {
      Map<String, dynamic> object = response!.data;
      oriResponse = object;
      if (object['code'] is String) {
        code = int.parse(object['code'] ?? '-1');
      } else {
        code = object['code'];
      }
      if (code == 20000) {
        isSuccess = true;
      } else if (code == 10005) {
        GlobalConst.tempModel = null;
        GlobalConst.sharedPreferences?.remove(Constant.kUser);
        if (Get.currentRoute == Routes.AUTH_LOGIN) {
          return;
        }
        Get.offAllNamed(Routes.AUTH_LOGIN);
        return;
      }
      message = object['message'];
      flag = object['flag'];
      final objectData = object['data'];

      if (objectData != null && objectData != 'null') {
        if ((objectData is Map || objectData is List) &&
            !(T.toString().contains('dynamic'))) {
          data = JsonConvert.fromJsonAsT<T>(objectData);
        } else {
          data = object['data'];
        }
      }
    } catch (e) {
      code = -888;
      message = '数据解析异常';
      logger.v('${response!.data.toString()} ${e.toString()}');
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['flag'] = flag;
    data['data'] = data;

    return data;
  }
}
