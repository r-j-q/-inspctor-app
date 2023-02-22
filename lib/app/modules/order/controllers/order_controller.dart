import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/modules/order/order_list/controllers/order_list_controller.dart';

class OrderController extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? pageTabController;

  @override
  void onInit() {
    Get.put(OrderListController());
    super.onInit();
    pageTabController = TabController(length: 2, vsync: this);

    int index = 0;
    pageTabController?.addListener(() {
      final isChange = !(pageTabController?.indexIsChanging ?? true);
      if (isChange) {
        return;
      }
      if (pageTabController?.index == 0 && index == 1) {
        Get.find<OrderListController>().fetchPublishList(false);
      } else if (pageTabController?.index == 1 && index == 0) {
        Get.find<OrderListController>().fetchPublishList(false);
      }
      index = pageTabController?.index ?? 0;
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
    pageTabController?.dispose();
    super.dispose();
  }
}
