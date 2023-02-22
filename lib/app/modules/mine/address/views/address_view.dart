import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/data/address_entity.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/address_controller.dart';

class AddressView extends GetView<AddressController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          LocaleKeys.address_title.tr,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.6],
                colors: [MColor.xFFE95332, MColor.xFFEEEEEE],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: ListView(
                children: [
                  _autoView,
                  _infoView,
                  Obx(() {
                    if (controller.addressList.value.isNotEmpty &&
                        controller.showList.value) {
                      return _addressView;
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  get _autoView {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 5, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: _textViewField,
    );
  }

  get _textViewField {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
        padding: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: MColor.xFFF4F5F7,
        ),
        child: TextField(
          controller: controller.editingController,
          style: MFont.regular15.apply(color: MColor.xFF565656),
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: null,
          decoration: InputDecoration(
            hintText: LocaleKeys.address_auto_tips.tr,
            hintMaxLines: 3,
            hintStyle: MFont.regular15.apply(color: MColor.xFFA2A2A2),
            hintTextDirection: TextDirection.ltr,
            filled: true,
            isDense: false,
            counter: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (controller.pasteText.value.isNotEmpty) {
                  controller.fetchOCR(controller.editingController.text);
                }
              },
              child: Obx(() {
                return Text(
                  controller.pasteText.value.isEmpty
                      ? LocaleKeys.address_paste.tr
                      : LocaleKeys.address_ocr.tr,
                  style: MFont.medium15.apply(color: MColor.skin),
                );
              }),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            fillColor: MColor.xFFF4F5F7,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: MColor.xFFF4F5F7),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: MColor.xFFF4F5F7),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: MColor.xFFF4F5F7),
            ),
          ),
          onChanged: (text) {
            controller.pasteText.value = text;
          },
        ),
      ),
    );
  }

  get _infoView {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          for (int i = 0; i < controller.titles.length; i++) ...{
            _textView(i, controller.titles[i], controller.placeHolds[i]),
          },
          _nextView,
        ],
      ),
    );
  }

  Widget _textView(int index, String title, String tips) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: MColor.xFFE6E6E6, width: 0.5))),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 84,
            child: index != 3 && index != 5 && index != 1 && index != 0
                ? RichText(
                    text: TextSpan(
                      text: '*',
                      style: MFont.medium15.apply(color: MColor.skin),
                      children: [
                        WidgetSpan(child: SizedBox(width: 10)),
                        TextSpan(
                          text: title,
                          style: MFont.medium15.apply(color: MColor.xFF3D3D3D),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  )
                : Text(
                    title,
                    style: MFont.medium15.apply(color: MColor.xFF3D3D3D),
                    textAlign: TextAlign.right,
                  ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (index == 4) {
                  _pickerAddress();
                }
              },
              child: TextField(
                focusNode: index == 5 ? controller.focusNode : null,
                controller: controller.controllers[index],
                keyboardType: index == 2
                    ? TextInputType.phone
                    : index == 3
                        ? TextInputType.emailAddress
                        : index == 5
                            ? TextInputType.multiline
                            : TextInputType.text,
                minLines: 1,
                maxLines: null,
                style: MFont.medium15.apply(color: MColor.xFF565656),
                textAlign: TextAlign.start,
                scrollPadding: EdgeInsets.zero,
                enabled: index == 4 ? false : true,
                decoration: InputDecoration(
                  hintText: tips,
                  hintStyle: MFont.medium15.apply(color: MColor.xFFD7D9DD),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  get _nextView {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                StadiumBorder(side: BorderSide(color: MColor.xFFD7A17C)),
              ),
              minimumSize: MaterialStateProperty.all(Size(126, 35)),
            ),
            onPressed: () {
              controller.controllers.forEach((element) {
                element.text = '';
              });
              controller.province = '';
              controller.city = '';
              controller.area = '';
              controller.lat = 0;
              controller.lng = 0;
            },
            child: Text(
              LocaleKeys.address_clear.tr,
              style: MFont.medium15.apply(color: MColor.xFFD7A17C),
            ),
          ),
          SizedBox(width: 23),
          TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                StadiumBorder(side: BorderSide(color: MColor.xFFD7A17C)),
              ),
              minimumSize: MaterialStateProperty.all(Size(126, 35)),
              backgroundColor: MaterialStateProperty.all(MColor.xFFD7A17C),
            ),
            onPressed: () {
              controller.fetchSaveAddress();
            },
            child: Text(
              LocaleKeys.address_submit.tr,
              style: MFont.medium15.apply(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _pickerAddress() {
    return Pickers.showAddressPicker(
      Get.context!,
      pickerStyle: PickerStyle(
        itemOverlay: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
                horizontal: BorderSide(color: MColor.xFF838383)),
          ),
        ),
      ),
      initTown: '',
      addAllItem: false,
      onConfirm: (province, city, area) {
        controller.province = province;
        controller.city = city;
        controller.area = area ?? '';
        controller.controllers[4].text = '$province$city$area';
        controller.focusNode.requestFocus();
      },
    );
  }

  get _addressView {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: controller.addressList.length <= 2
            ? controller.addressList.length + 1
            : 4,
        itemBuilder: (ctx, index) {
          if (index == 0) {
            return Row(
              children: [
                Text(
                  LocaleKeys.address_recent.tr,
                  style: MFont.medium13.apply(color: MColor.xFFA2A2A2),
                ),
                Spacer(),
                if (controller.addressList.length > 2) ...{
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Get.toNamed(Routes.ADDRESS_LIST)?.then((value) {
                        if (value == null) {
                          return;
                        }
                        Get.back(result: value);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        LocaleKeys.address_more.tr,
                        style: MFont.medium13.apply(color: MColor.xFF3D3D3D),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                },
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: MColor.xFF3D3D3D,
                ),
              ],
            );
          } else if (index <= controller.addressList.length && index < 3) {
            return _addressItem(index - 1);
          }

          return Container();
        },
      ),
    );
  }

  Widget _addressItem(int index) {
    AddressRows address = controller.addressList[index];
    final name = address.name ?? '';
    var phone = address.phone ?? '';
    final province = address.province ?? '';
    final city = address.city ?? '';
    final area = address.area ?? '';
    final detail = address.address ?? '';
    final factory = address.factoryName ?? '';
    final text = province + '-' + city + '-' + area + '-' + detail;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.back(result: {
          'id': address.id,
          'name': address.factoryName,
          'city': (address.province ?? '') +
              (address.city ?? '') +
              (address.area ?? ''),
          'phone': address.phone,
          'email': address.email,
          'person': address.name,
          'address': address.address
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          border: controller.addressList.length <= 2
              ? null
              : Border(bottom: BorderSide(color: MColor.xFFE6E6E6, width: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name + ' ' + phone,
              style: MFont.semi_Bold13.apply(color: MColor.xFF3D3D3D),
            ),
            SizedBox(height: 4),
            Text(
              text.fixAutoLines(),
              style: MFont.medium13.apply(color: MColor.xFF3D3D3D),
            ),
            SizedBox(height: 4),
            Text(
              '${LocaleKeys.address_name.tr}: $factory',
              style: MFont.medium13.apply(color: MColor.xFF3D3D3D),
            ),
          ],
        ),
      ),
    );
  }
}
