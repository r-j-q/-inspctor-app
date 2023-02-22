import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/data/bind_pay_entity.dart';
import 'package:inspector/app/modules/auth/mine_provider.dart';
import 'package:inspector/app/tools/public_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

class BinPayController extends GetxController {
  final provider = MineProvider();
  TextEditingController editingController1 = TextEditingController();
  TextEditingController editingController2 = TextEditingController();
  //1-微信 2-支付宝 3-paypal
  final type = 1.obs;
  final imagePath = ''.obs;
  final imageUrl = ''.obs;
  final payInfo = BindPayEntity().obs;

  @override
  void onInit() {
    super.onInit();

    type.value = Get.arguments ?? 1;
    fetchPayInfo();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void uploadImage() {
    FilesPicker.openImage(false).then((value) {
      if (value == null || value.isEmpty) {
        return;
      }
      imagePath.value = value;

      PublicProvider.uploadImages(value, UploadType.plain).then((url) async {
        if (url == null || value.isEmpty) {
          showToast(LocaleKeys.profile_info_failed.tr);
          imagePath.value = value;
          return;
        }
        imageUrl.value = url;
      });
    });
  }

  void fetchBind() {
    if (editingController1.text.isEmpty) {
      showToast(LocaleKeys.bind_account.tr);
      return;
    }
    if (editingController2.text.isEmpty) {
      showToast(LocaleKeys.bind_name.tr);
      return;
    }
    if (imageUrl.value.isEmpty) {
      showToast(LocaleKeys.bind_image.tr);
      return;
    }

    EasyLoading.show();
    provider
        .bindPay(editingController1.text, imageUrl.value,
            editingController2.text, type.value)
        .then((value) async {
      if (value.isSuccess) {
        Get.back();
      }
      showToast(value.message ?? '');
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void fetchPayInfo() {
    provider.bindPayInfo().then((value) async {
      if (value.isSuccess) {
        payInfo.value = value.data?.firstWhere(
                (element) => element.type == type.value,
                orElse: () => BindPayEntity()) ??
            BindPayEntity();
        final isUrl = payInfo.value.image?.isURL ?? false;
        if (isUrl) {
          imagePath.value = 'xx';
        }
        imageUrl.value = payInfo.value.image ?? '';
        editingController1.text = payInfo.value.account ?? '';
        editingController2.text = payInfo.value.name ?? '';
      } else {
        showToast(value.message ?? '');
      }
    });
  }

  @override
  void onClose() {}

  @override
  void dispose() {
    editingController1.dispose();
    editingController2.dispose();
    super.dispose();
  }
}
