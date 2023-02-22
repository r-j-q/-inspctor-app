import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/tools.dart';

class DeviceUtils {
  //设备类型 如 vivo X9
  static String? deviceName;
  //设备系统版本 10.0
  static String? sysVersion;
  //设备类型 ios/android
  static String? osType;
  //设备ID
  static String? deviceId;
  //网络类型
  static String? netType;
  //Wi-Fi名称
  static String? wifiName;
  //应用版本 1.0.0
  static String? version;

  static init() async {
    late ConnectivityResult result;
    try {
      result = await GlobalConst.connectivity.checkConnectivity();
      GlobalConst.connectivity.onConnectivityChanged.listen((event) {
        switch (event) {
          case ConnectivityResult.wifi:
            netType = 'wifi';
            break;
          case ConnectivityResult.ethernet:
            netType = 'ethernet';
            break;
          case ConnectivityResult.mobile:
            netType = 'cellular';
            break;
        }
      });
    } on PlatformException catch (e) {
      logger.v(e.toString());
    }

    version = GlobalConst.packageInfo?.version;
    if (Platform.isAndroid) {
      final androidInfo = await GlobalConst.deviceInfoPlugin.androidInfo;

      osType = 'android';
      deviceName = androidInfo.model;
      sysVersion = androidInfo.version.release;
      deviceId = androidInfo.androidId;
    } else {
      final ios = await GlobalConst.deviceInfoPlugin.iosInfo;

      osType = 'ios';
      deviceName = ios.name;
      sysVersion = ios.systemVersion;
      deviceId = ios.identifierForVendor;
    }
    if (deviceName != null) {
      deviceName = Uri.encodeComponent(deviceName!);
    }
  }

  ///获取设备名称
  static String? _iosDeviceName(String? machine) {
    if (machine == null) {
      return "";
    }
    if (machine == "iPhone3,1") return "iPhone 4";
    if (machine == "iPhone3,2") return "iPhone 4";
    if (machine == "iPhone3,3") return "iPhone 4";
    if (machine == "iPhone4,1") return "iPhone 4S";
    if (machine == "iPhone5,1") return "iPhone 5";
    if (machine == "iPhone5,2") return "iPhone 5 (GSM+CDMA)";
    if (machine == "iPhone5,3") return "iPhone 5c (GSM)";
    if (machine == "iPhone5,4") return "iPhone 5c (GSM+CDMA)";
    if (machine == "iPhone6,1") return "iPhone 5s (GSM)";
    if (machine == "iPhone6,2") return "iPhone 5s (GSM+CDMA)";
    if (machine == "iPhone7,1") return "iPhone 6 Plus";
    if (machine == "iPhone7,2") return "iPhone 6";
    if (machine == "iPhone8,1") return "iPhone 6s";
    if (machine == "iPhone8,2") return "iPhone 6s Plus";
    if (machine == "iPhone8,4") return "iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if (machine == "iPhone9,1") return "iPhone 7";
    if (machine == "iPhone9,2") return "iPhone 7 Plus";
    if (machine == "iPhone9,3") return "iPhone 7";
    if (machine == "iPhone9,4") return "iPhone 7 Plus";
    if (machine == "iPhone10,1") return "iPhone 8";
    if (machine == "iPhone10,4") return "iPhone 8";
    if (machine == "iPhone10,2") return "iPhone 8 Plus";
    if (machine == "iPhone10,5") return "iPhone 8 Plus";
    if (machine == "iPhone10,3") return "iPhone X";
    if (machine == "iPhone10,6") return "iPhone X";
    if (machine == "iPhone11,8") return "iPhone XR";
    if (machine == "iPhone11,2") return "iPhone XS";
    if (machine == "iPhone11,6") return "iPhone XS Max";
    if (machine == "iPhone11,4") return "iPhone XS Max";
    if (machine == "iPhone12,1") return "iPhone 11";
    if (machine == "iPhone12,3") return "iPhone 11 Pro";
    if (machine == "iPhone12,5") return "iPhone 11 Pro Max";
    if (machine == "iPhone12,8") return "iPhone SE (2nd generation)";
    if (machine == "iPhone13,1") return "iPhone 12 mini";
    if (machine == "iPhone13,2") return "iPhone 12";
    if (machine == "iPhone13,3") return "iPhone 12 Pro";
    if (machine == "iPhone13,4") return "iPhone 12 Pro Max";

    if (machine == "iPhone14,4") return "iPhone 13 mini";
    if (machine == "iPhone14,5") return "iPhone 13";
    if (machine == "iPhone14,2") return "iPhone 13 Pro";
    if (machine == "iPhone14,3") return "iPhone 13 Pro Max";

    if (machine == "iPod1,1") return "iPod Touch 1G";
    if (machine == "iPod2,1") return "iPod Touch 2G";
    if (machine == "iPod3,1") return "iPod Touch 3G";
    if (machine == "iPod4,1") return "iPod Touch 4G";
    if (machine == "iPod5,1") return "iPod Touch (5 Gen)";
    if (machine == "iPod7,1") return "iPod Touch (6 Gen)";
    if (machine == "iPod9,1") return "iPod Touch (7 Gen)";

    if (machine == "iPad1,1") return "iPad";
    if (machine == "iPad1,2") return "iPad 3G";
    if (machine == "iPad2,1") return "iPad 2 (WiFi)";
    if (machine == "iPad2,2") return "iPad 2";
    if (machine == "iPad2,3") return "iPad 2 (CDMA)";
    if (machine == "iPad2,4") return "iPad 2";
    if (machine == "iPad2,5") return "iPad Mini (WiFi)";
    if (machine == "iPad2,6") return "iPad Mini";
    if (machine == "iPad2,7") return "iPad Mini (GSM+CDMA)";
    if (machine == "iPad3,1") return "iPad 3 (WiFi)";
    if (machine == "iPad3,2") return "iPad 3 (GSM+CDMA)";
    if (machine == "iPad3,3") return "iPad 3";
    if (machine == "iPad3,4") return "iPad 4 (WiFi)";
    if (machine == "iPad3,5") return "iPad 4";
    if (machine == "iPad3,6") return "iPad 4 (GSM+CDMA)";
    if (machine == "iPad4,1") return "iPad Air (WiFi)";
    if (machine == "iPad4,2") return "iPad Air (Cellular)";
    if (machine == "iPad4,4") return "iPad Mini 2 (WiFi)";
    if (machine == "iPad4,5") return "iPad Mini 2 (Cellular)";
    if (machine == "iPad4,6") return "iPad Mini 2";
    if (machine == "iPad4,7") return "iPad Mini 3";
    if (machine == "iPad4,8") return "iPad Mini 3";
    if (machine == "iPad4,9") return "iPad Mini 3";
    if (machine == "iPad5,1") return "iPad Mini 4 (WiFi)";
    if (machine == "iPad11,1") return "iPad Mini 5 (5 Gen)";
    if (machine == "iPad11,2") return "iPad Mini 5 (5 Gen)";
    if (machine == "iPad14,1") return "iPad Mini 6 (6 Gen)";
    if (machine == "iPad14,2") return "iPad Mini 6 (6 Gen)";

    if (machine == "iPad5,3") return "iPad Air 2";
    if (machine == "iPad5,4") return "iPad Air 2";
    if (machine == "iPad6,3") return "iPad Pro 9.7";
    if (machine == "iPad6,4") return "iPad Pro 9.7";
    if (machine == "iPad7,1") return "iPad Pro 12.9 (2 Gen)";
    if (machine == "iPad7,2") return "iPad Pro 12.9 (2 Gen)";
    if (machine == "iPad7,3") return "iPad Pro 10.5";
    if (machine == "iPad7,4") return "iPad Pro 10.5";
    if (machine == "iPad8,1") return "iPad Pro 11.0";
    if (machine == "iPad8,2") return "iPad Pro 11.0";
    if (machine == "iPad8,3") return "iPad Pro 11.0";
    if (machine == "iPad8,4") return "iPad Pro 11.0";
    if (machine == "iPad8,5") return "iPad Pro 12.9 (3 Gen)";
    if (machine == "iPad8,6") return "iPad Pro 12.9 (3 Gen)";
    if (machine == "iPad8,7") return "iPad Pro 12.9 (3 Gen)";
    if (machine == "iPad8,8") return "iPad Pro 12.9 (3 Gen)";
    if (machine == "iPad8,9") return "iPad Pro 11.0 (2 Gen)";
    if (machine == "iPad8,10") return "iPad Pro 11.0 (2 Gen)";
    if (machine == "iPad8,11") return "iPad Pro 12.9 (4 Gen)";
    if (machine == "iPad8,12") return "iPad Pro 12.9 (4 Gen)";

    if (machine == "iPad13,4") return "iPad Pro 11.0 (3 Gen)";
    if (machine == "iPad13,5") return "iPad Pro 11.0 (3 Gen)";
    if (machine == "iPad13,6") return "iPad Pro 11.0 (3 Gen)";
    if (machine == "iPad13,7") return "iPad Pro 11.0 (3 Gen)";
    if (machine == "iPad13,8") return "iPad Pro 12.9 (5 Gen)";
    if (machine == "iPad13,9") return "iPad Pro 12.9 (5 Gen)";
    if (machine == "iPad13,10") return "iPad Pro 12.9 (5 Gen)";
    if (machine == "iPad13,11") return "iPad Pro 12.9 (5 Gen)";

    if (machine == "AppleTV2,1") return "Apple TV 2";
    if (machine == "AppleTV3,1") return "Apple TV 3";
    if (machine == "AppleTV3,2") return "Apple TV 3";
    if (machine == "AppleTV5,3") return "Apple TV 4";

    if (machine == "i386") return "Simulator";
    if (machine == "x86_64") return "Simulator";

    return machine;
  }
}
