import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/add_bank_controller.dart';

class AddBankView extends GetView<AddBankController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.add_bank_title.tr),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                for (int i = 0; i < controller.titles.length; i++) ...{
                  _textView(i),
                },
              ],
            ),
          ),
          _textButton(),
        ],
      ),
    );
  }

  Widget _textView(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              controller.titles[index],
              style: MFont.semi_Bold15.apply(color: MColor.xFF3D3D3D),
            ),
          ),
          _textField(index),
        ],
      ),
    );
  }

  Widget _textField(int index) {
    return Container(
      child: TextField(
        controller: controller.textControllers[index],
        minLines: 1,
        style: MFont.medium16.apply(color: MColor.xFF565656),
        textAlign: TextAlign.start,
        scrollPadding: EdgeInsets.zero,
        decoration: InputDecoration(
          hintText: '${LocaleKeys.bind_hint.tr}${controller.titles[index]}',
          hintStyle: MFont.medium16.apply(color: MColor.xFF999999),
          filled: true,
          contentPadding: EdgeInsets.only(bottom: 0, top: 10),
          // constraints: BoxConstraints(minHeight: 30, maxHeight: 30),
          fillColor: Colors.white,
          isDense: false,
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: MColor.skin, width: 1)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: MColor.xFF9A9B9C, width: 1)),
        ),
      ),
    );
  }

  Widget _textButton() {
    return Container(
      padding: EdgeInsets.only(left: 22, right: 22, top: 18, bottom: 30),
      child: TextButton(
        onPressed: () {
          controller.fetchAddBank();
        },
        child: Text(
          LocaleKeys.publish_submit.tr,
          style: MFont.medium18.apply(color: Colors.white),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(MColor.skin),
          shape: MaterialStateProperty.all(StadiumBorder()),
          minimumSize: MaterialStateProperty.all(Size(double.infinity, 49)),
          visualDensity: VisualDensity.compact,
          maximumSize: MaterialStateProperty.all(Size(double.infinity, 49)),
        ),
      ),
    );
  }
}
