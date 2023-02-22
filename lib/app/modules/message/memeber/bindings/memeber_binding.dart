import 'package:get/get.dart';

import '../controllers/memeber_controller.dart';

class MemeberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MemeberController>(
      () => MemeberController(),
    );
  }
}
