import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/modules/order/order_provider.dart';
import 'package:inspector/app/tools/public_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

class ReviewController extends GetxController {
  OrderProvider provider = OrderProvider();
  int? orderId;
  final scoreIndex = 0.obs;
  final picturesUrls = <String>[''].obs;
  final picturesPaths = <String>[''].obs;
  TextEditingController editingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    orderId = Get.arguments;
  }

  @override
  void onReady() {
    super.onReady();
  }

  void deleteImage(int index) {
    picturesPaths.removeAt(index);
    picturesUrls.removeAt(index);
  }

  void uploadImage(bool report, int index) {
    FilesPicker.openImage(false).then((value) {
      if (value == null || value.isEmpty) {
        return;
      }

      if (index < picturesPaths.length) {
        picturesPaths[index] = value;
      } else {
        picturesPaths.add(value);
      }
      if (index < picturesUrls.length) {
        picturesUrls[index] = '';
      } else {
        picturesUrls.add('');
      }

      PublicProvider.uploadImages(value, UploadType.plain).then((url) async {
        if (url == null || value.isEmpty) {
          showToast(LocaleKeys.profile_info_failed.tr);
          picturesPaths[index] = '';
          return;
        }
        picturesUrls[index] = url;
        if (picturesUrls.last.isNotEmpty) {
          picturesPaths.add('');
          picturesUrls.add('');
        }
      });
    });
  }

  void saveComment() {
    EasyLoading.show();
    provider
        .takeCommentSave(orderId!, picturesUrls.value, editingController.text,
            scoreIndex.value + 1)
        .then((value) async {
      if (value.isSuccess) {
        Future.delayed(Duration(seconds: 1), () {
          Get.back(result: true);
        });
      }
      showToast(value.message ?? '');
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  @override
  void onClose() {}

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }
}
