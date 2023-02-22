import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/constant.dart';
import 'package:inspector/app/data/order_list_entity.dart';
import 'package:inspector/app/modules/home/home_provider.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeListController extends GetxController {
  RefreshController refreshController = RefreshController();
  HomeProvider provider = HomeProvider();

  int pageIndex = 0;
  int page = 0;
  final listEntity = <OrderListRows>[].obs;

  @override
  void onReady() {
    super.onReady();

    fetchOrderList(false);
  }

  void refreshAction() {
    page = 1;
    fetchOrderList(false);
  }

  void loadMore() {
    page++;
    fetchOrderList(true);
  }

  void updateApply(int id, bool isApply) {
    listEntity.value = listEntity.value.map((element) {
      if (element.id == id) {
        element.applyStatus =
            isApply ? LocaleKeys.order_applying.tr : LocaleKeys.order_apply.tr;
        final applyNum = element.applyNum ?? 0;
        element.applyNum = isApply ? applyNum + 1 : applyNum - 1;
      }
      return element;
    }).toList();
    listEntity.refresh();
  }

  void fetchOrderList(bool isMore) {
    if (pageIndex == 1) {
      Location.share.requestPermission();
    }

    final lat = GlobalConst.sharedPreferences?.getDouble(Constant.lat);
    final lon = GlobalConst.sharedPreferences?.getDouble(Constant.lon);

    EasyLoading.show();
    var total = 0;
    provider
        .takeOrderList(pageIndex, page: page, lat: lat, lon: lon)
        .then((value) async {
      if (value.isSuccess) {
        var models = value.data?.rows ?? [];
        total = value.data?.total ?? 0;
        if (!isMore) {
          listEntity.value = [];
        }
        var tempList = <OrderListRows>[];
        tempList.addAll(listEntity);
        tempList.addAll(models);
        connectRows(tempList);
        listEntity.value.clear();
        listEntity.addAll(tempList);
      } else {
        showToast(value.message ?? '');
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
      refreshController.refreshCompleted();
      if (listEntity.isEmpty || total == listEntity.length) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    });
  }

  void connectRows(List<OrderListRows> models) {
    OrderListRows? prev = null;
    for (int i = 0; i < models.length; i++) {
      OrderListRows current = models[i];
      if (prev == null) {
        current.connectLast = false;
      } else {
        int prevId = prev.id!;
        List<int> childrenIds = [];
        current.children?.forEach((element) {
          if (element.id != null) {
            childrenIds.add(element.id!);
          }
        });
        if (childrenIds.contains(prevId)) {
          prev.connectNext = true;
          current.connectLast = true;
        }
      }
      prev = current;
    }
  }

  @override
  void onClose() {}

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }
}
