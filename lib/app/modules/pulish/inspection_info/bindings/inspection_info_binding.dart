import 'package:get/get.dart';

import '../controllers/inspection_info_controller.dart';

class InspectionInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InspectionInfoController>(
      () => InspectionInfoController(),
    );
  }
}
