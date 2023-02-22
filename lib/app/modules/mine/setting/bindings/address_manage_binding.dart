import 'package:get/get.dart';

import '../controllers/address_manage_controller.dart';

class Address_manageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Address_manageController());
  }
}
