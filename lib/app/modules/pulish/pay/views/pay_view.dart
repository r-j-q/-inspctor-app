import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/pay_controller.dart';

class PayView extends GetView<PayController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.pay_title.tr),
        centerTitle: true,
      ),
      body: Container(
        color: MColor.xFFF4F5F7,
        child: Column(
          children: [
            _amountView,
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Column(
                  children: [
                    for (int i = 0; i < controller.titles.length; i++) ...{
                      Visibility(
                        visible: controller.isUsd
                            ? i == 1 || i == 2
                            : i == 0 || i == 3,
                        child: _payItemView(
                            i, controller.icons[i], controller.titles[i]),
                      ),
                      Divider(
                        thickness: 1,
                        height: 0.5,
                        color: MColor.xFFF4F5F7,
                        indent: 15,
                        endIndent: 15,
                      ),
                    },
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _nextButton,
          ],
        ),
      ),
    );
  }

  get _amountView {
    var amount = '￥';
    if (controller.isUsd) {
      amount = '\$';
    }
    amount += '${controller.price}';
    return Container(
      margin: EdgeInsets.only(top: 18),
      child: Center(
        child: Text(
          amount,
          style: MFont.semi_Bold24.apply(color: MColor.xFF333333),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _payItemView(int index, String icon, String title) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        controller.index.value = index;
        controller.checkPayType(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        color: Colors.white,
        child: Row(
          children: [
            Image.asset(
              icon,
            ),
            SizedBox(width: 4),
            Text(
              title,
              style: MFont.medium15.apply(color: MColor.xFF333333),
            ),
            Spacer(),
            Obx(() {
              return Icon(
                controller.index.value == index
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                size: 16,
                color: MColor.skin,
              );
            }),
          ],
        ),
      ),
    );
  }

  get _nextButton {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(StadiumBorder()),
          backgroundColor: MaterialStateProperty.all(MColor.skin),
          minimumSize: MaterialStateProperty.all(Size(double.infinity, 44)),
        ),
        onPressed: () {
          controller.fetchPayInfo();
        },
        child: Text(
          LocaleKeys.apply_submit.tr,
          style: MFont.medium16.apply(color: Colors.white),
        ),
      ),
    );
  }
}
