import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../controllers/order_list_controller.dart';

class OrderListView extends GetView {
  final int index;
  final bool show;

  OrderListView(this.index, {this.show = false}) {
    Get.put(OrderListController(), tag: index.toString());
    controller.pageIndex = index;
  }

  @override
  OrderListController get controller {
    return Get.find<OrderListController>(tag: index.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: show
          ? AppBar(
              title: Text(index == 1
                  ? LocaleKeys.mine_order.tr
                  : LocaleKeys.mine_check.tr),
              centerTitle: true,
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            _topView,
            Expanded(
              child: Obx(() {
                return Container(
                  color: MColor.xFFF4F5F7,
                  child: SmartRefresher(
                    controller: controller.refreshController,
                    onRefresh: () => controller.refreshAction(),
                    onLoading: () => controller.loadMore(),
                    enablePullUp: true,
                    child: ListView.builder(
                      itemCount: controller.listEntity.isEmpty
                          ? 1
                          : controller.listEntity.length,
                      padding: EdgeInsets.only(bottom: 12),
                      itemBuilder: (ctx, index) {
                        if (controller.listEntity.isEmpty) {
                          return Container(
                            width: double.infinity,
                            height: Get.height / 2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.hourglass_empty,
                                    size: 40,
                                    color: MColor.xFF999999,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '暂无数据',
                                    style: MFont.regular15
                                        .apply(color: MColor.xFF666666),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            final oid = controller.listEntity[index].id ??
                                controller.listEntity[index].orderId;
                            Get.toNamed(Routes.LIST_DETAIL, arguments: oid)
                                ?.then((value) {
                              if (value) {
                                controller.refreshAction();
                              }
                            });
                          },
                          child: _itemView(index),
                        );
                      },
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  get _topView {
    return Obx(() {
      return Container(
        height: 60,
        padding: EdgeInsets.symmetric(vertical: 14),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 14),
          children: [
            Wrap(
              spacing: 10,
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: [
                for (int i = 0; i < controller.tabTitles.length; i++) ...{
                  Obx(() {
                    final selected = controller.selectedIndex.value == i;
                    return ChoiceChip(
                      visualDensity: VisualDensity(vertical: -4),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      label: Text(controller.tabTitles[i]),
                      labelStyle: MFont.regular14.apply(
                          color: selected ? MColor.skin : MColor.xFF565656),
                      selected: selected,
                      selectedColor: MColor.skin_05,
                      side: selected ? BorderSide(color: MColor.skin) : null,
                      onSelected: (selected) {
                        controller.selectedIndex.value = i;
                        controller.refreshAction();
                      },
                      autofocus: true,
                    );
                  })
                }
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _itemView(int index) {
    final model = controller.listEntity[index];
    final lat = model.lat ?? 0;
    final lon = model.lon ?? 0;
    final showLocation = (lon > 0) && (lat > 0);

    int addTime = (model.addTime ?? 0) * 1000;
    var statusText = LocaleKeys.order_wait.tr;
    var textColor = MColor.xFFDF8D14;
    //1-待支付 2-待派单 3-待验货 6-验货中 4已完成
    //订单状态:0待支付,-1取消,-2已退回,1待派单,2派单确认,3准备验货,4验货中,5已完成
    final flag = model.flag ?? 0;
    if (flag == 0) {
      statusText = LocaleKeys.order_wait_pay.tr;
      textColor = MColor.skin;
    } else if (flag == -1) {
      statusText = LocaleKeys.order_cancelled.tr;
      textColor = MColor.xFF0081E7;
    } else if (flag == 1) {
      statusText = LocaleKeys.order_wait_dispatch.tr;
      textColor = MColor.xFF1BA12B;
    } else if (flag == 3) {
      statusText = LocaleKeys.order_ready_inspect.tr;
      textColor = MColor.xFF0081E7;
    } else if (flag == 4) {
      statusText = LocaleKeys.order_doing.tr;
      textColor = MColor.xFF1BA12B;
    } else if (flag == 5) {
      statusText = LocaleKeys.order_finished.tr;
      textColor = MColor.xFF1BA12B;
    }
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12, top: 10),
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 12, right: 12, top: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  model.provinceCity ??
                      '${model.province ?? ''}${model.city ?? ''}',
                  style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Location.share
                        .toNavigation(model.lat, model.lon, model.address);
                  },
                  child: Offstage(
                    offstage: !showLocation,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_sharp,
                            color: MColor.xFF838383,
                            size: 25,
                          ),
                          Text(
                            LocaleKeys.home_navi.tr,
                            style:
                                MFont.medium15.apply(color: MColor.xFF838383),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Center(
                  child: Text(
                    statusText,
                    style: MFont.medium13.apply(color: textColor),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: model.address != null && model.address!.isNotEmpty,
            child: Container(
              padding: EdgeInsets.only(left: 12, right: 12, top: 8),
              child: Text(
                model.address ?? '',
                style: MFont.regular13.apply(color: MColor.xFF838383),
              ),
            ),
          ),
          _textItem(LocaleKeys.order_goods_name.tr, model.productName),
          _textItem(
            LocaleKeys.order_order_time.tr,
            model.date?.toString() ??
                DateUtil.formatDate(
                    DateTime.fromMillisecondsSinceEpoch(addTime),
                    format: 'yyyy-MM-dd HH:mm:ss'),
          ),
          _textItem(
            LocaleKeys.order_order_amount.tr,
            model.userAccount == 1
                ? '￥${model.price.toString()}'
                : '\$${model.price.toString()}',
          ),
        ],
      ),
    );
  }

  Widget _textItem(String? title, String? value) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 4),
      child: Row(
        children: [
          Text(
            '$title：',
            style: MFont.regular13.apply(color: MColor.xFF838383),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: MFont.regular13.apply(color: MColor.xFF565656),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
