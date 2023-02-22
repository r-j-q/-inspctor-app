import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/modules/mine/profile/views/input_text_view.dart';
import 'package:inspector/app/modules/order/controllers/order_controller.dart';
import 'package:inspector/app/modules/tabbar/controllers/tabbar_controller.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/assets.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/mine_controller.dart';

class MineView extends GetView<MineController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: ListView(
        padding: EdgeInsets.zero,
        physics: ClampingScrollPhysics(),
        children: [
          _topView,
          SizedBox(height: 4),
          _itemView(Assets.imagesMineOrder, LocaleKeys.mine_order.tr, () {
            if (GlobalConst.userModel?.isYanHuoYuan ?? false) {
              Get.find<TabbarController>().index.value = 1;
              Future.delayed(Duration(microseconds: 300), () {
                Get.find<OrderController>().pageTabController?.animateTo(0);
              });
            } else {
              Get.toNamed(Routes.ORDER_LIST1);
            }
          }),
          // Divider(indent: 30, color: MColor.xFFE6E6E6, thickness: 0.5),
          // _itemView(Assets.imagesMineCheck, LocaleKeys.mine_check.tr, () {
          //   Get.find<TabbarController>().index.value = 1;
          //   Future.delayed(Duration(microseconds: 300), () {
          //     Get.find<OrderController>().pageTabController?.animateTo(0);
          //   });
          // }),
          Divider(indent: 30, color: MColor.xFFE6E6E6, thickness: 0.5),
          _itemView(Assets.imagesMineOrder, LocaleKeys.mine_recommend.tr, () {
            Get.generalDialog(
              pageBuilder: (ctx, a1, a2) {
                return InputTextView(
                  '推荐下单',
                  TextInputType.emailAddress,
                  placeHolder: "请输入被推荐人邮箱或手机号",
                );
              },
            ).then((value) {
              final text = (value as String?) ?? '';
              if (text.isNotEmpty) {
                controller.fetchRecommend(text);
              }
            });
          }),
          Divider(indent: 30, color: MColor.xFFE6E6E6, thickness: 0.5),
          _itemView(Assets.imagesMineAddress, LocaleKeys.mine_address.tr, () {
            Get.toNamed(Routes.ADDRESS_LIST, arguments: true);
          }),
          Divider(color: MColor.xFFF4F6F9, thickness: 10),
          _itemView(Assets.imagesMineSetting, LocaleKeys.mine_setting.tr, () {
            Get.toNamed(Routes.SETTING);
          }),
        ],
      ),
    );
  }

  get _topView {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.toNamed(Routes.PROFILE)?.then((value) {
          controller.fetchUserInfo();
        });
      },
      child: Container(
        child: Stack(
          children: [
            Image.asset(
              Assets.imagesMineTop,
              width: Get.width,
              height: 235,
              fit: BoxFit.cover,
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _authView,
                  _infoView,
                  _walletView,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  get _authView {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.toNamed(Routes.APPLY)?.then((value) {
          controller.fetchUserInfo();
        });
      },
      child: Row(
        children: [
          Spacer(),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: 25,
            decoration: BoxDecoration(
              color: MColor.xFFEEB697,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.5),
                bottomLeft: Radius.circular(12.5),
              ),
            ),
            padding: EdgeInsets.only(left: 15, right: 12),
            child: Center(
              child: Obx(() {
                final checkStatus =
                    controller.infoEntity.value.checkStatus ?? 1;
                var text = LocaleKeys.apply_title.tr;
                if (checkStatus == 1) {
                  text = LocaleKeys.mine_checking.tr;
                } else if (checkStatus == 2) {
                  text = LocaleKeys.mine_authed.tr;
                } else if (checkStatus == 3) {
                  text = LocaleKeys.mine_check_failed.tr;
                }
                return Text(
                  text,
                  style: MFont.medium15.apply(color: MColor.xFF303535),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  get _infoView {
    return Container(
      margin: EdgeInsets.only(top: 23, left: 16, right: 16),
      child: Obx(() {
        final user = controller.infoEntity.value;

        var info = '';
        if ((user.email ?? '').isNotEmpty) {
          info = user.email!;
        }
        if ((user.phone ?? '').isNotEmpty) {
          if (info.isEmpty) {
            info = user.phone!;
          } else {
            info += ' | ' + user.phone!;
          }
        }
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name ?? '-',
                    style: MFont.semi_Bold24.apply(color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    info.fixAutoLines(),
                    style: MFont.medium13.apply(
                      color: Colors.white.withOpacity(0.75),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: CachedNetworkImage(
                imageUrl: user.head ?? '',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                placeholder: (ctx, e) {
                  return Container(
                    decoration: BoxDecoration(
                      color: MColor.xFFEEEEEE,
                      borderRadius: BorderRadius.circular(35),
                    ),
                  );
                },
                errorWidget: (ctx, e, x) {
                  return Container(
                    decoration: BoxDecoration(
                      color: MColor.xFFEEEEEE,
                      borderRadius: BorderRadius.circular(35),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  get _walletView {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.toNamed(Routes.WALLET);
      },
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16, top: 23),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient:
              LinearGradient(colors: [MColor.xFFFEE0D0, MColor.xFFEEB595]),
        ),
        child: Row(
          children: [
            Text(
              LocaleKeys.mine_amount.tr,
              style: MFont.regular13.apply(color: MColor.xFF5C3F2B),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Obx(() {
                final rmb = controller.wallet.value.rmbAmount ?? 0;
                final usd = controller.wallet.value.usdAmount ?? 0;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '￥$rmb',
                      style: MFont.medium18.apply(color: MColor.xFF5C3F2B),
                    ),
                    Text(
                      '\$$usd',
                      style: MFont.medium18.apply(color: MColor.xFF5C3F2B),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.WALLET);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient:
                      LinearGradient(colors: [MColor.xFFE95332, MColor.skin]),
                ),
                width: 100,
                height: 40,
                child: Center(
                  child: Text(
                    LocaleKeys.mine_cash.tr,
                    style: MFont.medium15.apply(color: MColor.xFFEEEEEE),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemView(String icon, String text, VoidCallback action) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => action(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 17),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 22,
              height: 22,
              color: MColor.xFF3D3D3D,
            ),
            SizedBox(width: 18),
            Text(
              text,
              style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
            ),
            Spacer(),
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
