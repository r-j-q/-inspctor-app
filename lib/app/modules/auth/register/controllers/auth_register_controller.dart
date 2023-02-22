import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/data/user_info_entity.dart';
import 'package:inspector/app/modules/auth/mine_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

enum BindPageType { register, reset, bindEmail, bindMobile }

class AuthRegisterController extends GetxController {
  MineProvider provider = MineProvider();
  //controller
  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController passController = TextEditingController();
  //state
  RxBool codeEnable = false.obs;
  RxBool buttonEnable = false.obs;
  //data
  RxString email = ''.obs;
  RxString code = ''.obs;
  RxString password = ''.obs;
  RxInt time = 61.obs;
  Timer? _timer;
  final isSee = true.obs;
  final isCheck = false.obs;
  var pageType = BindPageType.register;

  @override
  void onInit() {
    super.onInit();

    pageType = Get.arguments;
  }

  void takeCode() {
    Get.showOverlay(
        asyncFunction: () => Future.value(), loadingWidget: loadingWidget);
    if (!GetUtils.isEmail(email.value) &&
        !GetUtils.isPhoneNumber(email.value)) {
      showToast(LocaleKeys.registry_email_phone_tips.tr);
      return;
    }
    if (time.value != 61) {
      return;
    }
    _timer?.cancel();
    _timer = null;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (time.value == 0) {
        _timer?.cancel();
        _timer = null;
        time.value = 61;
        return;
      }
      time.value = time.value - 1;
    });
    provider.takeCode(true, email.value, null).then((value) {
      if (!value.isSuccess) {
        _timer?.cancel();
        _timer = null;
        time.value = 61;
      }
      showToast(value.message ?? '');
    });
  }

  void registerAction() {
    if (!GetUtils.isEmail(email.value) &&
        !GetUtils.isPhoneNumber(email.value)) {
      showToast(LocaleKeys.registry_email_phone_tips.tr);
      return;
    }

    if (password.value.isEmpty) {
      showToast(LocaleKeys.login_password_tips.tr);
      return;
    }

    if (code.value.isEmpty) {
      showToast(LocaleKeys.login_verify_tips.tr);
      return;
    }

    EasyLoading.show();
    provider
        .register<UserInfoEntity>(email.value, password.value, code.value)
        .then((value) async {
      if (value.isSuccess) {
        Get.back();
      }
      showToast(value.message ?? '');
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void bindAction() {
    if (!GetUtils.isEmail(email.value) &&
        !GetUtils.isPhoneNumber(email.value)) {
      showToast(LocaleKeys.registry_email_phone_tips.tr);
      return;
    }

    if (code.value.isEmpty) {
      showToast(LocaleKeys.login_verify_tips.tr);
      return;
    }
    EasyLoading.show();
    provider.bindMobile(email.value, '0', code.value).then((value) async {
      if (value.isSuccess) {
        Get.back();
      }
      showToast(value.message ?? '');
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void resetPassAction() {
    if (!GetUtils.isEmail(email.value) &&
        !GetUtils.isPhoneNumber(email.value)) {
      showToast(LocaleKeys.registry_email_phone_tips.tr);
      return;
    }

    if (password.value.isEmpty) {
      showToast(LocaleKeys.login_password_tips.tr);
      return;
    }

    if (code.value.isEmpty) {
      showToast(LocaleKeys.login_verify_tips.tr);
      return;
    }

    EasyLoading.show();
    provider
        .resetPassword(email.value, password.value, code.value)
        .then((value) async {
      if (value.isSuccess) {
        Get.back();
      }
      showToast(value.message ?? '');
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  @override
  void onClose() {}
}
