import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/data/report_entity.dart';
import 'package:inspector/app/modules/order/order_provider.dart';
import 'package:inspector/app/tools/public_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

class CheckController extends GetxController {
  OrderProvider provider = OrderProvider();
  final picturesUrls = <String>[''].obs;
  final picturesPaths = <String>[''].obs;
  final textControllers = <TextEditingController>[TextEditingController()].obs;
  final reportUrl = ''.obs;
  final reportPath = ''.obs;
  final fileUrl = ''.obs;
  final filePath = ''.obs;
  int? orderId;
  //0-未上传1-待审核2-通过3-不通过  5上传了
  final status = 0.obs;

  @override
  void onInit() {
    super.onInit();

    orderId = Get.arguments;
    fetchReportInfo();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void deleteImage(int index) {
    picturesPaths.removeAt(index);
    picturesUrls.removeAt(index);
    textControllers[index].dispose();
    textControllers.removeAt(index);
  }

  void fetchReportInfo() {
    if (orderId == null) {
      return;
    }
    provider.takeReportInfo(orderId!).then((value) async {
      if (value.isSuccess) {
        final report = value.data ?? ReportEntity();
        final pics = report.fileModels?.map((e) => e.file!).toList() ?? [];
        if (report.status == 2) {
          picturesUrls.value = pics;
        } else {
          picturesUrls.value.insertAll(0, pics);
        }

        status.value = value.data?.status ?? 0;
        final fileModels = report.fileModels ?? [];
        for (int i = 0; i < fileModels.length; i++) {
          textControllers.add(TextEditingController());
          picturesPaths.add('');
          textControllers[i].text = fileModels[i].desc ?? '';
        }
        reportUrl.value = report.inspUrl ?? '';
        fileUrl.value = report.lianzheng ?? '';
      } else {
        showToast(value.message ?? '');
      }
    });
  }

  void uploadImage(bool report, int index) {
    FilesPicker.openImage(false).then((value) {
      if (value == null || value.isEmpty) {
        return;
      }

      if (report) {
        reportPath.value = value;
      } else {
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
      }

      PublicProvider.uploadImages(value, UploadType.plain).then((url) async {
        if (url == null || value.isEmpty) {
          showToast(LocaleKeys.profile_info_failed.tr);
          if (report) {
            reportPath.value = '';
          } else {
            picturesPaths[index] = '';
          }
          return;
        }
        if (report) {
          reportUrl.value = url;
        } else {
          picturesUrls[index] = url;
          if (picturesUrls.last.isNotEmpty) {
            picturesPaths.add('');
            picturesUrls.add('');
            textControllers.add(TextEditingController());
          }
        }
      });
    });
  }

  void deleteFile() {
    filePath.value = '';
    fileUrl.value = '';
  }

  void deleteReport() {
    reportPath.value = '';
    reportUrl.value = '';
  }

  void uploadFile() {
    FilesPicker.openFile().then((value) {
      if (value == null || value.isEmpty) {
        return;
      }
      filePath.value = value;
      fileUrl.value = '';

      PublicProvider.uploadImages(value, UploadType.plain).then((url) async {
        if (url == null || value.isEmpty) {
          showToast(LocaleKeys.profile_info_failed.tr);
          filePath.value = '';
          return;
        }
        fileUrl.value = url;
      });
    });
  }

  void saveReport() {
    List<Map<String, String>> pictures = [];
    for (int i = 0; i < textControllers.length - 1; i++) {
      final text = textControllers.value[i].text;
      final url = picturesUrls.value[i];
      if (url.isEmpty) {
        showToast(LocaleKeys.check_picture.tr);
        return;
      }
      if (text.isEmpty) {
        showToast(LocaleKeys.check_hint.tr);
        return;
      }
      pictures.add({'file': url, 'desc': text});
    }

    if (reportUrl.value.isEmpty) {
      showToast(LocaleKeys.check_report.tr);
      return;
    }

    if (fileUrl.value.isEmpty) {
      showToast(LocaleKeys.check_file.tr);
      return;
    }

    EasyLoading.show();
    provider
        .takeReportSave(orderId!, pictures, reportUrl.value, fileUrl.value)
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
}
