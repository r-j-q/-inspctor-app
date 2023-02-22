import 'package:get/get.dart';

import '../controllers/check_controller.dart';

class CheckBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckController>(
      () => CheckController(),
    );
  }
}
