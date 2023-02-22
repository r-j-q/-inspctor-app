import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/modules/auth/mine_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';
import 'package:tobias/tobias.dart' as tobias;

class ChargeController extends GetxController {
  TextEditingController textController = TextEditingController();
  final accountType = 1.obs;
  MineProvider provider = MineProvider();
  //2-paypal 3-支付宝
  var payType = 3;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void fetchCharge() {
    final price = double.tryParse(textController.text) ?? 0;
    if (price <= 0) {
      showToast(LocaleKeys.charge_hint.tr);
      return;
    }

    EasyLoading.show();
    provider.recharge(price, payType, accountType.value).then((value) {
      if (value.isSuccess) {
        payAction(value.data);
      } else {
        showToast(value.message ?? '');
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void payAction(dynamic order) {
    if (payType == 3) {
      //zfb
      if (order['aliPayurl'] == null) {
        showToast('获取支付信息失败');
        return;
      }
      var text = order['aliPayurl'] as String;
      tobias.aliPay(text, evn: tobias.AliPayEvn.ONLINE).then((value) {
        if (value['resultStatus'] == '9000') {
          showToast(LocaleKeys.pay_result_success.tr);
          Get.back(result: true);
        } else {
          showToast(LocaleKeys.pay_result_failed.tr);
        }
        logger.e('value ${value}');
      });
    } else {}
  }

  @override
  void onClose() {}

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
