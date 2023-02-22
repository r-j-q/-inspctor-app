import 'package:get/get.dart';

import '../controllers/charge_controller.dart';

class ChargeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChargeController>(
      () => ChargeController(),
    );
  }
}
