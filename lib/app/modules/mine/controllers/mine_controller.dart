import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/data/user_info_entity.dart';
import 'package:inspector/app/data/wallet_entity.dart';
import 'package:inspector/app/modules/auth/mine_provider.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/tools.dart';

class MineController extends GetxController {
  final provider = MineProvider();
  final wallet = WalletEntity().obs;
  Rx<UserInfoEntity> infoEntity = UserInfoEntity().obs;

  @override
  void onInit() {
    super.onInit();

    if (GlobalConst.userModel != null) {
      infoEntity.value = GlobalConst.userModel!;
    }
  }

  @override
  void onReady() {
    super.onReady();

    loadData();
  }

  void loadData() {
    fetchUserInfo();
    fetchWalletInfo();
  }

  void fetchUserInfo() {
    provider.takeMineInfo().then((value) async {
      if (value.isSuccess) {
        infoEntity.value = value.data ?? UserInfoEntity();
        infoEntity.value.token = GlobalConst.userModel?.token;
        infoEntity.value.isYanHuoYuan = value.data?.isYanHuoYuan ?? false;
        //mydev
        infoEntity.value.im_token = GlobalConst.userModel?.im_token;
        GlobalConst.tempModel = null;
        await GlobalConst.saveUser(infoEntity.value);
      } else {
        showToast(value.message ?? '');
      }
    });
  }

  void fetchRecommend(String email) {
    EasyLoading.show();
    provider.takeRecommend(email).then((value) async {
      showToast(value.message ?? '');
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void fetchWalletInfo() {
    provider.wallet().then((value) async {
      if (value.isSuccess) {
        wallet.value = value.data ?? WalletEntity();
        wallet.refresh();
      } else {
        showToast(value.message ?? '');
      }
    });
  }

  @override
  void onClose() {}
}
