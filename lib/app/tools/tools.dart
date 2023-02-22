import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:inspector/app/config/api.dart';
import 'package:inspector/app/config/constant.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/data/location_entity.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/public_provider.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';
import 'package:inspector/generated/locales.g.dart';
import 'package:logger/logger.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 2,
    textColor: Colors.white,
    backgroundColor: MColor.xFFE95332,
  );
}

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

var loadingWidget = SpinKitCircle(
  color: Colors.white,
  size: 20.0,
);

// 节流函数
const deFaultDurationTime = 1000;
Timer? timer;

const String deFaultThrottleId = 'DeFaultThrottleId';
Map<String, int> startTimeMap = {deFaultThrottleId: 0};
throttle(Function doSomething,
    {String throttleId = deFaultThrottleId,
    durationTime = deFaultDurationTime}) {
  int currentTime = DateTime.now().millisecondsSinceEpoch;
  if (currentTime - (startTimeMap[throttleId] ?? 0) > durationTime) {
    doSomething.call();
    startTimeMap[throttleId] = DateTime.now().millisecondsSinceEpoch;
  }
}

mzdebounce(Function doSomething, {durationTime = deFaultDurationTime}) {
  timer?.cancel();
  timer = Timer(Duration(milliseconds: durationTime), () {
    doSomething.call();
    timer = null;
  });
}

class PrecisionLimitFormatter extends TextInputFormatter {
  final int _scale;

  PrecisionLimitFormatter(this._scale);

  RegExp exp = RegExp("[0-9.]");
  static const String POINTER = ".";
  static const String DOUBLE_ZERO = "00";

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.startsWith(POINTER) && newValue.text.length == 1) {
      //第一个不能输入小数点
      return oldValue;
    }

    ///输入完全删除
    if (newValue.text.isEmpty) {
      return TextEditingValue();
    }

    ///只允许输入小数
    if (!exp.hasMatch(newValue.text)) {
      return oldValue;
    }

    ///包含小数点的情况
    if (newValue.text.contains(POINTER)) {
      ///包含多个小数
      if (newValue.text.indexOf(POINTER) !=
          newValue.text.lastIndexOf(POINTER)) {
        return oldValue;
      }
      String input = newValue.text;
      int index = input.indexOf(POINTER);

      ///小数点后位数
      int lengthAfterPointer = input.substring(index, input.length).length - 1;

      ///小数位大于精度
      if (lengthAfterPointer > _scale) {
        return oldValue;
      }
    } else if (newValue.text.startsWith(POINTER) ||
        newValue.text.startsWith(DOUBLE_ZERO)) {
      ///不包含小数点,不能以“00”开头
      return oldValue;
    }
    return newValue;
  }
}

Widget _textField(
    TextEditingController controller, String placeHolder, TextInputType? type) {
  return TextField(
    controller: controller,
    style: MFont.regular15.apply(color: MColor.xFF565656),
    textAlign: TextAlign.center,
    keyboardType: type,
    decoration: InputDecoration(
      hintText: placeHolder,
      hintStyle: MFont.regular15.apply(color: MColor.xFF9A9B9C),
      filled: true,
      isDense: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      constraints: BoxConstraints(maxHeight: 40, minHeight: 35),
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderSide: BorderSide(color: MColor.xFFA4A5A9_80)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MColor.xFFA4A5A9_80)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MColor.xFFA4A5A9_80)),
    ),
  );
}

showCustomDialog(String text,
    {VoidCallback? onConfirm,
    TextEditingController? textController,
    TextInputType? textInputType,
    String? textPlaceHolder,
    bool cancel = false,
    bool dismissWhenConfirm = true,
    String? okTitle,
    VoidCallback? onCancel}) {
  if (Get.isDialogOpen ?? false) {
    return;
  }
  Get.generalDialog(
      barrierDismissible: false,
      pageBuilder: (ctx, a, s) {
        return WillPopScope(
            onWillPop: () async => false,
            child: CupertinoAlertDialog(
              content: Column(
                children: [
                  Text(
                    text,
                    style: MFont.semi_Bold17.apply(color: MColor.xFF333333),
                  ),
                  if (textController != null) ...{
                    SizedBox(height: 20),
                    _textField(
                        textController, textPlaceHolder ?? '', textInputType),
                  },
                ],
              ),
              actions: <Widget>[
                if (cancel) ...{
                  TextButton(
                    onPressed: () {
                      Get.back();
                      if (onCancel != null) {
                        onCancel();
                      }
                    },
                    child: Text(
                      LocaleKeys.public_cancel.tr,
                      style: MFont.regular17.apply(color: MColor.xFF333333),
                    ),
                  ),
                },
                TextButton(
                  onPressed: () {
                    if (dismissWhenConfirm) {
                      Get.back();
                    }
                    if (onConfirm != null) {
                      onConfirm();
                    }
                  },
                  child: Text(
                    okTitle ?? LocaleKeys.public_ok.tr,
                    style: MFont.semi_Bold17.apply(color: MColor.xFF333333),
                  ),
                ),
              ],
            ));
      });
}

extension Ratio on double {
  double get pixRatio {
    return this * (Get.width / 375.0);
  }
}

class FilesPicker {
  static Future<String?> openCamera() async {
    try {
      final XFile? file = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 100,
      );
      if (file != null && file.path != null) {
        final name = file.path;
        if (name.contains('.png') ||
            name.contains('.jpg') ||
            name.contains('.jpeg')) {
          return name;
        } else {
          showToast('图片格式需为png,jpg,jpeg');
        }
      }
    } catch (error) {
      logger.e('open camera ${error.toString()}');
      return null;
    }
  }

  static Future<String?> openImage(bool isCamera,
      {enableCrop = true, int cropHeight = 1, int cropWidth = 1}) async {
    try {
      final files = await ImagePickers.pickerPaths(
        uiConfig: UIConfig(uiThemeColor: MColor.xFF333333),
        showCamera: true,
        showGif: false,
        cropConfig: CropConfig(
            enableCrop: enableCrop, height: cropHeight, width: cropWidth),
      );

      // final file = await ImagePicker().pickImage(
      //   source: isCamera ? ImageSource.camera : ImageSource.gallery,
      //   maxWidth: 800,
      //   maxHeight: 800,
      //   imageQuality: 100,
      // );
      if (files.first.path != null) {
        final name = files.first.path ?? '';
        if (name.contains('.png') ||
            name.contains('.jpg') ||
            name.contains('.jpeg')) {
          return files.first.path;
        } else {
          showToast('图片格式需为png,jpg,jpeg');
        }
      }
      return null;
    } catch (error) {
      logger.e('open image ${error.toString()}');
      return null;
    }
  }

  static showSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        height: 100,
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (ctx, index) {
            if (index == 2) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      '取消',
                      style: MFont.semi_Bold17.apply(color: MColor.xFF333333),
                    ),
                  ),
                ),
              );
            }

            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Get.back();
                // if (index == 0) {
                //   ImagePickers.openCamera().then((value) {});
                // } else {
                //   ImagePickers.pickerPaths().then((value) {});
                // }
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: MColor.xFFEEEEEE, width: 1)),
                ),
                child: Center(
                  child: Text(
                    index == 0 ? '相机' : '相册',
                    style: MFont.semi_Bold15.apply(color: MColor.xFF333333),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Future<String?> openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      return result.files.single.path;
    } else {
      logger.e('open file error');
      return null;
    }
  }
}

/// 防止文字自动换行
extension FixAutoLines on String {
  String fixAutoLines() {
    return Characters(this).join('\u{200B}');
  }

  String get mdx5 {
    Uint8List content = Utf8Encoder().convert(this);
    Digest digest = md5.convert(content);

    return digest.toString();
  }
}

class Location {
  static Location share = Location();
  Map<String, Object>? locationResult;

  final AMapFlutterLocation _locationPlugin = AMapFlutterLocation();

  Location() {
    AMapFlutterLocation.updatePrivacyShow(true, true);
    AMapFlutterLocation.updatePrivacyAgree(true);
    AMapFlutterLocation.setApiKey(
        "64080bc33073443beeb7cc0b05876066", "c06335b2174317ca49eddaaae6e09818");

    ///注册定位结果监听
    _locationPlugin.onLocationChanged().listen((Map<String, Object> result) {
      locationResult = result;
      final lat = double.tryParse('${result['latitude'] ?? '0'}') ?? 0;
      //精度
      final lon = double.tryParse('${result['longitude'] ?? '0'}') ?? 0;

      GlobalConst.sharedPreferences?.setDouble(Constant.lat, lat);
      GlobalConst.sharedPreferences?.setDouble(Constant.lon, lon);
      PublicProvider.userGps(lat, lon);
      stopLocation();
    });
  }
  void showAlert() {
    AMapFlutterLocation.updatePrivacyShow(true, true);
    AMapFlutterLocation.updatePrivacyAgree(true);

    requestPermission();

    ///iOS 获取native精度类型
    if (Platform.isIOS) {
      requestAccuracyAuthorization();
    }
  }

  ///设置定位参数
  void _setLocationOption() {
    AMapLocationOption locationOption = AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = false;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;

    locationOption.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = 2000;

    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Hight_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    /// 可选值：<br>
    /// <li>[DesiredAccuracy.Best] 最高精度</li>
    /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
    locationOption.desiredAccuracy = DesiredAccuracy.Best;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }

  ///开始定位
  void startLocation() {
    AMapFlutterLocation.updatePrivacyShow(true, true);
    AMapFlutterLocation.updatePrivacyAgree(true);

    _setLocationOption();

    _locationPlugin.startLocation();
  }

  void startLocationByGeoLocator() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position postion) {
      GlobalConst.sharedPreferences?.setDouble(Constant.lat, postion.latitude);
      GlobalConst.sharedPreferences?.setDouble(Constant.lon, postion.longitude);
    });
  }

  ///停止定位
  void stopLocation() {
    _locationPlugin.stopLocation();
  }

  void requestAccuracyAuthorization() async {
    AMapAccuracyAuthorization currentAccuracyAuthorization =
        await _locationPlugin.getSystemAccuracyAuthorization();
    if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
      print("精确定位类型");
    } else if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
      print("模糊定位类型");
    } else {
      print("未知定位类型");
    }
  }

  /// 动态申请定位权限
  void requestPermission() async {
    // 申请权限
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
      startLocation();
      print("定位权限申请通过");
    } else {
      showCustomDialog(LocaleKeys.location_permission.tr, onConfirm: () {
        openAppSettings();
      }, cancel: true);
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return true;
    } else {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        return true;
      } else {
        return false;
      }
    }
    // //获取当前的权限
    // var status = await Permission.locationWhenInUse.status;
    // var status1 = await Permission.locationAlways.status;
    // var status2 = await Permission.location.status;

    // if (status == PermissionStatus.granted ||
    //     status1 == PermissionStatus.granted ||
    //     status2 == PermissionStatus.granted) {
    //   //已经授权
    //   startLocation();
    //   return true;
    // } else {
    //   //未授权则发起一次申请

    //   status = await Permission.locationWhenInUse.request();
    //   if (status == PermissionStatus.granted) {
    //     startLocation();
    //     return true;
    //   } else {
    //     return false;
    //   }
    // }
  }

  Future<LocationEntity> fetchLocation(String address) async {
    final url = Api.gdLat + '&address=$address';
    final resp = await PublicProvider.oriRequest(path: url, isPost: false);
    final result = JsonConvert.fromJsonAsT<LocationEntity>(resp);

    return Future.value(result);
  }

  void toNavigation(double? lat, double? lon, String? address) async {
    if (lat == null || lon == null || address == null) {
      return;
    }
    if (lat <= 0 || lon <= 0) {
      return;
    }
    // lat = 30.239;
    // lon = 120.445;
    // address = "杭州萧山国际机场";
    final availableMaps = await MapLauncher.installedMaps;
    if (availableMaps.isEmpty) {
      showToast('您未安装地图');
      return;
    }
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        height: 60 +
            (62.0 * availableMaps.length > 200
                ? 260
                : (62.0 * availableMaps.length)),
        child: ListView.builder(
          itemCount: availableMaps.length + 1,
          itemBuilder: (ctx, index) {
            if (index == availableMaps.length) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      '取消',
                      style: MFont.semi_Bold17.apply(color: MColor.xFF333333),
                    ),
                  ),
                ),
              );
            }
            final map = availableMaps[index];
            var name = '';
            if (map.mapType == MapType.apple) {
              name = '苹果地图';
            } else if (map.mapType == MapType.amap) {
              name = '高德地图';
            } else if (map.mapType == MapType.baidu) {
              name = '百度地图';
            } else if (map.mapType == MapType.google) {
              name = 'google地图';
            } else if (map.mapType == MapType.googleGo) {
              name = 'google地图';
            } else if (map.mapType == MapType.tencent) {
              name = '腾讯地图';
            }
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Get.back();
                map.showDirections(
                    destination: Coords(lat, lon), destinationTitle: address);
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: MColor.xFFEEEEEE, width: 1)),
                ),
                child: Center(
                  child: Text(
                    name,
                    style: MFont.semi_Bold15.apply(color: MColor.xFF333333),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
