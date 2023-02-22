import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/data/bank_entity.dart';
import 'package:inspector/app/modules/auth/mine_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/assets.dart';
import 'package:inspector/generated/locales.g.dart';

class CashController extends GetxController {
  TextEditingController textController = TextEditingController();
  final accountType = 1.obs;
  final price = 0.0.obs;
  final accountId = 0.obs;
  Rx<BankEntity> bank = BankEntity().obs;
  //2-PayPai 4-微信 5-支付宝 6银行卡
  final type = 0.obs;
  MineProvider provider = MineProvider();
  final icons = [
    Assets.imagesBankIcon,
    Assets.imagesWechatIcon,
    Assets.imagesAlipayIcon,
    Assets.imagesPaypalIcon,
  ];
  final titles = [
    LocaleKeys.wallet_bank.tr,
    LocaleKeys.wallet_wechat.tr,
    LocaleKeys.wallet_alipay.tr,
    LocaleKeys.pay_paypal.tr,
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void fetchCsh() {
    if (price <= 0) {
      showToast(LocaleKeys.cash_hint.tr);
      return;
    }

    EasyLoading.show();
    provider.takeCash(accountType.value, bank.value.id ?? 0, price.value, type.value).then((value) {
      if (value.isSuccess) {
        Get.back();
      }
      showToast(value.message ?? '');
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  @override
  void onClose() {}

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
