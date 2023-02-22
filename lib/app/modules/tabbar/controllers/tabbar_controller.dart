import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inspector/app/modules/home/controllers/home_controller.dart';
import 'package:inspector/app/modules/home/controllers/home_list_controller.dart';
import 'package:inspector/app/modules/home/views/supplement_view.dart';
import 'package:inspector/app/modules/message/controllers/message_controller.dart';
import 'package:inspector/app/modules/message/jmessage.dart';
import 'package:inspector/app/modules/mine/controllers/mine_controller.dart';
import 'package:inspector/app/modules/order/controllers/order_controller.dart';
import 'package:inspector/app/modules/order/order_list/controllers/order_list_controller.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/tools.dart';
// import 'package:jpush_flutter/jpush_flutter.dart';

class TabbarController extends GetxController {
  final index = 0.obs;
  // JPush jpush = JPush();

  @override
  void onInit() async {
    super.onInit();
    Get.put(HomeController());
    Get.put(HomeListController());
    Get.put(OrderController());
    Get.put(MessageController());
    Get.put(MineController());

    index.listen((p0) {
      if (p0 == 4) {
        Get.find<MineController>().loadData();
      } else if (p0 == 3) {
        Get.find<MessageController>().fetchList();
      } else if (p0 == 1) {
        Future.delayed(Duration(milliseconds: 300), () {
          Get.find<OrderListController>().refreshAction();
        });
      } else if (p0 == 0) {
        Future.delayed(Duration(milliseconds: 300), () {
          Get.find<HomeListController>().refreshAction();
        });
      }
    });

    // jpush.setup(
    //   appKey: "661b3ac7cffebe8fe9fbe4cd", //你自己应用的 AppKey
    //   channel: "theChannel",
    //   production: false,
    //   debug: true,
    // );
    // jpush.applyPushAuthority(NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // // Platform messages may fail, so we use a try/catch PlatformException.
    // jpush.getRegistrationID().then((rid) {
    //   print("flutter get registration id : $rid");
    // });

    // Location.share.showAlert();

    // final uid = GlobalConst.userModel?.uid.toString() ?? 'x';
    // jpush.setAlias(uid.toString());

    // initPlatformState();
    // final enable = await jpush.isNotificationEnabled();
    // if (!enable) {
    //   logger.e('isNotificationEnabled $enable');
    //   jpush.openSettingsForNotification();
    // }
  }

  @override
  void onReady() {
    super.onReady();

    if (GlobalConst.userModel?.phone == null ||
        GlobalConst.userModel?.email == null) {
      Get.generalDialog(
        pageBuilder: (ctx, a1, a2) {
          return SupplementView();
        },
      );
    }

    // JMessage.share.login();
  }

  @override
  void onClose() {}

  void navigateTo(int id) {
    index.value = id;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   String? platformVersion;

  //   try {
  //     jpush.addEventHandler(
  //         onReceiveNotification: (Map<String, dynamic> message) async {
  //       print("flutter onReceiveNotification: $message");
  //       jpush.sendLocalNotification(LocalNotification(
  //           id: 1,
  //           title: 'title',
  //           content: 'content',
  //           fireTime: DateTime.now()));
  //     }, onOpenNotification: (Map<String, dynamic> message) async {
  //       print("flutter onOpenNotification: $message");
  //     }, onReceiveMessage: (Map<String, dynamic> message) async {
  //       print("flutter onReceiveMessage: $message");
  //     }, onReceiveNotificationAuthorization:
  //             (Map<String, dynamic> message) async {
  //       print("flutter onReceiveNotificationAuthorization: $message");
  //       // jpush.openSettingsForNotification();
  //     }, onNotifyMessageUnShow: (Map<String, dynamic> message) async {
  //       print("flutter onNotifyMessageUnShow: $message");
  //     });
  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }
  // }
}
