import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/data/order_explain_entity.dart';
import 'package:inspector/app/modules/order/order_list/controllers/order_list_controller.dart';
import 'package:inspector/app/modules/pulish/controllers/publish_controller.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/generated/locales.g.dart';

import '../../tabbar/controllers/tabbar_controller.dart';

class PublishView extends GetView<PublishController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.publish_title.tr),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text(
                    LocaleKeys.publish_welcome.tr,
                    style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
                  ),
                  SizedBox(height: 10),
                  for (int i = 0; i < controller.explains.length; i++) ...{
                    _itemView(controller.explains[i]),
                  },
                ],
              ),
            ),
            _nextButton,
          ],
        ),
      ),
    );
  }

  Widget _itemView(OrderExplain explain) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Obx(() {
        final type = controller.indexType.value;
        bool isSelected = explain.type == type;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                controller.checkData(explain.type);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      explain.icon,
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      explain.title,
                      style: MFont.semi_Bold15.apply(color: MColor.xFF3D3D3D),
                    ),
                    SizedBox(width: 8),
                    Container(
                      // width: 20,
                      // height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: MColor.xFF565656)),
                      child: Center(
                        child: Icon(
                          isSelected
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 15,
                          color: MColor.xFF565656,
                        ),
                      ),
                    ),
                    Spacer(),
                    Icon(
                      isSelected
                          ? Icons.radio_button_on
                          : Icons.radio_button_off,
                      size: 20,
                      color: MColor.skin,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: MColor.xFFEEEEEE,
              height: 0.5,
            ),
            if (isSelected) ...{
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: MColor.xFFEEEEEE.withOpacity(0.6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isSelected) ...{
                      Text(
                        explain.content,
                        style: MFont.medium13.apply(color: MColor.xFF838383),
                      ),
                      SizedBox(height: 12),
                      Text(
                        explain.pointTitle,
                        style: MFont.semi_Bold15.apply(color: MColor.xFF3D3D3D),
                      ),
                      SizedBox(height: 8),
                      Text(
                        explain.points,
                        style: MFont.medium14.apply(color: MColor.xFF3D3D3D),
                      ),
                      if (explain.otherTitle != null) ...{
                        Text(
                          explain.otherTitle ?? '',
                          style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
                        ),
                        SizedBox(width: 5),
                        Text(
                          explain.otherContent ?? '',
                          style: MFont.medium14.apply(color: MColor.xFF3D3D3D),
                        ),
                      }
                    },
                  ],
                ),
              ),
            },
          ],
        );
      }),
    );
  }

  get _nextButton {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(StadiumBorder()),
          backgroundColor: MaterialStateProperty.all(MColor.skin),
          minimumSize: MaterialStateProperty.all(Size(double.infinity, 49)),
        ),
        onPressed: () {
          if (controller.indexType.value <= 0) {
            return;
          }
          Get.toNamed(Routes.INSPECTION_INFO,
                  arguments: controller.indexType.value)
              ?.then((value) {
            if (value == null) {
              return;
            }
            Get.find<TabbarController>().navigateTo(1);
            Get.back();
          });
        },
        child: Text(
          LocaleKeys.publish_next.tr,
          style: MFont.medium18.apply(color: Colors.white),
        ),
      ),
    );
  }
}
