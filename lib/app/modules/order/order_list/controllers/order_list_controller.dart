import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/data/publish_order_entity.dart';
import 'package:inspector/app/modules/order/order_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderListController extends GetxController {
  RefreshController refreshController = RefreshController();
  OrderProvider provider = OrderProvider();
  final selectedIndex = 0.obs;
  var page = 0;
  //0-我的验货 1-我发布的
  var pageIndex = 0;
  final tabTitles = <String>[].obs;
  final listEntity = <PublishOrderRows>[].obs;

  OrderListController() {
    logger.i("OrderListController ${this.hashCode}");
  }

  @override
  void onReady() {
    super.onReady();

    if (pageIndex == 0) {
      fetchPublishList(false);
      tabTitles.value = [
        LocaleKeys.order_all.tr,
        LocaleKeys.order_wait_dispatch.tr,
        LocaleKeys.order_ready_inspect.tr,
        LocaleKeys.order_wait_pay.tr,
        LocaleKeys.order_cancelled.tr,
        LocaleKeys.order_finished.tr
      ];
    } else {
      tabTitles.value = [
        LocaleKeys.order_all.tr,
        LocaleKeys.order_confirm.tr,
        LocaleKeys.order_wait.tr,
        LocaleKeys.order_doing.tr,
        LocaleKeys.order_finished.tr
      ];
      fetchOrderList(false);
    }
  }

  void refreshAction() {
    page = 0;
    if (pageIndex == 0) {
      fetchPublishList(false);
    } else {
      fetchOrderList(false);
    }
  }

  void loadMore() {
    page++;
    if (pageIndex == 0) {
      fetchPublishList(true);
    } else {
      fetchOrderList(true);
    }
  }

  void fetchOrderList(bool isMore) {
    EasyLoading.show();
    var total = 0;

    int? type;
    if (selectedIndex.value == 1) {
      //派单确认
      type = 2;
    } else if (selectedIndex.value == 2) {
      //准备验货
      type = 3;
    } else if (selectedIndex.value == 3) {
      //验货中
      type = 4;
    } else if (selectedIndex.value == 4) {
      // 已完成
      type = 5;
    }

    provider.takeInspections(type, page, 10).then((value) async {
      if (value.isSuccess) {
        var models = value.data?.rows ?? [];
        total = value.data?.total ?? 0;
        if (!isMore) {
          listEntity.value = [];
        }
        listEntity.value.addAll(models);
      } else {
        listEntity.value = [];
        showToast(value.message ?? '');
      }
      listEntity.refresh();
    }).whenComplete(() {
      EasyLoading.dismiss();
      refreshController.refreshCompleted();
      if (total <= listEntity.length && listEntity.isNotEmpty) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    });
  }

  void fetchPublishList(bool isMore) {
    EasyLoading.show();
    var total = 0;

    int? type;
    if (selectedIndex.value == 1) {
      //待派单
      type = 1;
    } else if (selectedIndex.value == 2) {
      //准备验货
      type = 3;
    } else if (selectedIndex.value == 3) {
      //验货中
      type = 4;
    } else if (selectedIndex.value == 4) {
      //待支付
      type = 0;
    } else if (selectedIndex.value == 5) {
      //取消
      type = -1;
    } else if (selectedIndex.value == 6) {
      //已完成
      type = 5;
    }
    provider.takePublish(type, page, 10).then((value) async {
      if (value.isSuccess) {
        var models = value.data?.rows ?? [];
        total = value.data?.total ?? 0;
        if (!isMore) {
          listEntity.value = [];
        }
        listEntity.addAll(models);
      } else {
        listEntity.value = [];
        showToast(value.message ?? '');
      }
      listEntity.refresh();
    }).whenComplete(() {
      EasyLoading.dismiss();
      refreshController.refreshCompleted();
      if (total <= listEntity.length && listEntity.isNotEmpty) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    });
  }

  @override
  void onClose() {}

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }
}
