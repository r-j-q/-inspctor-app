import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/modules/auth/mine_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

class AddBankController extends GetxController {
  MineProvider provider = MineProvider();
  List<TextEditingController> textControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  List<String> titles = [
    LocaleKeys.add_bank_name.tr,
    LocaleKeys.add_bank_branch.tr,
    LocaleKeys.add_bank_card.tr,
    LocaleKeys.add_bank_address.tr,
    LocaleKeys.add_bank_real_name.tr,
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void fetchAddBank() {
    final bankName = textControllers[0].text;
    if (bankName.isEmpty) {
      showToast(titles[0]);
      return;
    }
    final branch = textControllers[1].text;
    if (branch.isEmpty) {
      showToast(titles[1]);
      return;
    }
    final card = textControllers[2].text;
    if (card.isEmpty) {
      showToast(titles[2]);
      return;
    }
    final realName = textControllers[3].text;
    if (realName.isEmpty) {
      showToast(titles[3]);
      return;
    }
    final address = textControllers[4].text;
    if (address.isEmpty) {
      showToast(titles[4]);
      return;
    }

    EasyLoading.show();
    provider.addBank(address, card, branch, bankName, realName).then((value) async {
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
    textControllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }
}
