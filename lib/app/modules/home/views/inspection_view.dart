import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/constant.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/modules/home/controllers/home_controller.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/assets.dart';
import 'package:inspector/generated/locales.g.dart';

import '../../../routes/app_pages.dart';
import '../../../tools/public_provider.dart';

class InspectionView extends GetView<HomeController> {
  final int orderID;
  final bool isFirst;

  InspectionView(this.orderID, this.isFirst) {
    Future.delayed(Duration(milliseconds: 300), () {
      FocusScope.of(Get.context!).requestFocus(controller.focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(),
            onTap: () {
              Get.back();
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AspectRatio(
                        aspectRatio: 2.3,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            image: DecorationImage(
                              image: AssetImage(Assets.imagesInspectionPop),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 50),
                            child: Center(
                              child: Text(
                                LocaleKeys.home_know_tip.tr,
                                style: MFont.semi_Bold24
                                    .apply(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          LocaleKeys.home_inspection_tip.tr,
                          style: MFont.regular13.apply(color: MColor.xFFA2A2A2),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _textField,
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              if (controller.accountType.value == 1) {
                                controller.accountType.value = 2;
                              } else {
                                controller.accountType.value = 1;
                              }
                              GlobalConst.sharedPreferences?.setInt(
                                  Constant.accountType,
                                  controller.accountType.value);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              child: Obx(() {
                                return Center(
                                  child: Text(
                                    controller.accountType.value == 1
                                        ? '￥'
                                        : '\$',
                                    style: MFont.bold30
                                        .apply(color: MColor.xFF333333),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.isCheck.value =
                                  !controller.isCheck.value;
                            },
                            child: Obx(() {
                              return Icon(
                                  controller.isCheck.value
                                      ? Icons.check_box_outlined
                                      : Icons.check_box_outline_blank_outlined,
                                  size: 16,
                                  color: MColor.skin);
                            }),
                          ),
                          SizedBox(width: 5),
                          Text(
                            LocaleKeys.home_reviewed.tr,
                            style:
                                MFont.regular13.apply(color: MColor.xFF666666),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                Routes.WEB,
                                parameters: {
                                  'url':
                                      '${Server.web}/privacy/about_inspection.html',
                                  'title'
                                      '': LocaleKeys.home_know_tip.tr
                                },
                              );
                            },
                            child: Text(
                              LocaleKeys.home_know_tip.tr,
                              style: MFont.regular13.apply(color: MColor.skin),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 17),
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.fetchApply(orderID);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 7),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      MColor.skin,
                                      MColor.xFFFB6668
                                    ]),
                                    borderRadius: BorderRadius.circular(19.5)),
                                child: Center(
                                  child: Text(
                                    isFirst
                                        ? LocaleKeys.home_apply.tr
                                        : LocaleKeys.home_update.tr,
                                    style: MFont.regular15
                                        .apply(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (!isFirst) ...{
                            SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.canAction(orderID, false);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 7),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        MColor.xFFFB6668,
                                        MColor.skin
                                      ]),
                                      borderRadius:
                                          BorderRadius.circular(19.5)),
                                  child: Center(
                                    child: Text(
                                      LocaleKeys.home_apply_cancel.tr,
                                      style: MFont.regular15
                                          .apply(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          },
                          SizedBox(width: 10),
                        ],
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  iconSize: 45,
                  icon: Container(
                    width: 45,
                    height: 45,
                    child: Icon(
                      Icons.close,
                      size: 35,
                      color: MColor.xFF333333,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  get _textField {
    return Container(
      width: 120,
      child: TextField(
        controller: controller.editingController,
        style: MFont.bold30.apply(color: MColor.xFF565656),
        textAlign: TextAlign.right,
        focusNode: controller.focusNode,
        keyboardType:
            TextInputType.numberWithOptions(decimal: true, signed: false),
        inputFormatters: [PrecisionLimitFormatter(2)],
        decoration: InputDecoration(
          hintText: LocaleKeys.home_apply_price.tr,
          hintStyle: MFont.regular18.apply(color: MColor.xFFD7D9DD),
          filled: true,
          isDense: false,
          contentPadding: EdgeInsets.only(left: 17),
          constraints: BoxConstraints(maxHeight: 48, minHeight: 48),
          fillColor: Colors.white,
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      ),
    );
  }
}
