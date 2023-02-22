import 'package:get/get.dart';

import '../controllers/bill_list_controller.dart';

class BillListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BillListController>(
      () => BillListController(),
    );
  }
}
