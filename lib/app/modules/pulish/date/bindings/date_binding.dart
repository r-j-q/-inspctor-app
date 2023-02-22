import 'package:get/get.dart';

import '../controllers/date_controller.dart';

class DateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DateController>(
      () => DateController(),
    );
  }
}
