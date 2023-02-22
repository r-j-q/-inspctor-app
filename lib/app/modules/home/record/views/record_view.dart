import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/modules/home/controllers/home_controller.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/generated/assets.dart';
import 'package:inspector/generated/locales.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../controllers/record_controller.dart';

class RecordView extends GetView<RecordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.home_record.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        return SmartRefresher(
            controller: controller.refreshController,
            onRefresh: () => controller.refreshAction(),
            onLoading: () => controller.loadMore(),
            child: ListView.builder(
              itemCount: controller.dataList.value.isEmpty
                  ? 1
                  : controller.dataList.value.length,
              itemBuilder: (ctx, index) {
                if (controller.dataList.isEmpty) {
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
                            style:
                                MFont.regular15.apply(color: MColor.xFF666666),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return _itemView(index);
              },
            ));
      }),
    );
  }

  Widget _itemView(int index) {
    final model = controller.dataList[index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.toNamed(Routes.LIST_DETAIL,
            arguments: model.id, parameters: {'isApply': '1'})?.then((value) {
          controller.fetchRecordList(false);
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 12, right: 12, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 16, left: 12),
                  child: Row(
                    children: [
                      Text(
                        model.provinceCity ?? '-',
                        style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
                      ),
                      SizedBox(width: 4),
                      Offstage(
                        offstage:
                            model.distance == null || model.distance!.isEmpty,
                        child: Icon(
                          Icons.location_on_sharp,
                          color: MColor.xFF838383,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 4),
                      Offstage(
                        offstage:
                            model.distance == null || model.distance!.isEmpty,
                        child: Text(
                          '${model.distance}',
                          style: MFont.regular13.apply(color: MColor.xFF838383),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Offstage(
                  offstage: model.award == null,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Assets.imagesRmbIcon)),
                    ),
                    width: 133,
                    height: 27,
                    child: Center(
                      child: Text(
                        LocaleKeys.home_recommend.trArgs([model.award ?? '']),
                        style: MFont.medium12.apply(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
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
                  Container(color: MColor.xFFDDDDDD, width: 1, height: 24),
                  Text(
                    model.type ?? '-',
                    style: MFont.regular13.apply(color: MColor.xFF838383),
                  ),
                  Container(color: MColor.xFFDDDDDD, width: 1, height: 24),
                  Text(
                    LocaleKeys.home_unit.trArgs(
                        ['${model.inspNumber ?? 0}', '${model.inspDay ?? 0}']),
                    style: MFont.regular13.apply(color: MColor.xFF838383),
                  ),
                  Container(color: MColor.xFFDDDDDD, width: 1, height: 24),
                  Text(
                    model.reportType ?? '-',
                    style: MFont.regular13.apply(color: MColor.xFF838383),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 12, right: 12, top: 2, bottom: 4),
              child: Row(
                children: [
                  Text(
                    '${LocaleKeys.home_product_tip.tr}：',
                    style: MFont.regular13.apply(color: MColor.xFF838383),
                  ),
                  Expanded(
                    child: Text(
                      model.productName ?? '-',
                      style: MFont.regular13.apply(color: MColor.xFF565656),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8),
                  UnconstrainedBox(
                    child: TextButton(
                      onPressed: () {
                        Get.find<HomeController>()
                            .fetchPrice(model.id ?? 0, false);
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(StadiumBorder()),
                        side: MaterialStateProperty.all(
                            BorderSide(color: MColor.skin, width: 1)),
                        visualDensity: VisualDensity.compact,
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 24, vertical: 5)),
                      ),
                      child: Text(
                        model.applyStatus ?? '-',
                        style: MFont.medium14.apply(color: MColor.skin),
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
      ),
    );
  }
}
