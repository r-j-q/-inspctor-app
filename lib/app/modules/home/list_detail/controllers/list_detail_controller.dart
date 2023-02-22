import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/data/order_detail_entity.dart';
import 'package:inspector/app/modules/order/order_provider.dart';
import 'package:inspector/app/modules/pulish/publish_provider.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

class ListDetailController extends GetxController {
  OrderProvider provider = OrderProvider();
  PublishProvider payProvider = PublishProvider();
  int? orderId;
  final detailEntity = OrderDetailEntity().obs;
  bool isChange = false;
  bool isApply = false;
  var days = 0;
  var peoples = 0;

  @override
  void onInit() {
    super.onInit();
    orderId = Get.arguments;
    if (Get.parameters['isApply'] != null) {
      isApply = true;
    }
    if (orderId != null) {
      fetchOrderDetail();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  void updateApply(bool isApply) {
    detailEntity.value.isApply = isApply;
    detailEntity.refresh();
  }

  void fetchOrderDetail() {
    EasyLoading.show();
    peoples = 0;
    provider.takeOrderDetail(orderId!).then((value) async {
      if (value.isSuccess) {
        detailEntity.value = value.data ?? OrderDetailEntity();
        detailEntity.value.timeBeans?.forEach((element) {
          peoples += (element.inspectNum ?? 0);
        });
        days = detailEntity.value.timeBeans?.length ?? 0;
        detailEntity.refresh();
      } else {
        showToast(value.message ?? '');
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void fetchImGroup() {
    EasyLoading.show();
    provider.takeImGroup(orderId!).then((value) async {
      if (value.isSuccess) {
        final gid = value.data['gid'] as int?;
        final name = value.data['name'] as String?;
        if (gid != null) {
          Get.toNamed(Routes.CHAT, parameters: {'gid': gid.toString(), 'name': name!});
        }
      } else {
        showToast(value.message ?? '');
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void payAction() {
    Get.toNamed(Routes.PAY, arguments: {
      'usd': detailEntity.value.userAccount == 2 ? true : false,
      'id': detailEntity.value.orderNo!,
      'price': detailEntity.value.price ?? 0
    })?.then((value) {
      isChange = true;
      fetchOrderDetail();
    });
  }

  void fetchCancel() {
    final isSelf = detailEntity.value.isSelf ?? false;

    if (isSelf) {
      showCustomDialog(LocaleKeys.order_sure_cancel.tr, onConfirm: () {
        canAction();
      }, cancel: true);
    } else {
      canAction();
    }
  }

  void canAction() {
    final isSelf = detailEntity.value.isSelf ?? false;

    EasyLoading.show();
    provider.takeOrderCancel(orderId!, !isSelf).then((value) async {
      if (value.isSuccess) {
        if (detailEntity.value.status != 2 || isSelf) {
          detailEntity.value.status = 9;
        } else {
          detailEntity.value.isApply = false;
        }
        isChange = true;
        detailEntity.refresh();
      }
      showToast(value.message ?? '');
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void fetchStart() {
    EasyLoading.show();
    provider.takeOrderStart(orderId!).then((value) async {
      if (value.isSuccess) {
        detailEntity.value.status = 6;
        isChange = true;
        detailEntity.refresh();
        Get.toNamed(Routes.CHECK, arguments: orderId!);
        EasyLoading.dismiss();
      } else {
        showToast(value.message ?? '');
      }
    }).catchError((e) {
      showToast(e.toString());
    });
  }

  @override
  void onClose() {}
}
