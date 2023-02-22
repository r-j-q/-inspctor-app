import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:inspector/app/data/order_detail_entity.dart';
import 'package:inspector/app/data/order_input_entity.dart';
import 'package:inspector/app/data/vip_price_entity.dart';
import 'package:inspector/app/modules/auth/mine_provider.dart';
import 'package:inspector/app/modules/mine/profile/views/input_text_view.dart';
import 'package:inspector/app/modules/order/controllers/order_controller.dart';
import 'package:inspector/app/modules/order/order_list/controllers/order_list_controller.dart';
import 'package:inspector/app/modules/pulish/publish_provider.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/public_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

class InspectionInfoController extends GetxController {
  TextEditingController editingController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController recommendTextController = TextEditingController();
  PublishProvider provider = PublishProvider();
  OrderDetailEntity? detailEntity;
  MineProvider mineProvider = MineProvider();

  Timer? _delayTimer;

  int type = 1;
  final dateList = <Map<DateTime, int>>[
    {
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(Duration(days: 1)): 1
    }
  ].obs;
  var peopleNum = 1;
  var goodsName = '';
  final picAttachments = RxList<PicAttachment>([]);
  final docAttachments = RxList<DocAttachment>([]);
  var content = ''.obs;
  var price = '';
  final priceText = ''.obs;
  int? addressId;
  int? orderId;
  String? orderNo;
  final city = ''.obs;
  final factoryName = ''.obs;
  final phone = ''.obs;
  final person = ''.obs;
  final email = ''.obs;
  final address = ''.obs;
  double? huilv;
  final isUSD = false.obs;
  //1-vip 2-一口价
  final priceType = 1.obs;
  final isOnly = false.obs;
  final vipEntity = VipPriceEntity().obs;
  var isUpdate = false;
  int payStatus = 1;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is int) {
      type = Get.arguments;
    } else if (Get.arguments is OrderDetailEntity) {
      detailEntity = Get.arguments;
      dateList.value = detailEntity?.timeBeans?.map((e) {
            final date = DateUtil.getDateTime(e.date!, isUtc: true)!;
            final number = e.inspectNum ?? 1;
            return {date: number};
          }).toList() ??
          [];
      orderId = detailEntity?.orderId;
      orderNo = detailEntity?.orderNo;
      addressId = detailEntity?.addressId ?? 0;
      factoryName.value = detailEntity?.factoryName ?? '';
      goodsName = detailEntity?.productName ?? '';
      nameController.text = goodsName;
      payStatus = detailEntity?.status ?? 1;
      city.value = detailEntity?.city ?? '';
      type = detailEntity?.inspectType ?? 1;
      priceType.value = detailEntity?.priceType ?? 0;
      if (priceType.value == 2) {
        priceController.text = detailEntity?.price.toString() ?? '';
      }
      isUSD.value = detailEntity?.userAccount == 2;
      // TODO
      // pictureUrl.value = detailEntity?.imageFile ?? '';
      // if (pictureUrl.value.isNotEmpty) {
      //   picturePath.value = 'x';
      // }
      // fileUrl.value = detailEntity?.file ?? '';
      // if (fileUrl.value.isNotEmpty) {
      //   filePath.value = 'x';
      // }
      content.value = detailEntity?.remark ?? '';
      editingController.text = content.value;
      price = detailEntity?.price.toString() ?? '0';
      final userAccount = detailEntity?.userAccount ?? 1;
      isUSD.value = userAccount == 2 ? true : false;
      checkPrice();
      isUpdate = true;
    }
    // fetchVipPrice();
  }

  @override
  void onReady() {
    dateList.listen((p0) {
      checkPrice();
      if (dateList.isNotEmpty && city.isNotEmpty) {
        fetchVipPrice();
      }
    });

    super.onReady();
  }

  void uploadImage() {
    FilesPicker.openImage(true, enableCrop: false).then((value) {
      // FilesPicker.openCamera().then((value) {
      if (value == null || value.isEmpty) {
        return;
      }
      EasyLoading.show();
      PublicProvider.uploadImages(value, UploadType.plain).then((url) {
        if (url == null || value.isEmpty) {
          showToast(LocaleKeys.profile_info_failed.tr);
          // picturePath.value = '';
          return;
        }
        final attachment = PicAttachment();
        attachment.attchmentPath = value;
        attachment.attachmentUrl = url;
        picAttachments.add(attachment);
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    });
  }

  void uploadFile() {
    FilesPicker.openFile().then((value) {
      if (value == null || value.isEmpty) {
        return;
      }
      EasyLoading.show();
      PublicProvider.uploadImages(value, UploadType.resume).then((url) {
        if (url == null || value.isEmpty) {
          showToast(LocaleKeys.profile_info_failed.tr);
          return;
        }
        final attachment = DocAttachment();
        attachment.attchmentPath = value;
        attachment.attachmentUrl = url;
        docAttachments.add(attachment);
      }).whenComplete(() {
        EasyLoading.dismiss();
      });
    });
  }

  void fetchRecommend(String email) {
    EasyLoading.show();
    mineProvider.takeRecommend(email).then((value) async {
      if (value.code == 20000) {
        Get.back();
        if (value.message != null && value.message!.isNotEmpty) {
          showCustomDialog(value.message!);
        }
      } else {
        recommendTextController.clear();
        showToast(value.message ?? '');
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void fetchOnlyPrice() {
    EasyLoading.show();
    provider.onlyPrice().then((value) {
      if (value.isSuccess) {
        isOnly.value = value.data?.isAuto ?? false;
        huilv = NumUtil.getDoubleByValueStr(value.data?.huiLv ?? '0');
        if (isOnly.value) {
          showCustomDialog(value.data?.text ?? '',
              cancel: true,
              dismissWhenConfirm: false,
              textPlaceHolder: '请输入被推荐人邮箱或手机号',
              textController: recommendTextController,
              textInputType: TextInputType.emailAddress,
              okTitle: "推荐", onConfirm: () {
            final email = recommendTextController.text;
            if (email.isNotEmpty) {
              fetchRecommend(email);
            } else {
              showToast('请输入正确的邮箱地址或手机号');
            }
          }, onCancel: () {
            priceType.value = 1;
            FocusManager.instance.primaryFocus?.unfocus();
          });
          return;
        }
        priceType.value = 2;
        checkPrice();
      } else {
        showToast(value.message ?? '');
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void fetchVipPrice({bool isCheck = false}) {
    if (dateList.isEmpty) {
      showToast(LocaleKeys.publish_inspection_time.tr);
      return;
    }
    peopleNum = 0;
    for (var element in dateList.value) {
      final num = element.values.first;
      peopleNum += num;
    }

    if (peopleNum <= 0) {
      showToast(LocaleKeys.publish_inspection_people.tr);
      return;
    }

    EasyLoading.show();
    provider
        .vipPrice(dateList.length, city.value, peopleNum, type)
        .then((value) {
      if (value.isSuccess) {
        vipEntity.value = value.data ?? VipPriceEntity();
        if (isCheck) {
          priceType.value = 1;
        }
        checkPrice();
      } else {
        showToast(value.message ?? '');
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void submitAction() {
    if (dateList.isEmpty) {
      showToast(LocaleKeys.publish_inspection_time.tr);
      return;
    }
    peopleNum = 0;
    for (var element in dateList.value) {
      final num = element.values.first;
      peopleNum += num;
    }
    if (peopleNum <= 0) {
      showToast(LocaleKeys.publish_inspection_people.tr);
      return;
    }
    if (addressId == 0 || addressId == null) {
      showToast(LocaleKeys.publish_factory_tip.tr);
      return;
    }

    if (!isUpdate) {
      if (priceType.value == 0 || price.isEmpty) {
        showToast(LocaleKeys.publish_price_tip.tr);
        return;
      }
    }

    List<Map<String, dynamic>> dates = [];
    for (int i = 0; i < dateList.value.length; i++) {
      Map<String, dynamic> dict = {
        'date': dateList.value[i].keys.first.toIso8601String()
      };
      dict['inspectNum'] = dateList.value[i].values.first;
      dates.add(dict);
    }

    OrderInputEntity entity = OrderInputEntity();
    entity.inspectType = type;
    entity.payText = priceText.value;
    entity.isUSD = isUSD.value;
    entity.price = NumUtil.getNumByValueStr(price, fractionDigits: 2);

    List<String> fileUrls = [];
    for (DocAttachment attachment in docAttachments) {
      if (attachment.attachmentUrl.isNotEmpty) {
        fileUrls.add(attachment.attachmentUrl);
      }
    }
    List<String> picUrls = [];
    for (PicAttachment attachment in picAttachments) {
      if (attachment.attachmentUrl.isNotEmpty) {
        picUrls.add(attachment.attachmentUrl);
      }
    }
    EasyLoading.show();
    provider
        .submitOrder(
      addressId!,
      dates,
      fileUrls,
      picUrls,
      type,
      NumUtil.getNumByValueStr(price, fractionDigits: 2)!,
      nameController.text,
      content.value,
      isUSD.value ? 2 : 1,
      priceType.value,
      orderId: orderId,
    )
        .then((value) {
      if (value.isSuccess) {
        var oId = orderId;
        var oNo = orderNo;
        if (!isUpdate) {
          oId = value.data['orderId'];
          orderId = oId;
          oNo = value.data['orderNumber'];
          orderNo = oNo;
        }

        if (payStatus > 1) {
          Get.back();
          return;
        }
        Get.toNamed(Routes.PAY, arguments: {
          'usd': isUSD.value,
          'id': oNo!,
          'price': entity.price
        })?.then((value) {
          isUpdate = true;
          if (value != null) {
            payStatus = 2;
            Get.back(result: true);
          }
          // Get.find<OrderController>().pageTabController?.animateTo(0);
          // Get.find<OrderListController>().refreshAction();
        });
        FocusManager.instance.primaryFocus?.unfocus();
      } else {
        showToast(value.message ?? '');
      }
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void switchAction() {
    if (huilv == null) {
      fetchOnlyPrice();
    }

    final text = priceController.text.trim();
    if (text.isNotEmpty) {
      double money = double.tryParse(text) ?? 0;
      if (isUSD.value) {
        money = money * huilv!;
      } else {
        money = money / huilv!;
      }
      priceController.text =
          NumUtil.getNumByValueStr('$money', fractionDigits: 2)
                  ?.toStringAsFixed(2) ??
              '0';
      priceController.selection = TextSelection.fromPosition(
          TextPosition(offset: priceController.text.length));
    }
    isUSD.value = !isUSD.value;
    checkPrice();
  }

  void checkPrice() {
    final type = priceType.value;
    var text = isUSD.value ? '\$' : '￥';
    if (type == 2) {
      price = priceController.text;
    } else if (type == 1) {
      if (!isUSD.value) {
        price = (vipEntity.value.rmbPrice ?? '');
      } else {
        price = (vipEntity.value.usdPrice ?? '');
      }
    } else {
      price = '0';
    }
    priceText.value = text + price;
  }

  void delayInputPrice() {
    _delayTimer?.cancel();
    if (priceType.value == 1) {
      _delayTimer = Timer(Duration(seconds: 1), () {
        fetchOnlyPrice();
      });
    }
  }

  @override
  void onClose() {}

  @override
  void dispose() {
    editingController.dispose();
    priceController.dispose();
    nameController.dispose();
    _delayTimer?.cancel();
    super.dispose();
  }
}

class PicAttachment {
  String attachmentUrl = '';
  String attchmentPath = '';
}

class DocAttachment {
  String attachmentUrl = '';
  String attchmentPath = '';
}
