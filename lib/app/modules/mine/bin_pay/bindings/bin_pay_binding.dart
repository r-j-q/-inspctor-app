import 'package:get/get.dart';

import '../controllers/bin_pay_controller.dart';

class BinPayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BinPayController>(
      () => BinPayController(),
    );
  }
}
