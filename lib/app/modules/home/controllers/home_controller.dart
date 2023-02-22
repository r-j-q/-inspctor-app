import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/constant.dart';
import 'package:inspector/app/modules/home/controllers/home_list_controller.dart';
import 'package:inspector/app/modules/home/home_provider.dart';
import 'package:inspector/app/modules/home/list_detail/controllers/list_detail_controller.dart';
import 'package:inspector/app/modules/home/views/inspection_view.dart';
import 'package:inspector/app/modules/order/order_provider.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  HomeProvider provider = HomeProvider();
  OrderProvider orderProvider = OrderProvider();
  TabController? tabController;
  TextEditingController editingController = TextEditingController();
  final isCheck = true.obs;
  final accountType = 1.obs;
  FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    int index = 0;
    tabController?.addListener(() {
      final isChange = !(tabController?.indexIsChanging ?? true);
      if (index != tabController?.index && isChange) {
        index = tabController?.index ?? 0;
        Get.find<HomeListController>(tag: index.toString())
            .fetchOrderList(false);
      }
    });
    accountType.value =
        GlobalConst.sharedPreferences?.getInt(Constant.accountType) ?? 1;
  }

  @override
  void onReady() {
    super.onReady();
  }

  void fetchPrice(int id, bool isFirst) {
    final isYanHuoYuan = GlobalConst.userModel?.isYanHuoYuan ?? false;
    if (isYanHuoYuan) {
      final checkStatus = GlobalConst.userModel?.checkStatus ?? 0;
      if (checkStatus != 2) {
        showCustomDialog(LocaleKeys.home_complete_profile_tips.tr,
            okTitle: LocaleKeys.home_complete_profile_sure.tr, onConfirm: () {
          Get.toNamed(Routes.APPLY);
        }, cancel: true);
        return;
      }
    } else {
      showCustomDialog(LocaleKeys.home_apply_tips.tr,
          okTitle: LocaleKeys.home_apply_sure.tr, onConfirm: () {
        Get.toNamed(Routes.APPLY);
      }, cancel: true);
      return;
    }
    EasyLoading.show();
    provider.takePrice(id).then((value) async {
      if (value.isSuccess) {
        final price = double.parse(value.data['price']);
        editingController.text = price.toString();

        Get.generalDialog(
          pageBuilder: (ctx, a1, a2) {
            return InspectionView(id, isFirst);
          },
        );
      } else {
        showToast(value.message ?? '');
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void fetchApply(int orderId) {
    if (!isCheck.value) {
      showToast(LocaleKeys.home_apply_check.tr);
      return;
    }
    if (editingController.text.isEmpty) {
      return;
    }
    var price = editingController.text;

    EasyLoading.show();
    provider.takeApply(orderId, price, accountType.value).then((value) async {
      if (value.isSuccess) {
        Get.back();
        Get.find<HomeListController>(tag: tabController!.index.toString())
            .updateApply(orderId, true);
        if (Get.currentRoute.contains(Routes.LIST_DETAIL)) {
          Get.find<ListDetailController>().updateApply(true);
        }
      }
      showToast(value.message ?? '');
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void canAction(int orderId, bool isSelf) {
    EasyLoading.show();
    orderProvider.takeOrderCancel(orderId, !isSelf).then((value) async {
      if (value.isSuccess) {
        Get.back();
        Get.find<HomeListController>(tag: tabController!.index.toString())
            .updateApply(orderId, false);
        if (Get.currentRoute.contains(Routes.LIST_DETAIL)) {
          Get.find<ListDetailController>().updateApply(false);
        }
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
    tabController?.dispose();
    editingController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
