import 'package:get/get.dart';
import 'package:inspector/app/modules/auth/mine_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/assets.dart';
import 'package:inspector/generated/locales.g.dart';

import '../../../../data/bind_pay_entity.dart';

class WalletController extends GetxController {
  final provider = MineProvider();
  final icons = [
    Assets.imagesRedCnyIcon,
    Assets.imagesRedUsdIcon,
    Assets.imagesBankIcon,
    Assets.imagesWechatIcon,
    Assets.imagesAlipayIcon,
    Assets.imagesPaypalIcon,
  ];
  final titles = [
    LocaleKeys.wallet_rmb_account.tr,
    LocaleKeys.wallet_usd_account.tr,
    LocaleKeys.wallet_bank.tr,
    LocaleKeys.wallet_wechat.tr,
    LocaleKeys.wallet_alipay.tr,
    LocaleKeys.pay_paypal.tr,
  ];
  final values = ['0', '0', '', '', '', ''].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWalletInfo();
    fetchPayInfo();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void fetchWalletInfo() {
    provider.wallet().then((value) async {
      if (value.isSuccess) {
        values[0] = (value.data?.rmbAmount ?? 0).toString();
        values[1] = (value.data?.usdAmount ?? 0).toString();
      } else {
        showToast(value.message ?? '');
      }
    });
  }

  void fetchPayInfo() {
    provider.bindPayInfo().then((value) async {
      if (value.isSuccess) {
        values[3] = value.data
                ?.firstWhere((element) => element.type == 1,
                    orElse: () => BindPayEntity())
                .account ??
            '';
        values[4] = value.data
                ?.firstWhere((element) => element.type == 2,
                    orElse: () => BindPayEntity())
                .account ??
            '';
        values[5] = value.data
                ?.firstWhere((element) => element.type == 3,
                    orElse: () => BindPayEntity())
                .account ??
            '';
      } else {
        // showToast(value.message ?? '');
      }
    });
  }

  @override
  void onClose() {}
}
