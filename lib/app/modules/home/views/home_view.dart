import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/modules/home/controllers/home_controller.dart';
import 'package:inspector/app/modules/home/views/list_view.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/generated/locales.g.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.home_title.tr),
          centerTitle: true,
          actions: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Get.toNamed(Routes.RECORD);
              },
              child: Container(
                padding: EdgeInsets.only(right: 20),
                child: Center(
                  child: Text(
                    LocaleKeys.home_record.tr,
                    style: MFont.medium16.apply(color: MColor.xFF797979),
                  ),
                ),
              ),
            ),
          ],
          bottom: TabBar(
            controller: controller.tabController,
            indicatorColor: MColor.skin,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2,
            isScrollable: false,
            labelColor: MColor.skin,
            unselectedLabelColor: MColor.xFF565656,
            labelStyle: MFont.medium16.apply(color: MColor.skin),
            unselectedLabelStyle: MFont.medium16.apply(color: MColor.xFF565656),
            tabs: [
              Tab(text: LocaleKeys.home_newest.tr),
              Tab(text: LocaleKeys.home_nearest.tr)
            ],
          ),
        ),
        body: TabBarView(
          children: [HomeListView(0), HomeListView(1)],
          controller: controller.tabController,
        ),
      ),
    );
  }
}
