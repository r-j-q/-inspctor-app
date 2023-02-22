import 'package:get/get.dart';
import 'package:inspector/app/modules/order/order_list/controllers/order_list_controller.dart';

import '../controllers/order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(() => OrderController());
    Get.lazyPut<OrderListController>(() => OrderListController());
  }
}
