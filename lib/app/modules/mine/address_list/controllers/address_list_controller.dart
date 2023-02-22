import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/data/address_entity.dart';
import 'package:inspector/app/modules/auth/mine_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AddressListController extends GetxController {
  MineProvider provider = MineProvider();
  int page = 0;
  int total = 0;
  final addressList = <AddressRows>[].obs;
  bool isManager = false;
  RefreshController refreshController = RefreshController();

  @override
  void onInit() {
    super.onInit();

    isManager = Get.arguments ?? false;
    fetchAddressList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void freshData() {
    page = 0;
    fetchAddressList();
  }

  void loadMore() {
    if (addressList.length >= total) {
      refreshController.loadComplete();
      refreshController.refreshCompleted();
      return;
    } else {
      page++;
      fetchAddressList();
    }
  }

  void fetchAddressList() {
    EasyLoading.show();
    provider.addressList(page, 10).then((value) {
      if (value.isSuccess) {
        addressList.value = value.data?.rows ?? [];
        total = value.data?.total ?? 0;
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
      refreshController.loadComplete();
      refreshController.refreshCompleted();
    });
  }

  void fetchAddressDelete(int id) {
    EasyLoading.show();
    provider.addressDelete(id).then((value) {
      if (value.isSuccess) {
        fetchAddressList();
      }
      showToast(value.message ?? '');
    }).catchError((e) {
      showToast(LocaleKeys.address_delete_result.tr);
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  @override
  void onClose() {}

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }
}
