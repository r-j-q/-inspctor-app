import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/modules/auth/mine_provider.dart';
import 'package:inspector/app/tools/public_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

class ApplyController extends GetxController {
  TextEditingController editingController = TextEditingController();
  TextEditingController editingController1 = TextEditingController();
  TextEditingController editingController2 = TextEditingController();
  final accountType = 1.obs;

  MineProvider provider = MineProvider();
  List<String> titles = [
    LocaleKeys.apply_nick.tr,
    LocaleKeys.apply_sex.tr,
    LocaleKeys.apply_birthday.tr,
    LocaleKeys.apply_education.tr,
    LocaleKeys.apply_address.tr,
    LocaleKeys.apply_price.tr,
    LocaleKeys.apply_id_card.tr,
  ];
  final values = ['', '', '', '', '', '', '', '', '', ''].obs;
  var cardFrontPath = '';
  var cardBackPath = '';
  var content = ''.obs;
  final cardFrontUrl = ''.obs;
  final cardBackUrl = ''.obs;
  final province = ''.obs;
  final city = ''.obs;
  final area = ''.obs;
  final valueChange = false.obs;
  final enable = false.obs;
  final shebao = false.obs;
  final resumes = RxList<ResumeInfo>([]);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    fetchApplyInfo();
  }

  void dataState(bool front, String value) {
    if (front) {
      cardFrontPath = value;
      cardFrontUrl.value = value;
    } else {
      cardBackPath = value;
      cardBackUrl.value = value;
    }
  }

  void validInfo() {
    enable.value = false;
    if (values[5].isEmpty) {
      return;
    }
    if (values[6].isEmpty) {
      return;
    }
    //测试用
    // cardFrontUrl.value = 'http://inspectors.cloud/FovVnVmnqyiiJEkChGYuakr1WHkt';
    // cardBackUrl.value = 'http://inspectors.cloud/FovVnVmnqyiiJEkChGYuakr1WHkt';
    if (!cardFrontUrl.value.isURL || !cardBackUrl.value.isURL) {
      return;
    }

    enable.value = true;
  }

  void fetchApply() async {
    validInfo();
    if (!enable.value) {
      showToast(LocaleKeys.apply_next_tip.tr);
      return;
    }

    provider
        .apply(
      values[0],
      values[1],
      values[2],
      province.value,
      city.value,
      area.value,
      values[5],
      values[3],
      values[6],
      cardFrontUrl.value,
      cardBackUrl.value,
      content.value,
      accountType.value,
      shebao.value,
    )
        .then((value) {
      if (value.isSuccess) {
        Get.back(result: true);
      }
      showToast(value.message ?? '');
    });
  }

  Future<bool> fetchAuthCard(bool front, String url) async {
    String type = front ? 'front' : 'back';
    final result = await provider.authIDCard(url, type);
    if (result.isSuccess) {
      final card = result.data['id_card_number'] as String?;
      if (front && card != null) {
        editingController2.text = card;
        values.value[6] = card;
      }
      if ((card == null || card.isEmpty) && front) {
        showToast(LocaleKeys.apply_auth_failed.tr);
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    } else {
      showToast(result.message ?? '');
      return Future.value(false);
    }
  }

  void fetchApplyInfo() {
    EasyLoading.show();
    provider.applyInfo().then((value) {
      if (value.isSuccess) {
        province.value = value.data?.province ?? '';
        city.value = value.data?.city ?? '';
        area.value = value.data?.area ?? '';
        values[4] = '${province.value}${city.value}${area.value}';
        values[5] = value.data?.price ?? '';
        values[3] = value.data?.education ?? '';
        values[6] = value.data?.idCardNum ?? '';
        cardFrontUrl.value = value.data?.idCardFront ?? '';
        cardBackUrl.value = value.data?.idCardBack ?? '';
        content.value = value.data?.content ?? '';
        accountType.value = value.data?.accountType ?? 1;
        shebao.value = value.data?.socialSecurity ?? false;
        editingController.text = content.value;
        editingController1.text = value.data?.price ?? '';
        editingController2.text = value.data?.idCardNum ?? '';
      } else {
        showToast(value.message ?? '');
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void uploadResume(bool isPic) {
    FilesPicker.openFile().then((value) {
      if (value == null || value.isEmpty) {
        return;
      }
      EasyLoading.show();
      PublicProvider.uploadImages(value, UploadType.resume).then((url) {
        if (url == null || url.isEmpty) {
          showToast(LocaleKeys.apply_upload_file_failed.tr);
        }
        var resumeInfo = ResumeInfo();
        resumeInfo.resumeUrl = url!;
        resumeInfo.type = isPic ? ResumeType.pic : ResumeType.doc;
        resumes.add(resumeInfo);
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    });
  }

  void deleteResume(int position) {
    resumes.removeAt(position);
  }

  void uploadIdCardImage(bool front, {int cropWidth = 1, int cropHeight = 1}) {
    FilesPicker.openImage(false, cropWidth: cropWidth, cropHeight: cropHeight)
        .then((value) {
      if (value == null || value.isEmpty) {
        return;
      }
      dataState(front, value);
      PublicProvider.uploadImages(value, UploadType.iden).then((url) async {
        if (url == null || value.isEmpty) {
          showToast(LocaleKeys.profile_info_failed.tr);
          dataState(front, '');
          return;
        }
        final tempUrl = url;
        if (front) {
          fetchAuthCard(front, tempUrl).then((result) {
            if (result) {
              dataState(front, tempUrl);
            } else {
              dataState(front, '');
            }
          });
        } else {
          dataState(front, tempUrl);
        }
      });
    });
  }

  @override
  void onClose() {}

  @override
  void dispose() {
    editingController.dispose();
    editingController1.dispose();
    editingController2.dispose();

    super.dispose();
  }
}

class ResumeInfo {
  String resumeUrl = '';
  String resumeTitle = '';
  ResumeType type = ResumeType.pic;
}

enum ResumeType { pic, doc }
