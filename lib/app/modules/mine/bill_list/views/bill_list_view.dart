import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/bill_list_controller.dart';

class BillListView extends GetView<BillListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.bill_title.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        final rmbOut = controller.billInfo.value.rmbExpenditureAccount ?? 0;
        final rmbIn = controller.billInfo.value.rmbIncomeAccount ?? 0;
        final usdOut = controller.billInfo.value.usaExpenditureAccount ?? 0;
        final usdIn = controller.billInfo.value.usaIncomeAccount ?? 0;
        final capitalModelList =
            controller.billInfo.value.capitalModelList ?? [];

        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: MColor.xFFE6E6E6, width: 0.5),
                  ),
                ),
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _pickerDate();
                      },
                      child: Text.rich(
                        TextSpan(
                          text: controller.month.value.month.toString(),
                          style: MFont.medium30.apply(color: MColor.xFF3D3D3D),
                          children: [
                            TextSpan(
                              text: LocaleKeys.bill_month.tr,
                              style:
                                  MFont.medium13.apply(color: MColor.xFF3D3D3D),
                            ),
                            WidgetSpan(
                                child: Icon(
                              Icons.arrow_drop_down_sharp,
                              size: 30,
                              color: MColor.xFF3D3D3D,
                            )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      '${LocaleKeys.bill_out.tr}￥$rmbOut  ${LocaleKeys.bill_in.tr}￥$rmbIn',
                      style: MFont.medium13.apply(color: MColor.xFF3D3D3D),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${LocaleKeys.bill_out.tr}\$$usdOut  ${LocaleKeys.bill_in.tr}\$$usdIn',
                      style: MFont.medium13.apply(color: MColor.xFF3D3D3D),
                    ),
                    SizedBox(height: 5),
                    Text(
                      LocaleKeys.bill_fenxi.tr,
                      style: MFont.medium13.apply(color: MColor.xFF3D3D3D),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    itemCount:
                        capitalModelList.isEmpty ? 1 : capitalModelList.length,
                    itemBuilder: (ctx, index) {
                      if (capitalModelList.isEmpty) {
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
                      return _itemView(index);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _itemView(int index) {
    final model = controller.billInfo.value.capitalModelList?[index];
    final isAdd = model?.type == 1 ? true : false;
    final isRMB = model?.userAccount == 1 ? true : false;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: MColor.xFFE6E6E6, width: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    model?.title?.fixAutoLines() ?? '-',
                    style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    model?.time ?? '-',
                    style: MFont.medium13.apply(color: MColor.xFF838383),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            '${isAdd ? '+' : '-'}${isRMB ? '￥' : '\$'} ${model?.account ?? '0'}',
            style: MFont.medium16
                .apply(color: isAdd ? MColor.skin : MColor.xFF40A900),
          ),
        ],
      ),
    );
  }

  void _pickerDate() {
    return Pickers.showDatePicker(
      Get.context!,
      mode: DateMode.YM,
      pickerStyle: PickerStyle(
        itemOverlay: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
                horizontal: BorderSide(color: MColor.xFF838383)),
          ),
        ),
      ),
      onConfirm: (value) {
        final time = DateTime(value.year!, value.month!);
        controller.takeTime(time);
      },
    );
  }
}
