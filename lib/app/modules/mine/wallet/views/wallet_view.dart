import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/wallet_controller.dart';

class WalletView extends GetView<WalletController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.wallet_title.tr),
        centerTitle: true,
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Get.toNamed(Routes.BILL_LIST);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                LocaleKeys.wallet_bill.tr,
                style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: controller.icons.length,
              itemBuilder: (ctx, index) {
                return Obx(() {
                  final icon = controller.icons[index];
                  final title = controller.titles[index];
                  final value = controller.values.value[index];
                  return _iconText(icon, title, value, index);
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                    child: _textButton(0, LocaleKeys.wallet_charge.tr, action: () {
                  Get.toNamed(Routes.CHARGE)?.then((value) {
                    controller.fetchWalletInfo();
                  });
                })),
                SizedBox(width: 20),
                Expanded(
                  child: _textButton(1, LocaleKeys.wallet_cash.tr, action: () {
                    Get.toNamed(Routes.CASH)?.then((value) {
                      controller.fetchWalletInfo();
                    });
                  }),
                )
              ],
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _iconText(String icon, String title, String value, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (index < 2) {
          Get.toNamed(Routes.BILL_LIST);
        } else if (index == 2) {
          Get.toNamed(Routes.BIND_BANK);
        } else if (index == 3) {
          Get.toNamed(Routes.BIN_PAY, arguments: 1)?.then((value) {
            controller.fetchPayInfo();
          });
        } else if (index == 4) {
          Get.toNamed(Routes.BIN_PAY, arguments: 2)?.then((value) {
            controller.fetchPayInfo();
          });
        } else if (index == 5) {
          Get.toNamed(Routes.BIN_PAY, arguments: 3)?.then((value) {
            controller.fetchPayInfo();
          });
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: index == 0
              ? 18
              : index == 1
                  ? 7
                  : 16,
          bottom: index == 0
              ? 0
              : index == 1
                  ? 18
                  : 16,
        ),
        decoration: index == 0
            ? null
            : BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: index == 1 ? MColor.xFFF4F6F9 : MColor.xFFE6E6E6,
                    width: index == 1 ? 10 : 0.5,
                  ),
                ),
              ),
        child: Row(
          children: [
            Image.asset(icon, width: 16, height: 16),
            SizedBox(width: 13),
            Text(
              title,
              style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
            ),
            Expanded(
              child: Text(
                value,
                style: index < 2
                    ? MFont.medium16.apply(color: MColor.xFF3D3D3D)
                    : MFont.medium16.apply(color: MColor.xFF838383),
                textAlign: TextAlign.right,
              ),
            ),
            Visibility(
              visible: index > 1,
              child: Icon(
                Icons.keyboard_arrow_right_sharp,
                size: 16,
                color: MColor.xFF838383,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textButton(int index, String title, {@required VoidCallback? action}) {
    return Container(
      child: TextButton(
        onPressed: () {
          action!();
        },
        child: Text(
          title,
          style: MFont.medium15.apply(color: index == 0 ? Colors.white : MColor.xFFD7A17C),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(index == 0 ? MColor.xFFD7A17C : Colors.white),
          shape: MaterialStateProperty.all(StadiumBorder()),
          minimumSize: MaterialStateProperty.all(Size(double.infinity, 40)),
          visualDensity: VisualDensity.compact,
          maximumSize: MaterialStateProperty.all(Size(double.infinity, 40)),
          side: MaterialStateProperty.all(BorderSide(color: MColor.xFFD7A17C, width: 0.5)),
        ),
      ),
    );
  }
}
