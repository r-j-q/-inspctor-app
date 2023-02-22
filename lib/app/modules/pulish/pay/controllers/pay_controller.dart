import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/modules/pulish/publish_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/assets.dart';
import 'package:inspector/generated/locales.g.dart';
import 'package:tobias/tobias.dart' as tobias;

import '../../../../routes/app_pages.dart';
import '../../../order/order_list/controllers/order_list_controller.dart';

class PayController extends GetxController {
  bool isUsd = false;
  num price = 0;
  String? orderId;
  PublishProvider provider = PublishProvider();
  List<String> titles = [
    LocaleKeys.pay_zfb.tr,
    LocaleKeys.pay_paypal.tr,
    LocaleKeys.pay_usd.tr + '(${LocaleKeys.pay_keep.tr})',
    LocaleKeys.pay_rmb.tr + '(${LocaleKeys.pay_keep.tr})',
  ];
  List<String> icons = [
    Assets.imagesZhifubao,
    Assets.imagesPaypalIcon,
    Assets.imagesUsdIcon,
    Assets.imagesCnyIcon,
  ];
  final index = 0.obs;
  //1-平台 2-paypal 3-支付宝 4-其他
  var payType = 3;

  @override
  void onInit() {
    super.onInit();
    orderId = Get.arguments['id'];
    isUsd = Get.arguments['usd'] ?? false;
    price = Get.arguments['price'];

    index.value = isUsd ? 1 : 0;
  }

  /// 秒转时分秒
  String second2MS(int sec) {
    String hms = "00:00";
    if (sec > 0) {
      int h = sec ~/ 3600;
      int m = (sec % 3600) ~/ 60;
      int s = sec % 60;
      hms = "${zeroFill(m)}:${zeroFill(s)}";
    }
    return hms;
  }

  String zeroFill(int i) {
    return i >= 10 ? "$i" : "0$i";
  }

  void checkPayType(int index) {
    payType = 1;
    if (index == 0) {
      payType = 3;
    } else if (index == 1) {
      payType = 2;
    }
  }

  void payAction(dynamic order) {
    if (index.value == 0) {
      //zfb
      if (order['aliPayurl'] == null) {
        showToast('获取支付信息失败');
        return;
      }
      var text = order['aliPayurl'] as String;
      tobias.aliPay(text, evn: tobias.AliPayEvn.ONLINE).then((value) {
        if (value['resultStatus'] == '9000') {
          showToast(LocaleKeys.pay_result_success.tr);
          Future.delayed(Duration(seconds: 1), () {
            Get.back(result: true);
          });
        } else {
          showToast(LocaleKeys.pay_result_failed.tr);
        }
        logger.e('value ${value}');
      });
    } else if (index.value == 1) {
      //paypal

    } else {
      // if (Get.currentRoute.contains(Routes.ORDER_LIST1)) {
      // Get.find<OrderListController>().takePublish(0, 0, 10);
      // Get.find<OrderListController>().fetchPublishList(false);
      Future.delayed(Duration(milliseconds: 300), () {
        Get.find<OrderListController>(tag: "0").refreshAction();
      });
      // }
      showToast(LocaleKeys.pay_result_success.tr);
      Get.back(result: true);
    }
  }

  void fetchPayInfo() {
    EasyLoading.show();
    provider.payOrder(payType, orderId!.toString()).then((value) {
      if (value.isSuccess) {
        payAction(value.data);
      } else {
        showToast(value.message ?? '获取支付信息失败');
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  @override
  void dispose() {
    super.dispose();
  }
}
