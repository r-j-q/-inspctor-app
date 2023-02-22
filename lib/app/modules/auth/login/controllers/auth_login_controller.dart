import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/constant.dart';
import 'package:inspector/app/data/area_list_entity.dart';
import 'package:inspector/app/data/user_info_entity.dart';
import 'package:inspector/app/modules/auth/mine_provider.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

enum LoginType { code, password }

enum AccountType { email, mobile }

class AuthLoginController extends GetxController {
  MineProvider provider = MineProvider();
  //controller
  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  //state
  var loginType = LoginType.password.obs;
  var accountType = AccountType.email.obs;
  RxInt areaCode = 86.obs;
  var areaList = <AreaListEntity>[].obs;
  var areaCopyList = <AreaListEntity>[];

  RxBool codeEnable = false.obs;
  RxBool loginEnable = false.obs;
  //data
  var email = ''.obs;
  var mobile = ''.obs;
  var code = ''.obs;
  var password = ''.obs;
  RxInt time = 61.obs;
  Timer? _timer;
  //类型 1 ：fb 2：ins 3：google 4： apple
  int thirdType = 1;
  final isSee = true.obs;
  final isCheck = true.obs;
  int isNext = 0;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    email.value =
        GlobalConst.sharedPreferences?.getString(Constant.username) ?? '';
    password.value =
        GlobalConst.sharedPreferences?.getString(Constant.password) ?? '';
    emailController.text = email.value;
    codeController.text = password.value;

    email.subject.listen((element) => validInfo());
    code.subject.listen((element) => validInfo());
    password.subject.listen((element) => validInfo());
  }

  void validInfo() {
    if (!email.value.isEmail) {
      codeEnable.value = false;
      loginEnable.value = false;
      return;
    }
    codeEnable.value = true;

    if (code.value.length != 4 && loginType.value == LoginType.code) {
      loginEnable.value = false;
      return;
    }

    if (password.value.length < 8 && loginType.value == LoginType.password) {
      loginEnable.value = false;
      return;
    }

    loginEnable.value = true;
  }

  void takeCode() {
    bool isEmail = accountType.value == AccountType.email;

    Get.showOverlay(
      asyncFunction: () => Future.value(),
      loadingWidget: loadingWidget,
    );
    if (!GetUtils.isEmail(email.value) && isEmail) {
      showToast(LocaleKeys.login_email_tips.tr);
      return;
    }
    if (mobile.value.isEmpty && !isEmail) {
      showToast(LocaleKeys.login_mobile_tips.tr);
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
    provider
        .takeCode(isEmail, isEmail ? email.value : mobile.value, areaCode.value)
        .then((value) {
      if (!value.isSuccess) {
        _timer?.cancel();
        _timer = null;
        time.value = 61;
      }
      showToast(value.message ?? '');
    });
  }

  void loginEmail() {
    bool isEmail = accountType.value == AccountType.email;
    bool isCode = loginType.value == LoginType.code;

    if (!GetUtils.isEmail(email.value) && isEmail) {
      showToast(LocaleKeys.login_email_tips.tr);
      return;
    }

    if (mobile.value.isEmpty && !isEmail) {
      showToast(LocaleKeys.login_mobile_tips.tr);
      return;
    }

    if (loginType.value == LoginType.code && code.value.isEmpty) {
      showToast(LocaleKeys.login_verify_tips.tr);
      return;
    }

    if (loginType.value == LoginType.password && password.value.isEmpty) {
      showToast(LocaleKeys.login_password_tips.tr);
      return;
    }
    EasyLoading.show();
    //mydev
    if (!isCode && !isEmail) {
      code.value = password.value + "_passwod";
    }
    provider
        .loginAccount(
            isEmail ? email.value : mobile.value,
            (!isCode && isEmail) ? password.value : code.value,
            areaCode.value,
            isEmail)
        .then((value) async {
      if (value.isSuccess) {
        // print("======value.data=====");
        //print(value.data);
        await GlobalConst.saveUser(value.data!);
        fetchUserInfo();
        AppPages.INITIAL();
        if (loginType.value == LoginType.password) {
          GlobalConst.sharedPreferences
              ?.setString(Constant.username, email.value);
          GlobalConst.sharedPreferences
              ?.setString(Constant.password, password.value);
        }
      } else {
        showToast(value.message ?? '');
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void fetchUserInfo() {
    provider.takeMineInfo().then((value) async {
      if (value.isSuccess) {
        UserInfoEntity infoEntity = UserInfoEntity();
        infoEntity = value.data ?? UserInfoEntity();
        infoEntity.token = GlobalConst.userModel?.token;
        infoEntity.isYanHuoYuan = value.data?.isYanHuoYuan ?? false;
        //mydev
        // print(GlobalConst.userModel);
        infoEntity.im_token = GlobalConst.userModel?.im_token;
        GlobalConst.tempModel = null;
        await GlobalConst.saveUser(infoEntity);
      } else {
        showToast(value.message ?? '');
      }
    });
  }

  void fetchAreaList() {
    EasyLoading.show();
    provider.areaList().then((value) async {
      if (value.isSuccess) {
        areaList.value = value.data ?? [];
        areaCopyList = List.from(areaList);
      } else {
        showToast(value.message ?? '');
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void searchWords() {
    final text = searchController.text.trim();
    if (text.isEmpty) {
      areaList.value = areaCopyList;
      return;
    }
    List<AreaListEntity> temp = List.from(areaCopyList);
    temp.retainWhere((element) => element.name.contains(text));
    areaList.value = temp;
  }

  @override
  void onClose() {}

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
