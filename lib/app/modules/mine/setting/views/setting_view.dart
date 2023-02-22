import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/tools/device.dart';
import 'package:inspector/generated/assets.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/setting_controller.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingCtrl = Get.find<SettingController>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(LocaleKeys.setting_title.tr),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(color: MColor.xFFE6E6E6, thickness: 0.5),
        ),
      ),
      body: Column(
        children: [
          _itemView(Assets.imagesSettingClearIcon, LocaleKeys.setting_clear_cache.tr, [
            Obx(() {
              return Text(
                controller.appCacheSize.value,
                style: MFont.medium15.apply(color: MColor.xFF838383),
              );
            }),
          ], () {
            settingCtrl.clearCacheSize();
          }),
          _getDivider(0.5, MColor.xFFE6E6E6, 15),
          _itemView(Assets.imagesSettingAboutusIcon, LocaleKeys.setting_about_us.tr, [], () {}),
          _getDivider(8.0, MColor.xFFF4F5F7, 0),
          GetBuilder<SettingController>(builder: (_) {
            return _itemView(Assets.imagesSettingMsgIcon, LocaleKeys.setting_receive_msg.tr, [
              CupertinoSwitch(
                  value: _.receiveMsgSwitch,
                  onChanged: (select) {
                    _.selectReceiveMsgSwitch();
                  })
            ], () {
              _.selectReceiveMsgSwitch();
            });
          }),
          _getDivider(0.5, MColor.xFFE6E6E6, 15),
          _itemView(
              Assets.imagesSettingAboutusIcon,
              LocaleKeys.setting_version.tr,
              [
                Text(
                  DeviceUtils.version ?? '',
                  style: MFont.medium15.apply(color: MColor.xFF838383),
                ),
              ],
              () {}),
          _getDivider(8.0, MColor.xFFF4F5F7, 0),
          TextButton(
            onPressed: () {
              settingCtrl.loginout();
            },
            child: Text(LocaleKeys.setting_login_out.tr),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(MColor.xFFE95332),
              minimumSize: MaterialStateProperty.all(Size.fromHeight(50)),
              textStyle: MaterialStateProperty.all(TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
              child: Container(
            color: MColor.xFFF4F5F7,
          ))
        ],
      ),
    );
  }

  Widget _getDivider(double hight, Color color, double paddingLeft) {
    return Padding(
      padding: EdgeInsets.fromLTRB(paddingLeft, 0, 0, 0),
      child: Divider(
        color: color,
        thickness: hight,
      ),
    );
  }

  Widget _itemView(String icon, String text, List<Widget> endView, VoidCallback action) {
    return InkWell(
      onTap: () => action(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            // Image.asset(icon, width: 27, height: 27),
            // SizedBox(width: 18),
            Text(
              text,
              style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
            ),
            Spacer(),
            ...endView,
            Icon(
              Icons.keyboard_arrow_right_outlined,
              size: 24,
              color: MColor.xFFBBBBBB,
            ),
          ],
        ),
      ),
    );
  }
}
