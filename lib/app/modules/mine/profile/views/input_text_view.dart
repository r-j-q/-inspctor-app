import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/generated/locales.g.dart';

class InputTextView extends GetView {
  final String title;
  final TextInputType type;
  final String? placeHolder;
  final TextEditingController editingController = TextEditingController();
  InputTextView(this.title, this.type, {this.placeHolder});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Get.back();
          },
          child: Container(),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(left: 40, right: 40, bottom: 150),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: MFont.medium16.apply(color: MColor.xFF333333),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _textField,
                SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            StadiumBorder(side: BorderSide(color: MColor.skin)),
                          ),
                        ),
                        child: Text(
                          LocaleKeys.public_cancel.tr,
                          style: MFont.medium15.apply(color: MColor.skin),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Get.back(result: editingController.text);
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(StadiumBorder()),
                          backgroundColor: MaterialStateProperty.all(MColor.skin),
                        ),
                        child: Text(
                          LocaleKeys.public_ok.tr,
                          style: MFont.medium15.apply(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  get _textField {
    return TextField(
      controller: editingController,
      style: MFont.regular15.apply(color: MColor.xFF565656),
      textAlign: TextAlign.center,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: placeHolder ?? title,
        hintStyle: MFont.regular15.apply(color: MColor.xFF9A9B9C),
        filled: true,
        isDense: false,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        constraints: BoxConstraints(maxHeight: 40, minHeight: 35),
        fillColor: Colors.white,
        border: OutlineInputBorder(borderSide: BorderSide(color: MColor.xFFA4A5A9_80)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MColor.xFFA4A5A9_80)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: MColor.xFFA4A5A9_80)),
      ),
    );
  }
}
