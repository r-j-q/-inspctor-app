import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/modules/order/order_list/views/order_list_view.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.order_title.tr),
          centerTitle: true,
          bottom: TabBar(
            controller: controller.pageTabController,
            indicatorColor: MColor.skin,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2,
            isScrollable: false,
            labelColor: MColor.skin,
            unselectedLabelColor: MColor.xFF565656,
            labelStyle: MFont.medium16.apply(color: MColor.skin),
            unselectedLabelStyle: MFont.medium16.apply(color: MColor.xFF565656),
            tabs: [
              Tab(text: LocaleKeys.order_output.tr),
              Tab(text: LocaleKeys.order_input.tr)
            ],
          ),
        ),
        body: TabBarView(
          children: [OrderListView(0), OrderListView(1)],
          controller: controller.pageTabController,
        ),
      ),
    );
  }
}
