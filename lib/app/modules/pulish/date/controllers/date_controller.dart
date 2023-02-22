import 'package:get/get.dart';

class DateController extends GetxController {
  final selectDates = <Map<DateTime, int>>[].obs;
  final outDates = <Map<DateTime, int>>[].obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is List<Map<DateTime, int>>) {
      selectDates.value = List.from(Get.arguments);
      outDates.value = List.from(Get.arguments);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
