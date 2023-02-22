import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/data/bank_entity.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/cash_controller.dart';

class CashView extends GetView<CashController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.cash_title.tr),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              _accountView,
              SizedBox(height: 14),
              _textView,
              SizedBox(height: 22),
              Text(
                LocaleKeys.cash_money.tr,
                style: MFont.regular15.apply(color: MColor.xFF838383),
              ),
              SizedBox(height: 5),
              _textField,
              SizedBox(height: 22),
              for (int i = 0; i < controller.icons.length; i++) ...{
                _iconText(controller.icons[i], controller.titles[i], '', i),
              },
              Spacer(),
              _bottomView,
            ],
          ),
        ),
      ),
    );
  }

  get _accountView {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _pickerSingle();
      },
      child: Row(
        children: [
          Text(
            LocaleKeys.cash_account.tr,
            style: MFont.medium15.apply(color: MColor.xFF838383),
          ),
          Icon(Icons.arrow_drop_down_sharp, size: 24, color: MColor.xFF838383),
        ],
      ),
    );
  }

  get _textView {
    return Obx(() {
      return Text(
          controller.accountType.value == 1 ? LocaleKeys.pay_rmb.tr : LocaleKeys.pay_usd.tr);
    });
  }

  get _textField {
    return Obx(() {
      return TextField(
        controller: controller.textController,
        minLines: 1,
        style: MFont.regular15.apply(color: MColor.xFF333333),
        textAlign: TextAlign.start,
        scrollPadding: EdgeInsets.zero,
        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
        inputFormatters: [PrecisionLimitFormatter(2)],
        decoration: InputDecoration(
          hintText: LocaleKeys.cash_hint.tr,
          hintStyle: MFont.medium16.apply(color: MColor.xFF999999),
          filled: true,
          suffixIcon: Text(
            controller.accountType.value == 1 ? '￥' : '\$',
            style: MFont.regular15.apply(color: MColor.xFF3D3D3D),
          ),
          suffixIconConstraints: BoxConstraints(
            maxWidth: 20,
            minWidth: 20,
          ),
          contentPadding: EdgeInsets.only(left: 10, top: 10),
          constraints: BoxConstraints(minHeight: 44, maxHeight: 44),
          fillColor: MColor.xFFF4F6F9,
          isDense: false,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
        ),
        onChanged: (text) {
          controller.price.value = double.tryParse(text) ?? 0;
        },
      );
    });
  }

  Widget _iconText(String icon, String title, String value, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        //2-PayPai 4-微信 5-支付宝 6银行卡
        if (index == 0) {
          Get.toNamed(Routes.BIND_BANK, arguments: true)?.then((value) {
            if (value != null) {
              controller.type.value = 6;
              controller.bank.value = value;
              controller.accountId.value = 0;
            }
          });
        } else if (index == 1) {
          controller.bank.value = BankEntity();
          controller.type.value = 4;
          controller.accountId.value = 1;
        } else if (index == 2) {
          controller.bank.value = BankEntity();
          controller.type.value = 5;
          controller.accountId.value = 2;
        } else if (index == 3) {
          controller.bank.value = BankEntity();
          controller.type.value = 2;
        }
      },
      child: Obx(() {
        final show = controller.accountType.value == 1 && index < 3 ||
            controller.accountType.value == 2 && index == 3;

        var selected = false;
        //2-PayPai 4-微信 5-支付宝 6银行卡
        if (controller.type.value == 2 && index == 3) {
          selected = true;
        } else if (controller.type.value == 4 && index == 1) {
          selected = true;
        } else if (controller.type.value == 5 && index == 2) {
          selected = true;
        } else if (controller.type.value == 6 && index == 0) {
          selected = true;
        }
        logger.e('ssss ${controller.type} $index');
        return Visibility(
          visible: show,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: MColor.xFFE6E6E6,
                  width: 0.5,
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
                  child: Obx(() {
                    final code = controller.bank.value.bankCode ?? '';
                    return Text(
                      index == 0 ? code : '',
                      style: MFont.medium16.apply(color: MColor.skin),
                      textAlign: TextAlign.right,
                    );
                  }),
                ),
                SizedBox(width: 5),
                Icon(
                  selected ? Icons.radio_button_checked : Icons.radio_button_off,
                  size: 20,
                  color: MColor.skin,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  get _bottomView {
    return Container(
      padding: EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.cash_amount.tr,
                style: MFont.medium12.apply(color: MColor.xFF838383),
              ),
              Obx(() {
                return Text(
                  '${controller.accountType.value == 1 ? '￥' : '\$'}${controller.price}',
                  style: MFont.medium17.apply(color: MColor.xFF333333),
                );
              }),
              Text(
                LocaleKeys.cash_other.tr,
                style: MFont.medium10.apply(color: MColor.xFF838383),
              ),
            ],
          ),
          Spacer(),
          TextButton(
            onPressed: () {
              controller.fetchCsh();
            },
            child: Text(
              LocaleKeys.charge_submit.tr,
              style: MFont.medium15.apply(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(MColor.skin),
              shape: MaterialStateProperty.all(StadiumBorder()),
              minimumSize: MaterialStateProperty.all(Size(200, 40)),
              visualDensity: VisualDensity.compact,
              maximumSize: MaterialStateProperty.all(Size(200, 40)),
            ),
          ),
        ],
      ),
    );
  }

  void _pickerSingle() {
    return Pickers.showSinglePicker(
      Get.context!,
      data: [LocaleKeys.pay_rmb.tr, LocaleKeys.pay_usd.tr],
      pickerStyle: PickerStyle(
        itemOverlay: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide(color: MColor.xFF838383)),
          ),
        ),
      ),
      onConfirm: (value, index) {
        controller.accountType.value = index == 0 ? 1 : 2;
      },
    );
  }
}
