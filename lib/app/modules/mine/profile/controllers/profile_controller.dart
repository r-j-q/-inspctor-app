import 'package:get/get.dart';
import 'package:inspector/app/modules/auth/mine_provider.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

class ProfileController extends GetxController {
  MineProvider provider = MineProvider();
  List<String> titles = [
    LocaleKeys.profile_avatar.tr,
    LocaleKeys.profile_name.tr,
    LocaleKeys.profile_mobile.tr,
    LocaleKeys.profile_email.tr,
    LocaleKeys.profile_wechat.tr
  ];
  final values = ['', '', '', '', '', ''].obs;
  final image = ''.obs;
  final valueChange = false.obs;
  Rx<String> phone = ''.obs;
  Rx<String> email = ''.obs;
  Rx<String> name = ''.obs;
  Rx<String> avatar = ''.obs;
  Rx<String> wechat = ''.obs;

  @override
  void onInit() {
    super.onInit();

    email.value = GlobalConst.userModel?.email ?? '';
    phone.value = GlobalConst.userModel?.phone ?? '';
    name.value = GlobalConst.userModel?.name ?? '';
    avatar.value = GlobalConst.userModel?.head ?? '';
    wechat.value = GlobalConst.userModel?.wechatNum ?? '';
    image.value = avatar.value;
    setData();
  }

  void setData() {
    values.value[0] = avatar.value;
    values.value[1] = name.value;
    values.value[2] = phone.value;
    values.value[3] = email.value;
    values.value[4] = wechat.value;
    image.value = avatar.value;
    valueChange.value = !valueChange.value;
  }

  void fetchEditInfo() {
    provider
        .editInfo(phone.value, wechat.value, email.value, avatar.value, name.value)
        .then((value) {
      setData();
      showToast(value.message ?? '');
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  @override
  void dispose() {
    super.dispose();
  }
}
