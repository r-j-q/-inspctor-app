import 'package:get/get.dart';

import '../controllers/cash_controller.dart';

class CashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CashController>(
      () => CashController(),
    );
  }
}
