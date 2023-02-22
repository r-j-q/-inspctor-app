import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/bind_bank_controller.dart';

class BindBankView extends GetView<BindBankController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.bank_title.tr),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.bankList.length,
                itemBuilder: (ctx, index) {
                  return _cardView(index);
                },
              );
            }),
          ),
          _nextButton,
        ],
      ),
    );
  }

  Widget _cardView(int index) {
    final bank = controller.bankList[index];
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        dragDismissible: false,
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            onPressed: (_) {
              controller.fetchDeleteBank(bank.id ?? 0);
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: LocaleKeys.address_delete.tr,
          ),
        ],
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (controller.needCheck) {
            Get.back(result: bank);
          }
        },
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          padding: EdgeInsets.only(left: 22, right: 22, top: 20, bottom: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [MColor.xFFD95F66, MColor.xFFEA6A46]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bank.bankName ?? '-',
                style: MFont.medium18.apply(color: Colors.white),
              ),
              SizedBox(height: 3),
              Text(
                '储蓄卡',
                style: MFont.regular12.apply(color: Colors.white),
              ),
              SizedBox(height: 11),
              Text(
                bank.bankCode ?? '-',
                style: MFont.medium18.apply(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  get _nextButton {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.toNamed(Routes.ADD_BANK)?.then((value) {
          controller.fetchBankList();
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 23, right: 23, top: 10, bottom: 37),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: MColor.xFFCFCFCF, offset: Offset(0, 1), blurRadius: 6)],
        ),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 20,
              color: MColor.xFF000000,
            ),
            SizedBox(width: 4),
            Text(
              LocaleKeys.bank_add.tr,
              style: MFont.medium18.apply(color: MColor.xFF333333),
            ),
          ],
        ),
      ),
    );
  }
}
