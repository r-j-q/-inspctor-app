import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/generated/assets.dart';
import 'package:inspector/generated/locales.g.dart';

class SupplementView extends GetView {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.back();
      },
      child: Container(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            margin: EdgeInsets.symmetric(horizontal: 38),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 98),
                  child: Image.asset(Assets.imagesAlertPerson),
                ),
                SizedBox(height: 10),
                Text(
                  LocaleKeys.supplement_title.tr,
                  style: MFont.medium16.apply(color: MColor.xFF333333),
                ),
                SizedBox(height: 35),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30, bottom: 15),
                  width: double.infinity,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(MColor.skin),
                      shape: MaterialStateProperty.all(StadiumBorder()),
                    ),
                    onPressed: () {
                      Get.back();
                      Get.toNamed(Routes.PROFILE);
                    },
                    child: Text(
                      LocaleKeys.supplement_next.tr,
                      style: MFont.medium16.apply(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
