import 'package:get/get.dart';
import 'package:inspector/app/data/order_explain_entity.dart';
import 'package:inspector/generated/assets.dart';
import 'package:inspector/generated/locales.g.dart';

class PublishController extends GetxController {
  final indexType = (-1).obs;
  List<OrderExplain> explains = [
    OrderExplain(
      Assets.imagesMark1,
      LocaleKeys.publish_sampling.tr,
      LocaleKeys.publish_sampling_content.tr,
      LocaleKeys.publish_point.tr,
      LocaleKeys.publish_sampling_point.tr,
      null,
      null,
      1,
    ),
    OrderExplain(
      Assets.imagesMark2,
      LocaleKeys.publish_all.tr,
      LocaleKeys.publish_all_content.tr,
      LocaleKeys.publish_point.tr,
      LocaleKeys.publish_sampling_point.tr,
      null,
      null,
      2,
    ),
    OrderExplain(
      Assets.imagesMark3,
      LocaleKeys.publish_online.tr,
      LocaleKeys.publish_online_content.tr,
      LocaleKeys.publish_point.tr,
      LocaleKeys.publish_online_point.tr,
      null,
      null,
      3,
    ),
    OrderExplain(
      Assets.imagesMark4,
      LocaleKeys.publish_factory.tr,
      LocaleKeys.publish_factory_content.tr,
      LocaleKeys.publish_factory_point_title.tr,
      LocaleKeys.publish_factory_point.tr,
      LocaleKeys.publish_factory_review.tr,
      LocaleKeys.publish_factory_review_content.tr,
      4,
    ),
    OrderExplain(
      Assets.imagesMark5,
      LocaleKeys.publish_watch.tr,
      LocaleKeys.publish_watch_content.tr,
      LocaleKeys.publish_point.tr,
      LocaleKeys.publish_watch_point.tr,
      null,
      null,
      5,
    ),
    OrderExplain(
      Assets.imagesMark5,
      LocaleKeys.publish_watch_inspection.tr,
      LocaleKeys.publish_watch_inspection_content.tr,
      LocaleKeys.publish_point.tr,
      LocaleKeys.publish_watch_inspection_point.tr,
      null,
      null,
      6,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  void checkData(int type) {
    if (indexType.value == type) {
      indexType.value = -1;
    } else {
      indexType.value = type;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
