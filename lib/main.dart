import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:inspector/app/config/api.dart';
import 'package:inspector/app/config/constant.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/modules/init/views/update_view.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/device.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/public_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';
// import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? initial;
  await GlobalConst.asyns();

  ThemeData themeData = ThemeData(
    appBarTheme: AppBarTheme(
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: MColor.xFF000000,
      ),
      titleTextStyle: MFont.medium18.apply(color: MColor.xFF333333),
      toolbarHeight: 44,
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  GlobalConst.sharedPreferences?.setBool(Constant.kStart, true);
  initial = await AppPages.INITIAL(true);
  // JmessageFlutter().init;

  final language =
      GlobalConst.sharedPreferences?.getInt(Constant.kLanguage) ?? 1;
  var local = Locale('en', 'US');
  if (language == 3) {
    local = Locale('de', 'DE');
  } else if (language == 2) {
    local = Locale('fr', 'FR');
  } else if (language == 1) {
    local = Locale('zh', 'CN');
  }

  runApp(
    RefreshConfiguration(
      enableLoadingWhenNoData: true,
      enableLoadingWhenFailed: true,
      hideFooterWhenNotFull: true,
      headerBuilder: () {
        return ClassicHeader(
          refreshStyle: RefreshStyle.Follow,
          textStyle: MFont.regular15.apply(color: MColor.skin),
          refreshingIcon: loadingWidget,
          failedIcon: Icon(Icons.error, color: MColor.skin),
          completeIcon: Icon(Icons.done, color: MColor.skin),
          idleIcon: Icon(Icons.arrow_downward, color: MColor.skin),
          releaseIcon: Icon(Icons.refresh, color: MColor.skin),
        );
      },
      footerBuilder: () {
        return ClassicFooter(
          textStyle: MFont.regular15.apply(color: MColor.skin),
          loadStyle: LoadStyle.ShowWhenLoading,
          failedIcon: Icon(Icons.error, color: MColor.skin),
          loadingIcon: SpinKitCircle(
            color: MColor.skin,
            size: 20.0,
          ),
          canLoadingIcon: Icon(Icons.autorenew, color: MColor.skin),
          idleIcon: Icon(Icons.arrow_upward, color: MColor.skin),
        );
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translationsKeys: AppTranslation.translations,
        title: 'Inspector',
        locale: local,
        fallbackLocale: Locale('en', 'US'),
        theme: themeData,
        initialRoute: initial,
        getPages: AppPages.routes,
        builder: EasyLoading.init(),
      ),
    ),
  );

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 30.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = MColor.skin.withAlpha(50)
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.transparent
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = true
    ..dismissOnTap = false;

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  alertUpdate();
}

void alertUpdate() {
  PublicProvider.request(
    path: Api.updateApp,
    params: {
      'appVersion': DeviceUtils.version ?? '1.0.0',
      'osVersion': Platform.isAndroid ? 'android' : 'ios'
    },
    isPost: false,
  ).then((value) {
    if (value.isSuccess) {
      final appVersion = value.data['version'];

      final isNewest = haveNewVersion(appVersion, DeviceUtils.version ?? '0');
      if (isNewest) {
        Get.dialog(UpdateAppView(value.data));
      }
    }
  });
}

bool haveNewVersion(String newVersion, String old) {
  if (newVersion.isEmpty || old.isEmpty) {
    return false;
  }
  int newVersionInt, oldVersion;
  var newList = newVersion.split('.');
  var oldList = old.split('.');
  if (newList.isEmpty || oldList.isEmpty) {
    return false;
  }
  for (int i = 0; i < newList.length; i++) {
    newVersionInt = int.parse(newList[i]);
    oldVersion = int.parse(oldList[i]);
    if (newVersionInt > oldVersion) {
      return true;
    } else if (newVersionInt < oldVersion) {
      return false;
    }
  }

  return false;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, Object>? _locationResult;

  StreamSubscription<Map<String, Object>>? _locationListener;

  AMapFlutterLocation _locationPlugin = AMapFlutterLocation();

  @override
  void initState() {
    super.initState();

    /// 设置是否已经包含高德隐私政策并弹窗展示显示用户查看，如果未包含或者没有弹窗展示，高德定位SDK将不会工作
    ///
    /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
    /// <b>必须保证在调用定位功能之前调用， 建议首次启动App时弹出《隐私政策》并取得用户同意</b>
    ///
    /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
    ///
    /// [hasContains] 隐私声明中是否包含高德隐私政策说明
    ///
    /// [hasShow] 隐私权政策是否弹窗展示告知用户
    AMapFlutterLocation.updatePrivacyShow(true, true);

    /// 设置是否已经取得用户同意，如果未取得用户同意，高德定位SDK将不会工作
    ///
    /// 高德SDK合规使用方案请参考官网地址：https://lbs.amap.com/news/sdkhgsy
    ///
    /// <b>必须保证在调用定位功能之前调用, 建议首次启动App时弹出《隐私政策》并取得用户同意</b>
    ///
    /// [hasAgree] 隐私权政策是否已经取得用户同意
    AMapFlutterLocation.updatePrivacyAgree(true);

    /// 动态申请定位权限
    requestPermission();

    ///设置Android和iOS的apiKey<br>
    ///
    /// 定位Flutter插件提供了单独的设置ApiKey的接口，
    /// 使用接口的优先级高于通过Native配置ApiKey的优先级（通过Api接口配置后，通过Native配置文件设置的key将不生效），
    /// 使用时可根据实际情况决定使用哪种方式
    ///
    ///key的申请请参考高德开放平台官网说明<br>
    ///
    ///Android: https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key
    ///
    ///iOS: https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key
    // AMapFlutterLocation.setApiKey(
    //     "anroid ApiKey", "ios ApiKey");

    ///iOS 获取native精度类型
    if (Platform.isIOS) {
      requestAccuracyAuthorization();
    }

    ///注册定位结果监听
    _locationListener = _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      setState(() {
        _locationResult = result;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    ///移除定位监听
    if (null != _locationListener) {
      _locationListener?.cancel();
    }

    ///销毁定位
    if (null != _locationPlugin) {
      _locationPlugin.destroy();
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
  void _startLocation() {
    if (null != _locationPlugin) {
      ///开始定位之前设置定位参数
      _setLocationOption();
      _locationPlugin.startLocation();
    }
  }

  ///停止定位
  void _stopLocation() {
    if (null != _locationPlugin) {
      _locationPlugin.stopLocation();
    }
  }

  Container _createButtonContainer() {
    return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _startLocation,
              child: Text('开始定位'),
              style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(color: Colors.white),
                  backgroundColor: Colors.blue),
            ),
            Container(width: 20.0),
            ElevatedButton(
                onPressed: _stopLocation,
                child: new Text('停止定位'),
                style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(color: Colors.white),
                    backgroundColor: Colors.blue))
          ],
        ));
  }

  Widget _resultWidget(key, value) {
    return new Container(
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            alignment: Alignment.centerRight,
            width: 100.0,
            child: new Text('$key :'),
          ),
          new Container(width: 5.0),
          new Flexible(child: new Text('$value', softWrap: true)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(_createButtonContainer());

    _locationResult?.forEach((key, value) {
      widgets.add(_resultWidget(key, value));
    });

    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        title: new Text('AMap Location plugin example app'),
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: widgets,
      ),
    ));
  }

  ///获取iOS native的accuracyAuthorization类型
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
      print("定位权限申请通过");
    } else {
      print("定位权限申请不通过");
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
