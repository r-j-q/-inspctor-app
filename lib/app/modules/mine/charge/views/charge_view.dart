import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/generated/assets.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/charge_controller.dart';

class ChargeView extends GetView<ChargeController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.charge_title.tr),
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
                LocaleKeys.charge_money.tr,
                style: MFont.regular15.apply(color: MColor.xFF838383),
              ),
              SizedBox(height: 5),
              _textField,
              SizedBox(height: 22),
              _payItemView,
              Spacer(),
              _textButton(),
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
            LocaleKeys.charge_account.tr,
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
        controller.accountType.value == 1 ? LocaleKeys.pay_rmb.tr : LocaleKeys.pay_usd.tr,
        style: MFont.medium16.apply(color: MColor.xFF333333),
      );
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
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: LocaleKeys.charge_hint.tr,
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
      );
    });
  }

  get _payItemView {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Obx(() {
            return Image.asset(
              controller.accountType.value == 1 ? Assets.imagesZhifubao : Assets.imagesPaypalIcon,
              width: 30,
              height: 30,
            );
          }),
          SizedBox(width: 4),
          Obx(() {
            return Text(
              controller.accountType.value == 1 ? LocaleKeys.pay_zfb.tr : LocaleKeys.pay_paypal.tr,
              style: MFont.medium15.apply(
                color: MColor.xFF333333,
              ),
            );
          }),
          Spacer(),
          Icon(
            Icons.radio_button_checked,
            size: 20,
            color: MColor.skin,
          ),
        ],
      ),
    );
  }

  Widget _textButton() {
    return Container(
      padding: EdgeInsets.only(bottom: 30),
      child: TextButton(
        onPressed: () {
          controller.fetchCharge();
        },
        child: Text(
          LocaleKeys.charge_submit.tr,
          style: MFont.medium15.apply(color: Colors.white),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(MColor.skin),
          shape: MaterialStateProperty.all(StadiumBorder()),
          minimumSize: MaterialStateProperty.all(Size(double.infinity, 40)),
          visualDensity: VisualDensity.compact,
          maximumSize: MaterialStateProperty.all(Size(double.infinity, 40)),
        ),
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
        controller.payType = index == 0 ? 3 : 2;
      },
    );
  }
}
