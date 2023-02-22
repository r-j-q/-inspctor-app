import 'package:get/get.dart';

import '../controllers/bind_bank_controller.dart';

class BindBankBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BindBankController>(
      () => BindBankController(),
    );
  }
}
