import 'package:get/get.dart';

class WebController extends GetxController {
  //TODO: Implement WebController

  final count = 0.obs;
  final url = "".obs;
  @override
  void onInit() {
    url.value = Get.parameters['url']!;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
