import 'package:get/get.dart';
import 'package:inspector/app/modules/auth/login/controllers/auth_login_controller.dart';
import 'package:inspector/app/modules/order/order_list/views/order_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constant.dart';
import '../modules/auth/login/views/auth_login_view.dart';
import '../modules/auth/register/views/auth_register_view.dart';
import '../modules/auth/views/area_code_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/list_detail/bindings/list_detail_binding.dart';
import '../modules/home/list_detail/views/list_detail_view.dart';
import '../modules/home/record/bindings/record_binding.dart';
import '../modules/home/record/views/record_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/init/bindings/init_binding.dart';
import '../modules/init/web/bindings/web_binding.dart';
import '../modules/init/web/views/web_view.dart';
import '../modules/message/bindings/message_binding.dart';
import '../modules/message/chat/bindings/chat_binding.dart';
import '../modules/message/chat/views/chat_view.dart';
import '../modules/message/memeber/bindings/memeber_binding.dart';
import '../modules/message/memeber/views/memeber_view.dart';
import '../modules/message/views/message_view.dart';
import '../modules/mine/add_bank/bindings/add_bank_binding.dart';
import '../modules/mine/add_bank/views/add_bank_view.dart';
import '../modules/mine/address/bindings/address_binding.dart';
import '../modules/mine/address/views/address_view.dart';
import '../modules/mine/address_list/bindings/address_list_binding.dart';
import '../modules/mine/address_list/views/address_list_view.dart';
import '../modules/mine/apply/bindings/apply_binding.dart';
import '../modules/mine/apply/views/apply_view.dart';
import '../modules/mine/bill_list/bindings/bill_list_binding.dart';
import '../modules/mine/bill_list/views/bill_list_view.dart';
import '../modules/mine/bin_pay/bindings/bin_pay_binding.dart';
import '../modules/mine/bin_pay/views/bin_pay_view.dart';
import '../modules/mine/bind_bank/bindings/bind_bank_binding.dart';
import '../modules/mine/bind_bank/views/bind_bank_view.dart';
import '../modules/mine/bindings/mine_binding.dart';
import '../modules/mine/cash/bindings/cash_binding.dart';
import '../modules/mine/cash/views/cash_view.dart';
import '../modules/mine/charge/bindings/charge_binding.dart';
import '../modules/mine/charge/views/charge_view.dart';
import '../modules/mine/profile/bindings/profile_binding.dart';
import '../modules/mine/profile/views/profile_view.dart';
import '../modules/mine/setting/bindings/address_manage_binding.dart';
import '../modules/mine/setting/bindings/setting_binding.dart';
import '../modules/mine/setting/views/address_manage_view.dart';
import '../modules/mine/setting/views/setting_view.dart';
import '../modules/mine/views/mine_view.dart';
import '../modules/mine/wallet/bindings/wallet_binding.dart';
import '../modules/mine/wallet/views/wallet_view.dart';
import '../modules/order/bindings/order_binding.dart';
import '../modules/order/check/bindings/check_binding.dart';
import '../modules/order/check/views/check_view.dart';
import '../modules/order/review/bindings/review_binding.dart';
import '../modules/order/review/views/review_view.dart';
import '../modules/order/views/order_view.dart';
import '../modules/pulish/bindings/pulish_binding.dart';
import '../modules/pulish/date/bindings/date_binding.dart';
import '../modules/pulish/date/views/date_view.dart';
import '../modules/pulish/inspection_info/bindings/inspection_info_binding.dart';
import '../modules/pulish/inspection_info/views/inspection_info_view.dart';
import '../modules/pulish/pay/bindings/pay_binding.dart';
import '../modules/pulish/pay/views/pay_view.dart';
import '../modules/pulish/views/publish_view.dart';
import '../modules/tabbar/views/tabbar_view.dart';
import '../tools/global_const.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static Future<String> INITIAL([bool init = false]) async {
    final shareData = await SharedPreferences.getInstance();
    final isStart = shareData.getBool(Constant.kStart) ?? false;
    final int? language = shareData.getInt(Constant.kLanguage);
    final String user = shareData.getString(Constant.kUser) ?? '';
    final String firstInstall = shareData.getString(Constant.kInstall) ?? '';

    String? page = Routes.AUTH_LOGIN;
    if (GlobalConst.userModel?.token != null) {
      page = Routes.TABBAR;
    } else {
      Get.lazyPut<AuthLoginController>(() => AuthLoginController());
    }

    if (!init) {
      Get.offNamedUntil(page, (route) => false);
    }

    return Future.value(page);
  }

  static final routes = [
    GetPage(
      name: _Paths.AUTH_LOGIN,
      page: () => AuthLoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.TABBAR,
      page: () => CustomTabbarView(),
      binding: TabbarBinding(),
    ),
    GetPage(
      name: _Paths.AREALIST,
      page: () => AreaCodeView(),
      binding: TabbarBinding(),
    ),
    GetPage(
      name: _Paths.Register,
      page: () => AuthRegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.LIST_DETAIL,
          page: () => ListDetailView(),
          binding: ListDetailBinding(),
        ),
        GetPage(
          name: _Paths.RECORD,
          page: () => RecordView(),
          binding: RecordBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.ORDER,
      page: () => OrderView(),
      binding: OrderBinding(),
      children: [
        GetPage(
          name: _Paths.CHECK,
          page: () => CheckView(),
          binding: CheckBinding(),
        ),
        GetPage(
          name: _Paths.REVIEW,
          page: () => ReviewView(),
          binding: ReviewBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.ORDER_LIST1,
      page: () => OrderListView(0, show: true),
      binding: ReviewBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_LIST2,
      page: () => OrderListView(1, show: true),
      binding: ReviewBinding(),
    ),
    GetPage(
      name: _Paths.MESSAGE,
      page: () => IMessageView(),
      binding: MessageBinding(),
      children: [
        GetPage(
          name: _Paths.CHAT,
          page: () => ChatView(),
          binding: ChatBinding(),
        ),
        GetPage(
          name: _Paths.MEMEBER,
          page: () => MemeberView(),
          binding: MemeberBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.MINE,
      page: () => MineView(),
      binding: MineBinding(),
      children: [
        GetPage(
          name: _Paths.PROFILE,
          page: () => ProfileView(),
          binding: ProfileBinding(),
        ),
        GetPage(
          name: _Paths.APPLY,
          page: () => ApplyView(),
          binding: ApplyBinding(),
        ),
        GetPage(
          name: _Paths.ADDRESS,
          page: () => AddressView(),
          binding: AddressBinding(),
        ),
        GetPage(
          name: _Paths.ADDRESS_LIST,
          page: () => AddressListView(),
          binding: AddressListBinding(),
        ),
        GetPage(
          name: _Paths.SETTING,
          page: () => SettingPage(),
          binding: SettingBinding(),
        ),
        GetPage(
          name: _Paths.ADDRESS_MANAGE,
          page: () => Address_manageWidget(),
          binding: Address_manageBinding(),
        ),
        GetPage(
          name: _Paths.WALLET,
          page: () => WalletView(),
          binding: WalletBinding(),
        ),
        GetPage(
          name: _Paths.BIN_PAY,
          page: () => BinPayView(),
          binding: BinPayBinding(),
        ),
        GetPage(
          name: _Paths.BIND_BANK,
          page: () => BindBankView(),
          binding: BindBankBinding(),
        ),
        GetPage(
          name: _Paths.ADD_BANK,
          page: () => AddBankView(),
          binding: AddBankBinding(),
        ),
        GetPage(
          name: _Paths.CHARGE,
          page: () => ChargeView(),
          binding: ChargeBinding(),
        ),
        GetPage(
          name: _Paths.CASH,
          page: () => CashView(),
          binding: CashBinding(),
        ),
        GetPage(
          name: _Paths.BILL_LIST,
          page: () => BillListView(),
          binding: BillListBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.PUBLISH,
      page: () => PublishView(),
      binding: PulishBinding(),
      children: [
        GetPage(
          name: _Paths.INSPECTION_INFO,
          page: () => InspectionInfoView(),
          binding: InspectionInfoBinding(),
        ),
        GetPage(
          name: _Paths.DATE,
          page: () => DateView(),
          binding: DateBinding(),
        ),
        GetPage(
          name: _Paths.PAY,
          page: () => PayView(),
          binding: PayBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.WEB,
      page: () => WebView(),
      binding: WebBinding(),
    ),
  ];
}
