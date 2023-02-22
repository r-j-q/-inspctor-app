import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/data/address_entity.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/address_list_controller.dart';

class AddressListView extends GetView<AddressListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.address_list_title.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.addressList.isEmpty
                    ? 1
                    : controller.addressList.length,
                itemBuilder: (ctx, index) {
                  if (controller.addressList.isEmpty) {
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
                  return _addressItem(index);
                },
              ),
            ),
            _textButton,
          ],
        );
      }),
    );
  }

  Widget _addressItem(int index) {
    AddressRows address = controller.addressList[index];
    final name = address.name ?? '';
    var phone = address.phone ?? '';
    // phone = phone.replaceRange(3, 7, '****');
    final province = address.province ?? '';
    final city = address.city ?? '';
    final area = address.area ?? '';
    final factory = address.factoryName ?? '';
    final detail = address.address ?? '';
    final text = province + '-' + city + '-' + area + '-' + detail;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Slidable.of(Get.context!)?.close();
        if (controller.isManager) {
          Get.toNamed(Routes.ADDRESS, arguments: address)?.then((value) {
            controller.fetchAddressList();
          });
          return;
        }
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
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          border: controller.addressList.length <= 1
              ? null
              : Border(bottom: BorderSide(color: MColor.xFFE6E6E6, width: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name + ' ' + phone,
                    style: MFont.semi_Bold13.apply(color: MColor.xFF3D3D3D),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.toNamed(Routes.ADDRESS, arguments: address)
                        ?.then((value) {
                      controller.fetchAddressList();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.edit_location_outlined,
                      size: 25,
                      color: MColor.xFF333333,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    showCustomDialog(LocaleKeys.address_delete_tips.tr,
                        onConfirm: () {
                      controller.fetchAddressDelete(address.id ?? 0);
                    }, cancel: true);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.delete_forever_sharp,
                      size: 25,
                      color: MColor.xFF333333,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              text.fixAutoLines(),
              style: MFont.medium13.apply(color: MColor.xFF3D3D3D),
            ),
            SizedBox(height: 6),
            Text(
              '${LocaleKeys.address_name.tr}: $factory',
              style: MFont.medium13.apply(color: MColor.xFF3D3D3D),
            ),
          ],
        ),
      ),
    );
  }

  get _textButton {
    return Container(
      padding: EdgeInsets.only(left: 22, right: 22, top: 18, bottom: 30),
      child: TextButton(
        onPressed: () {
          Get.toNamed(Routes.ADDRESS, arguments: false)?.then((value) {
            controller.fetchAddressList();
          });
        },
        child: Text(
          LocaleKeys.address_insert.tr,
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
