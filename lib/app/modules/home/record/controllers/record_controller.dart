import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/data/order_list_entity.dart';
import 'package:inspector/app/modules/home/home_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RecordController extends GetxController {
  HomeProvider provider = HomeProvider();
  RefreshController refreshController = RefreshController();
  final dataList = <OrderListRows>[].obs;
  var page = 0;
  bool isMore = false;

  @override
  void onInit() {
    super.onInit();

    fetchRecordList(false);
  }

  @override
  void onReady() {
    super.onReady();
  }

  void refreshAction() {
    page == 1;
    fetchRecordList(false);
  }

  void loadMore() {
    page++;
    fetchRecordList(true);
  }

  void fetchRecordList(bool isMore) {
    EasyLoading.show();
    var total = 0;

    provider.takeRecordList(page: page).then((value) async {
      if (value.isSuccess) {
        var models = value.data?.rows ?? [];
        total = value.data?.total ?? 0;
        if (!isMore) {
          dataList.value = [];
        }
        dataList.addAll(models);
      } else {
        showToast(value.message ?? '');
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
      refreshController.refreshCompleted();
      if (dataList.isEmpty || total == dataList.length) {
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
