import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/bin_pay_controller.dart';

class BinPayView extends GetView<BinPayController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.bind_title.trArgs([
          controller.type.value == 1
              ? LocaleKeys.wallet_wechat.tr
              : controller.type.value == 2
                  ? LocaleKeys.wallet_alipay.tr
                  : LocaleKeys.pay_paypal.tr,
        ])),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _textView(LocaleKeys.bind_account.tr + ':', 0),
                _textView(LocaleKeys.bind_name.tr + ':', 1),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.bind_image.tr + ':',
                        style: MFont.semi_Bold15.apply(color: MColor.xFF3D3D3D),
                      ),
                      SizedBox(height: 15),
                      _imageView,
                    ],
                  ),
                ),
              ],
            ),
          ),
          _textButton(),
        ],
      ),
    );
  }

  Widget _textView(String title, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            child: Text(
              title,
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
        controller: index == 0 ? controller.editingController1 : controller.editingController2,
        minLines: 1,
        style: MFont.medium16.apply(color: MColor.xFF565656),
        textAlign: TextAlign.start,
        scrollPadding: EdgeInsets.zero,
        decoration: InputDecoration(
          hintText:
              '${LocaleKeys.bind_hint.tr}${index == 0 ? LocaleKeys.bind_account.tr : LocaleKeys.bind_name.tr}',
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

  get _imageView {
    return Obx(() {
      String path = controller.imagePath.value;
      String url = controller.imageUrl.value;

      return Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              controller.uploadImage();
            },
            child: Container(
              height: Get.width / 2,
              width: Get.width / 2,
              child: path.isEmpty
                  ? DottedBorder(
                      borderType: BorderType.RRect,
                      color: MColor.xFFCCCCCC,
                      radius: Radius.circular(6),
                      child: Container(
                        child: Center(
                          child: Icon(
                            Icons.add,
                            size: 20,
                            color: MColor.xFFABABAC,
                          ),
                        ),
                      ),
                    )
                  : url.isURL
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            placeholder: (ctx, a1) {
                              return Center(
                                child: SpinKitCircle(
                                  color: MColor.skin,
                                  size: 40.0,
                                ),
                              );
                            },
                            errorWidget: (ctx, a1, a2) {
                              return Container(
                                child: Icon(
                                  Icons.error,
                                  color: MColor.skin,
                                  size: 60,
                                ),
                              );
                            },
                          ),
                        )
                      : DottedBorder(
                          borderType: BorderType.RRect,
                          color: MColor.xFFCCCCCC,
                          radius: Radius.circular(6),
                          child: Center(
                            child: SpinKitCircle(
                              color: MColor.skin,
                              size: 40.0,
                            ),
                          ),
                        ),
            ),
          ),
          Visibility(
            visible: url.isEmpty ? false : true,
            child: Container(
              height: Get.width / 2,
              width: Get.width / 2,
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    controller.imageUrl.value = '';
                    controller.imagePath.value = '';
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: MColor.xFFCCCCCC.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: 20,
                    height: 20,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _textButton() {
    return Container(
      padding: EdgeInsets.only(left: 22, right: 22, top: 18, bottom: 30),
      child: TextButton(
        onPressed: () {
          controller.fetchBind();
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
