import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/const_provider.dart';
import 'package:inspector/app/data/address_entity.dart';
import 'package:inspector/app/data/baidu_ocr_entity.dart';
import 'package:inspector/app/modules/auth/mine_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/json/base/json_convert_content.dart';
import 'package:inspector/generated/locales.g.dart';

class AddressController extends GetxController {
  TextEditingController editingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  ConstProvider provider = ConstProvider();
  MineProvider mProvider = MineProvider();
  final GlobalKey<FormState> formKey = GlobalKey();
  List<String> titles = [
    LocaleKeys.address_name.tr,
    LocaleKeys.address_person.tr,
    LocaleKeys.address_mobile.tr,
    LocaleKeys.address_email.tr,
    LocaleKeys.address_area.tr,
    LocaleKeys.address_detail.tr
  ];
  List<String> placeHolds = [
    LocaleKeys.address_name_tip.tr,
    LocaleKeys.address_person_tip.tr,
    LocaleKeys.address_mobile_tip.tr,
    LocaleKeys.address_email_tip.tr,
    LocaleKeys.address_area_tip.tr,
    LocaleKeys.address_detail_tip.tr
  ];
  String province = '';
  String city = '';
  String area = '';
  double lat = 0;
  double lng = 0;
  final isSave = true.obs;
  final pasteText = ''.obs;
  final addressList = <AddressRows>[].obs;
  final showList = true.obs;
  int? addressId;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is AddressRows) {
      final info = Get.arguments as AddressRows;
      addressId = info.id;
      setInfo(info);
    } else if (Get.arguments is int) {
      addressId = Get.arguments;
      fetchAddressList();
    } else {
      showList.value = Get.arguments ?? true;
      if (showList.value) {
        fetchAddressList();
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  void fetchOCR(String text) {
    provider.takeBdAddress(text).then((value) {
      if (value['error_msg'] != null) {
        showToast(value['error_msg']);
      } else {
        final data = JsonConvert.fromJsonAsT<BaiduOcrEntity>(value);
        province = data?.province ?? '';
        city = data?.city ?? '';
        area = data?.county ?? '';
        lat = data?.lat ?? 0;
        lng = data?.lng ?? 0;
        controllers[1].text = data?.person ?? '';
        controllers[2].text = data?.phonenum ?? '';
        controllers[4].text = '$province$city$area'.fixAutoLines();
        controllers[5].text = (data?.detail ?? '').fixAutoLines();
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }).catchError((error) {
      showToast(error.toString());
    });
  }

  Future<bool> fetchLocation() {
    final fullAddress = controllers[4].text + controllers[5].text;
    return Location.share.fetchLocation(fullAddress).then((value) {
      final location = value.geocodes?.first.location?.split(',');
      if (location != null) {
        lng = double.tryParse(location.first) ?? 0;
        lat = double.tryParse(location.last) ?? 0;
        return true;
      } else {
        showToast('请核对地址后重新操作');
      }
      return false;
    }).catchError((e) {
      showToast('服务异常');
      return true;
    });
  }

  void fetchSaveAddress() async {
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.trim().isEmpty) {
        if (i != 3 && i != 5 && i != 1 && i != 0) {
          showToast(titles[i]);
          return;
        }
      }
    }

    if (controllers[5].text.isNotEmpty) {
      await fetchLocation();
    }

    EasyLoading.show();
    mProvider
        .addressSave(
            controllers[0].text,
            controllers[1].text,
            controllers[2].text,
            controllers[3].text,
            province,
            city,
            area,
            controllers[5].text,
            lat,
            lng,
            addressId)
        .then((value) {
      if (value.isSuccess) {
        if (addressId != null) {
          Get.back(result: {
            'id': addressId!,
            'name': controllers[0].text.trim(),
            'city': province + city + area,
            'phone': controllers[2].text.trim(),
            'email': controllers[3].text.trim(),
            'person': controllers[1].text.trim(),
            'address': controllers[5].text.trim()
          });
        } else {
          Get.back(result: {
            'id': value.data['id'],
            'name': controllers[0].text.trim(),
            'city': province + city + area,
            'phone': controllers[2].text.trim(),
            'email': controllers[3].text.trim(),
            'person': controllers[1].text.trim(),
            'address': controllers[5].text.trim()
          });
        }
      }
      showToast(value.message ?? '');
    }).catchError((error) {
      showToast(error.toString());
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void fetchAddressList() {
    mProvider.addressList(0, showList.value ? 500 : 10).then((value) {
      if (value.isSuccess) {
        addressList.value = value.data?.rows ?? [];
        final info =
            addressList.firstWhereOrNull((element) => element.id == addressId);
        setInfo(info);
      }
    });
  }

  void setInfo(AddressRows? info) {
    if (info != null) {
      controllers[0].text = info.factoryName ?? '';
      controllers[1].text = info.name ?? '';
      controllers[2].text = info.phone ?? '';
      controllers[3].text = info.email ?? '';
      lat = info.lat ?? 0;
      lng = info.lon ?? 0;
      province = info.province ?? '';
      city = info.city ?? '';
      area = info.area ?? '';
      controllers[4].text = province + city + area;
      controllers[5].text = info.address ?? '';
    }
  }

  @override
  void onClose() {}

  @override
  void dispose() {
    editingController.dispose();
    focusNode.dispose();
    controllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }
}
