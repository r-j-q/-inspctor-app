import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/constant.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/cachUtils.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';
import 'package:path_provider/path_provider.dart';

class SettingController extends GetxController {
  //缓存文件大小
  final appCacheSize = "0.0MB".obs;

  //接收消息的开关
  var receiveMsgSwitch = true;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    receiveMsgSwitch = GlobalConst.sharedPreferences?.getBool(Constant.receiveMsg) ?? true;
    getCachSize();
  }

  var _tempDir;
  //获取缓存大小
  void getCachSize() async {
    _tempDir ??= await getTemporaryDirectory();
    num _cache = await getTotalSizeOfFilesInDir(_tempDir);
    appCacheSize.value = renderSize(_cache);
  }

  void clearCacheSize() async {
    EasyLoading.show();
    await requestPermission(_tempDir ?? await getTemporaryDirectory());
    final file = await getTemporaryDirectory();
    await _delete(file).catchError((e) {});
    EasyLoading.dismiss();
    showToast(LocaleKeys.setting_clear_success.tr);
    getCachSize();
  }

  /// 递归删除缓存目录和文件
  Future<void> _delete(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await _delete(child);
      }
    } else {
      await file.delete();
    }
  }

//修改开关状态
  void selectReceiveMsgSwitch() async {
    receiveMsgSwitch = !receiveMsgSwitch;
    await GlobalConst.sharedPreferences?.setBool(Constant.receiveMsg, receiveMsgSwitch);
    update();
  }

//t退出登录
  void loginout() {
    GlobalConst.tempModel = null;
    GlobalConst.sharedPreferences?.remove(Constant.kUser);
    Get.offAllNamed(Routes.AUTH_LOGIN);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
