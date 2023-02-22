import 'dart:convert';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:inspector/app/config/constant.dart';
import 'package:inspector/app/data/user_info_entity.dart';
import 'package:inspector/app/tools/device.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalConst {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  static PackageInfo? packageInfo;
  static final Connectivity connectivity = Connectivity();
  static SharedPreferences? sharedPreferences;

  static Future<bool> asyns() async {
    sharedPreferences = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();

    DeviceUtils.init();
    return Future.value(true);
  }

  static double screenWidth =
      window.physicalSize.width / window.devicePixelRatio;
  static double screenHeight =
      window.physicalSize.height / window.devicePixelRatio;
  static UserInfoEntity? tempModel;
  static UserInfoEntity? get userModel {
    if (tempModel == null) {
      final jsonStr = sharedPreferences?.getString(Constant.kUser);
      if (jsonStr == null) {
        return null;
      }
      final map = json.decode(jsonStr);
      final model = JsonConvert.fromJsonAsT<UserInfoEntity>(map);
      tempModel = model;
    }

    return tempModel;
  }

  static saveUser(UserInfoEntity entity) async {
    String info = json.encode(entity.toJson());
    // print("====info=====info=====");
//print(info);
    //print("====kUser=====kUser=====");
    // print(Constant.kUser);
    await GlobalConst.sharedPreferences?.setString(Constant.kUser, info);
  }
}
