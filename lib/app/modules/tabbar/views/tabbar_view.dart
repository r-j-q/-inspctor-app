import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/modules/home/views/home_view.dart';
import 'package:inspector/app/modules/mine/views/mine_view.dart';
import 'package:inspector/app/modules/order/views/order_view.dart';
import 'package:inspector/app/modules/tabbar/controllers/tabbar_controller.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/generated/assets.dart';

import '../../message/views/message_view.dart';

class CustomTabbarView extends GetView<TabbarController> {
  final _bodyList = [HomeView(), OrderView(), Container(), IMessageView(), MineView()];
  final _titles = ['抢单', '订单', '', '消息', '我的'];
  final _defaultList = [
    Assets.imagesHomeDefault,
    Assets.imagesOrderDefault,
    Assets.imagesOrderDefault,
    Assets.imagesMessageDefault,
    Assets.imagesMineDefault
  ];
  final _selectedList = [
    Assets.imagesHomeSelected,
    Assets.imagesOrderSelected,
    Assets.imagesOrderSelected,
    Assets.imagesMessageSelected,
    Assets.imagesMineSelected
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _bodyList[controller.index.value]),
      extendBody: true,
      floatingActionButton: IconButton(
        onPressed: () {},
        padding: EdgeInsets.zero,
        iconSize: 100,
        icon: Container(
          margin: EdgeInsets.only(top: 35),
          child: GestureDetector(
            onTap: () {
              Get.toNamed(Routes.PUBLISH);
            },
            child: Container(
              padding: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.transparent,
                boxShadow: [BoxShadow(color: MColor.x80E3E3E3, blurRadius: 3)],
              ),
              child: Image.asset(Assets.imagesAddTask),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(() {
        final index = controller.index.value;

        return BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: MColor.skin,
          unselectedItemColor: MColor.xFF9A9B9C,
          selectedLabelStyle: MFont.medium10,
          unselectedLabelStyle: MFont.medium10,
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          elevation: 8,
          onTap: (index) {
            controller.index.value = index;
          },
          items: [
            for (int i = 0; i < _titles.length; i++) ...{
              BottomNavigationBarItem(
                icon: Image.asset(
                  _defaultList[i],
                  width: 24,
                  height: 24,
                ),
                activeIcon: Image.asset(
                  _selectedList[i],
                  width: 24,
                  height: 24,
                ),
                label: _titles[i],
              )
            }
          ],
        );
      }),
    );
  }
}
