import 'package:get/get.dart';

import 'package:inspector/app/modules/home/controllers/home_list_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeListController>(
      () => HomeListController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
