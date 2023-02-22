import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/constant.dart';

class InitController extends GetxController {
  //0-英文 1-中文 2-法语 3-德语
  final language = 999.obs;
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  SwiperController swiperController = SwiperController();
  final dataList = <TimeZone>[].obs;
  final guideList = <dynamic>[].obs;
  var isStart = false;
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    dataList.value = Constant.timeZones;
  }

  @override
  void onReady() {
    super.onReady();
  }

  void searchWords() {
    final text = controller.text.trim();
    var temp = Constant.timeZones;
    temp.retainWhere(
        (element) => element.zone.toUpperCase().contains(text.toUpperCase()));
    dataList.value = temp;
  }

  @override
  void onClose() {}

  @override
  void dispose() async {
    controller.dispose();
    scrollController.dispose();
    swiperController.dispose();
    super.dispose();
  }
}
