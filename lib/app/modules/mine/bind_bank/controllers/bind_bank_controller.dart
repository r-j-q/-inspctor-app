import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/data/bank_entity.dart';
import 'package:inspector/app/modules/auth/mine_provider.dart';

class BindBankController extends GetxController {
  MineProvider provider = MineProvider();
  final bankList = <BankEntity>[].obs;
  var needCheck = false;

  @override
  void onInit() {
    super.onInit();

    needCheck = Get.arguments ?? false;
    fetchBankList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void fetchBankList() {
    EasyLoading.show();
    provider.bankList().then((value) async {
      if (value.isSuccess) {
        bankList.value = value.data ?? [];
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void fetchDeleteBank(int id) {
    EasyLoading.show();
    provider.deleteBank(id).then((value) async {
      if (value.isSuccess) {
        fetchBankList();
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  @override
  void onClose() {}
}
