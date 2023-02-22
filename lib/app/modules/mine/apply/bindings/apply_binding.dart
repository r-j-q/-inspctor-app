import 'package:get/get.dart';

import '../controllers/apply_controller.dart';

class ApplyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplyController>(
      () => ApplyController(),
    );
  }
}
