import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/modules/home/controllers/home_controller.dart';
import 'package:inspector/app/modules/home/controllers/home_list_controller.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/assets.dart';
import 'package:inspector/generated/locales.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeListView extends GetView {
  final int index;
  HomeListView(this.index) {
    Get.put(HomeListController(), tag: index.toString());
    controller.pageIndex = index;
  }

  @override
  HomeListController get controller {
    return Get.find<HomeListController>(tag: index.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: MColor.xFFF4F5F7,
        child: Obx(() {
          return SmartRefresher(
            controller: controller.refreshController,
            onRefresh: () => controller.refreshAction(),
            onLoading: () => controller.loadMore(),
            enablePullUp: true,
            child: ListView.builder(
              itemCount: controller.listEntity.isEmpty
                  ? 1
                  : controller.listEntity.length,
              itemBuilder: (ctx, index) {
                if (controller.listEntity.isEmpty) {
                  return Container(
                    width: double.infinity,
                    height: Get.height / 2,
                    child: Stack(
                      children: [
                        Center(
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
                      ],
                    ),
                  );
                }
                return _cardView(index);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _cardView(int index) {
    final model = controller.listEntity[index];
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        _itemView(index),
        if (model.connectLast) ...{
          SizedOverflowBox(
            alignment: Alignment.topCenter,
            size: Size(72, 72),
            child: Image.asset(Assets.link),
          ),
        },
        if (model.connectNext) ...{
          Positioned(
            bottom: 0,
            child: SizedOverflowBox(
              alignment: Alignment.bottomCenter,
              size: Size(72, 72),
              child: Image.asset(Assets.link),
            ),
          ),
        }
      ],
    );
  }

  Widget _itemView(int index) {
    final model = controller.listEntity[index];
    final lat = model.lat ?? 0;
    final lon = model.lon ?? 0;
    final showLocation = (lon > 0) && (lat > 0);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.toNamed(Routes.LIST_DETAIL,
            arguments: model.id, parameters: {'isApply': '1'})?.then((value) {
          if (value) {
            controller.refreshAction();
          }
        });
      },
      child: Container(
          margin: EdgeInsets.only(left: 12, right: 12, top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  children: [
                    Spacer(),
                    Offstage(
                      offstage: model.award == null,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(Assets.imagesRmbIcon)),
                        ),
                        width: 127,
                        height: 27,
                        child: Center(
                          child: Text(
                            LocaleKeys.home_recommend
                                .trArgs([model.award ?? '']),
                            style: MFont.medium12.apply(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 16, left: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              model.provinceCity ?? '-',
                              style:
                                  MFont.medium16.apply(color: MColor.xFF3D3D3D),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                Location.share.toNavigation(
                                    model.lat, model.lon, model.address);
                              },
                              child: Offstage(
                                offstage: !showLocation,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_sharp,
                                        color: MColor.xFF838383,
                                        size: 25,
                                      ),
                                      Text(
                                        LocaleKeys.home_navi.tr,
                                        style: MFont.medium15
                                            .apply(color: MColor.xFF838383),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Offstage(
                              offstage:
                                  model.date == null || model.date!.isEmpty,
                              child: Text(
                                '${model.date}',
                                textAlign: TextAlign.center,
                                style: MFont.regular13
                                    .apply(color: MColor.xFF838383),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                            visible: model.address != null &&
                                model.address!.isNotEmpty,
                            child: Container(
                              padding:
                                  EdgeInsets.only(left: 12, right: 12, top: 8),
                              child: Text(
                                model.address ?? '',
                                style: MFont.regular13
                                    .apply(color: MColor.xFF838383),
                              ),
                            )),
                        SizedBox(width: 4),
                        Offstage(
                          offstage:
                              model.distance == null || model.distance!.isEmpty,
                          child: Text(
                            '${model.distance}',
                            style:
                                MFont.regular13.apply(color: MColor.xFF838383),
                          ),
                        ),
                      ]),
                  Container(
                    margin: EdgeInsets.only(top: 13, left: 12, right: 12),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    height: 44,
                    color: MColor.xFFF7F8F9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          model.inspectionDate ?? '-',
                          style: MFont.regular13.apply(color: MColor.xFF838383),
                        ),
                        Container(
                            color: MColor.xFFDDDDDD, width: 1, height: 24),
                        Text(
                          model.type ?? '-',
                          style: MFont.regular13.apply(color: MColor.xFF838383),
                        ),
                        Container(
                            color: MColor.xFFDDDDDD, width: 1, height: 24),
                        Text(
                          LocaleKeys.home_unit.trArgs([
                            '${model.inspNumber ?? 0}',
                            '${model.inspDay ?? 0}'
                          ]),
                          style: MFont.regular13.apply(color: MColor.xFF838383),
                        ),
                        Container(
                            color: MColor.xFFDDDDDD, width: 1, height: 24),
                        Text(
                          model.reportType ?? '-',
                          style: MFont.regular13.apply(color: MColor.xFF838383),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 4),
                    child: Row(
                      children: [
                        Text(
                          '${LocaleKeys.home_product_tip.tr}：',
                          style: MFont.regular13.apply(color: MColor.xFF838383),
                        ),
                        Expanded(
                          child: Text(
                            model.productName ?? '-',
                            style:
                                MFont.regular13.apply(color: MColor.xFF565656),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        UnconstrainedBox(
                          child: TextButton(
                            onPressed: () {
                              var first = true;
                              if (model.applyStatus ==
                                  LocaleKeys.order_applying.tr) {
                                first = false;
                              }
                              Get.find<HomeController>()
                                  .fetchPrice(model.id ?? 0, first);
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(StadiumBorder()),
                              side: MaterialStateProperty.all(BorderSide(
                                  color: model.applyStatus !=
                                          LocaleKeys.order_applying.tr
                                      ? MColor.skin
                                      : MColor.xFF838383,
                                  width: 1)),
                              visualDensity: VisualDensity.compact,
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 5)),
                            ),
                            child: Text(
                              model.applyStatus ?? '-',
                              style: MFont.medium14.apply(
                                  color: model.applyStatus !=
                                          LocaleKeys.order_applying.tr
                                      ? MColor.skin
                                      : MColor.xFF838383),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '${model.applyNum ?? 0}人申请',
                          style: MFont.regular13.apply(color: MColor.xFF838383),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
