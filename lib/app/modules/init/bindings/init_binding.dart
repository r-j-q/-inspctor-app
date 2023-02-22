import 'package:get/get.dart';
import 'package:inspector/app/modules/auth/login/controllers/auth_login_controller.dart';
import 'package:inspector/app/modules/auth/register/controllers/auth_register_controller.dart';
import 'package:inspector/app/modules/home/controllers/home_controller.dart';
import 'package:inspector/app/modules/init/controllers/init_controller.dart';
import 'package:inspector/app/modules/message/controllers/message_controller.dart';
import 'package:inspector/app/modules/mine/controllers/mine_controller.dart';
import 'package:inspector/app/modules/order/controllers/order_controller.dart';
import 'package:inspector/app/modules/tabbar/controllers/tabbar_controller.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<AuthRegisterController>(() => AuthRegisterController());
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<InitController>(() => InitController());
    Get.put(InitController());
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthLoginController>(() => AuthLoginController());
  }
}

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRegisterController>(() => AuthRegisterController());
  }
}

class TabbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabbarController>(() => TabbarController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<MineController>(() => MineController());
    Get.lazyPut<MessageController>(() => MessageController());
    Get.lazyPut<OrderController>(() => OrderController());
  }
}
