import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../controllers/inspection_info_controller.dart';

class InspectionInfoView extends GetView<InspectionInfoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          controller.detailEntity == null
              ? LocaleKeys.publish_title.tr
              : LocaleKeys.publish_edit_title.tr,
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
          SingleChildScrollView(
            child: Container(
              height: Get.height,
              child: Column(
                children: [
                  Spacer(),
                  _bottomView,
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
              height: Get.height - 85,
              child: SafeArea(
                bottom: false,
                child: ListView(
                  children: [
                    _topDateView,
                    _factoryView,
                    _infoView,
                    _priceView,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  get _topDateView {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.only(top: 14, left: 10, right: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (controller.dateList.isEmpty) ...{
              _dateView(-1),
              Divider(thickness: 1, height: 1, color: MColor.xFFE6E6E6),
            } else ...{
              for (int i = 0; i < controller.dateList.length; i++) ...{
                _dateView(i),
                Divider(thickness: 1, height: 1, color: MColor.xFFE6E6E6),
              },
            },
          ],
        );
      }),
    );
  }

  get _factoryView {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.only(top: 14, left: 10, right: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Text(
                  LocaleKeys.publish_inspection_factory.tr,
                  style: MFont.medium16.apply(color: MColor.xFF666666),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Get.toNamed(Routes.ADDRESS, arguments: true)
                          ?.then((value) {
                        if (value == null) {
                          return;
                        }
                        controller.addressId = value['id'];
                        controller.factoryName.value = value['name'];
                        controller.city.value = value['city'];
                        controller.phone.value = value['phone'];
                        controller.email.value = value['email'];
                        controller.person.value = value['person'];
                        controller.address.value = value['address'];
                        controller.fetchVipPrice();
                      });
                    },
                    child: Obx(() {
                      var text = LocaleKeys.publish_factory_tips.tr;
                      var style =
                          MFont.regular15.apply(color: MColor.xFFA2A2A2);
                      if (controller.factoryName.value.isNotEmpty) {
                        text = controller.factoryName.value;
                        style =
                            MFont.semi_Bold17.apply(color: MColor.xFF3D3D3D);
                      }

                      return Container(
                        height: 60,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            text,
                            style: style,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.toNamed(Routes.ADDRESS_LIST)?.then((value) {
                      if (value == null) {
                        return;
                      }
                      controller.addressId = value['id'];
                      controller.factoryName.value = value['name'];
                      controller.city.value = value['city'];
                      controller.phone.value = value['phone'];
                      controller.email.value = value['email'];
                      controller.person.value = value['person'];
                      controller.address.value = value['address'];
                      controller.fetchVipPrice();
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.publish_address_book.tr,
                        style: MFont.regular15.apply(color: MColor.skin),
                      ),
                      SizedBox(width: 4),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.5),
                          border: Border.all(color: MColor.skin),
                        ),
                        width: 15,
                        height: 15,
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: MColor.skin,
                            size: 8,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            if (controller.city.value.isNotEmpty) ...{
              Divider(thickness: 1, height: 1, color: MColor.xFFE6E6E6),
              _cityView(),
            },
            if (controller.person.value.isNotEmpty) ...{
              Divider(thickness: 1, height: 1, color: MColor.xFFE6E6E6),
              _personView(),
            },
            if (controller.phone.value.isNotEmpty) ...{
              Divider(thickness: 1, height: 1, color: MColor.xFFE6E6E6),
              _phoneView(),
            },
            if (controller.email.value.isNotEmpty) ...{
              Divider(thickness: 1, height: 1, color: MColor.xFFE6E6E6),
              _emailView(),
            }
          ],
        );
      }),
    );
  }

  get _topView {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.only(top: 14, left: 10, right: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (controller.dateList.isEmpty) ...{
              _dateView(-1),
              Divider(thickness: 1, height: 1, color: MColor.xFFE6E6E6),
            } else ...{
              for (int i = 0; i < controller.dateList.length; i++) ...{
                _dateView(i),
                Divider(thickness: 1, height: 1, color: MColor.xFFE6E6E6),
              },
            },
            Row(
              children: [
                Text(
                  LocaleKeys.publish_inspection_factory.tr,
                  style: MFont.medium16.apply(color: MColor.xFF666666),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Get.toNamed(Routes.ADDRESS,
                              arguments: controller.addressId)
                          ?.then((value) {
                        if (value == null) {
                          return;
                        }
                        controller.addressId = value['id'];
                        controller.factoryName.value = value['name'];
                        controller.city.value = value['city'];
                        controller.phone.value = value['phone'];
                        controller.email.value = value['email'];
                        controller.person.value = value['person'];
                        controller.address.value = value['address'];
                        controller.fetchVipPrice();
                      });
                    },
                    child: Obx(() {
                      var text = LocaleKeys.publish_factory_tips.tr;
                      var style =
                          MFont.regular15.apply(color: MColor.xFFA2A2A2);
                      if (controller.factoryName.value.isNotEmpty) {
                        text = controller.factoryName.value;
                        style =
                            MFont.semi_Bold17.apply(color: MColor.xFF3D3D3D);
                      }

                      return Container(
                        height: 60,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            text,
                            style: style,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.toNamed(Routes.ADDRESS_LIST)?.then((value) {
                      if (value == null) {
                        return;
                      }
                      controller.addressId = value['id'];
                      controller.factoryName.value = value['name'];
                      controller.city.value = value['city'];
                      controller.phone.value = value['phone'];
                      controller.email.value = value['email'];
                      controller.person.value = value['person'];
                      controller.address.value = value['address'];
                      controller.fetchVipPrice();
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.publish_address_book.tr,
                        style: MFont.regular15.apply(color: MColor.skin),
                      ),
                      SizedBox(width: 4),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.5),
                          border: Border.all(color: MColor.skin),
                        ),
                        width: 15,
                        height: 15,
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: MColor.skin,
                            size: 8,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            if (controller.city.value.isNotEmpty) ...{
              Divider(thickness: 1, height: 1, color: MColor.xFFE6E6E6),
              _cityView(),
            },
            if (controller.person.value.isNotEmpty) ...{
              Divider(thickness: 1, height: 1, color: MColor.xFFE6E6E6),
              _personView(),
            },
            if (controller.phone.value.isNotEmpty) ...{
              Divider(thickness: 1, height: 1, color: MColor.xFFE6E6E6),
              _phoneView(),
            },
            if (controller.email.value.isNotEmpty) ...{
              Divider(thickness: 1, height: 1, color: MColor.xFFE6E6E6),
              _emailView(),
            }
          ],
        );
      }),
    );
  }

  Widget _cityView() {
    return Row(children: [
      Text(
        LocaleKeys.address_area.tr,
        style: MFont.medium16.apply(color: MColor.xFF666666),
      ),
      SizedBox(width: 10),
      Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Obx(() {
            var text = LocaleKeys.publish_factory_tips.tr;
            var style = MFont.regular15.apply(color: MColor.xFFA2A2A2);
            if (controller.city.value.isNotEmpty) {
              text = controller.city.value;
              style = MFont.semi_Bold17.apply(color: MColor.xFF3D3D3D);
            }

            return Container(
              height: 60,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: style,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }),
        ),
      ),
      SizedBox(width: 10),
    ]);
  }

  Widget _emailView() {
    return Row(children: [
      Text(
        LocaleKeys.address_email.tr,
        style: MFont.medium16.apply(color: MColor.xFF666666),
      ),
      SizedBox(width: 10),
      Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Obx(() {
            var text = LocaleKeys.publish_factory_tips.tr;
            var style = MFont.regular15.apply(color: MColor.xFFA2A2A2);
            if (controller.email.value.isNotEmpty) {
              text = controller.email.value;
              style = MFont.semi_Bold17.apply(color: MColor.xFF3D3D3D);
            }

            return Container(
              height: 60,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: style,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }),
        ),
      ),
      SizedBox(width: 10),
    ]);
  }

  Widget _personView() {
    return Row(children: [
      Text(
        LocaleKeys.address_person.tr,
        style: MFont.medium16.apply(color: MColor.xFF666666),
      ),
      SizedBox(width: 10),
      Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Obx(() {
            var text = '';
            var style = MFont.regular15.apply(color: MColor.xFFA2A2A2);
            if (controller.person.value.isNotEmpty) {
              text = controller.person.value;
              style = MFont.semi_Bold17.apply(color: MColor.xFF3D3D3D);
            }

            return Container(
              height: 60,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: style,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }),
        ),
      ),
      SizedBox(width: 10),
    ]);
  }

  Widget _phoneView() {
    return Row(children: [
      Text(
        LocaleKeys.address_mobile.tr,
        style: MFont.medium16.apply(color: MColor.xFF666666),
      ),
      SizedBox(width: 10),
      Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Obx(() {
            var text = '';
            var style = MFont.regular15.apply(color: MColor.xFFA2A2A2);
            if (controller.phone.value.isNotEmpty) {
              text = controller.phone.value;
              style = MFont.semi_Bold17.apply(color: MColor.xFF3D3D3D);
            }

            return Container(
              height: 60,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: style,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }),
        ),
      ),
      SizedBox(width: 10),
    ]);
  }

  Widget _dateView(int index) {
    Map<DateTime, int>? time;
    String text = LocaleKeys.publish_inspection_time_selected.tr;
    TextStyle style = MFont.medium15.apply(color: MColor.xFF999999);
    if (index >= 0) {
      time = controller.dateList.value[index];
      text = formatDate(time.keys.first, [
        yyyy,
        '-',
        mm,
        ''
            '-',
        dd
      ]);
      style = MFont.semi_Bold17.apply(color: MColor.xFF3D3D3D);
    }
    bool isLast = index == controller.dateList.length - 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          LocaleKeys.publish_inspection_time.tr,
          style: MFont.medium16.apply(color: MColor.xFF666666),
        ),
        SizedBox(width: 8),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Get.toNamed(Routes.DATE,
                    arguments: List<Map<DateTime, int>>.from(
                        controller.dateList.value))
                ?.then((value) {
              if (value != null) {
                controller.dateList.value = value;
                controller.dateList.refresh();
              }
            });
          },
          child: Container(
            child: Container(
              height: 60,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 5),
        // if (controller.dateList.isNotEmpty) ...{
        //   GestureDetector(
        //     behavior: HitTestBehavior.translucent,
        //     onTap: () {
        //       if (controller.dateList.value.length == 1) {
        //         controller.dateList.value = [];
        //       } else {
        //         controller.dateList.value.remove(time);
        //         controller.dateList.refresh();
        //       }
        //     },
        //     child: Icon(
        //       Icons.highlight_remove,
        //       color: MColor.skin,
        //       size: 25,
        //     ),
        //   ),
        // },
        Flexible(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _pickerSingle(index);
            },
            child: Container(
              width: 120,
              child: Row(
                children: [
                  Text(
                    LocaleKeys.publish_inspection_people.tr,
                    style: MFont.medium16.apply(color: MColor.xFF666666),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Text(
                          '${time?.values.first ?? ''}',
                          style: MFont.semi_Bold17,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(
                    LocaleKeys.publish_people.tr,
                    style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 5),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (isLast) {
              var now = DateTime.now();
              var nextDay = 1;
              while (true) {
                var exist = false;
                final checkDate = DateTime(now.year, now.month, now.day)
                    .add(Duration(days: nextDay));
                for (var element in controller.dateList.value) {
                  final date = element.keys.first;
                  if (date == checkDate) {
                    exist = true;
                    break;
                  }
                }
                if (!exist) {
                  controller.dateList.add({checkDate: 1});
                  break;
                }
                nextDay++;
              }
            } else {
              controller.dateList.removeAt(index);
            }
            // if (controller.dateList.value.length == 1) {
            //   controller.dateList.value = [];
            // } else {
            //   controller.dateList.value.remove(time);
            //   controller.dateList.refresh();
            // }
          },
          child: Icon(
            isLast ? Icons.add : Icons.highlight_remove,
            color: MColor.skin,
            size: 25,
          ),
        ),
        SizedBox(width: 5),
      ],
    );
  }

  get _infoView {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.only(top: 14, left: 10, right: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                LocaleKeys.publish_goods_name.tr,
                style: MFont.medium16.apply(color: MColor.xFF666666),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  child: _textField(
                      controller.nameController, TextInputType.text,
                      requestNewPrice: false,
                      hint: LocaleKeys.publish_name_tips.tr),
                ),
              ),
            ],
          ),
          Divider(thickness: 1, height: 30, color: MColor.xFFE6E6E6),
          Text(
            LocaleKeys.publish_file_tips.tr,
            style: MFont.medium15.apply(color: MColor.xFF3D3D3D),
          ),
          SizedBox(height: 10),
          Obx(
            () {
              return Visibility(
                visible: controller.picAttachments.isNotEmpty,
                child: Obx(
                  () {
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, position) {
                          return _picAttachmentView(
                              controller.picAttachments[position]);
                        },
                        itemCount: controller.picAttachments.length);
                  },
                ),
              );
            },
          ),
          Obx(
            () {
              return Visibility(
                visible: controller.docAttachments.isNotEmpty,
                child: Obx(
                  () {
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (_, position) {
                          return _docAttachmentView(
                              controller.docAttachments[position]);
                        },
                        itemCount: controller.docAttachments.length);
                  },
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    controller.uploadImage();
                  },
                  child: Container(
                      height: 80,
                      child: _iconTextView(
                        Icons.camera_alt,
                        LocaleKeys.publish_camera.tr,
                        null,
                      )),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    controller.uploadFile();
                  },
                  child: Container(
                      height: 80,
                      child: _iconTextView(
                        Icons.folder,
                        LocaleKeys.publish_file.tr,
                        null,
                      )),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            LocaleKeys.publish_attention.tr,
            style: MFont.medium15.apply(color: MColor.xFF3D3D3D),
          ),
          SizedBox(height: 10),
          _textViewField,
        ],
      ),
    );
  }

  Widget _picAttachmentView(PicAttachment attachment) {
    return attachment.attachmentUrl.isURL
        ? Stack(
            children: [
              _picImageView(attachment.attachmentUrl),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    controller.picAttachments.remove(attachment);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    child: Icon(
                      Icons.close,
                      size: 25,
                      color: MColor.skin,
                    ),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(17.5),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container(
            child: Center(
              child: SpinKitCircle(
                color: MColor.skin,
                size: 40.0,
              ),
            ),
          );
  }

  Widget _picImageView(final url) {
    return Container(
      decoration: BoxDecoration(
        color: MColor.xFFF4F5F7,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            final image = url;
            if (image.isURL) {
              final imageProvider = Image.network(image).image;
              showImageViewer(Get.context!, imageProvider,
                  immersive: false,
                  useSafeArea: true,
                  onViewerDismissed: () {});
            }
          },
          child: Container(
            color: MColor.xFFF4F5F7,
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.fill,
              placeholder: (ctx, _) {
                return Center(
                  child: SpinKitCircle(
                    color: MColor.skin,
                    size: 40.0,
                  ),
                );
              },
              errorWidget: (ctx, a1, a2) {
                return Center(
                  child: Icon(
                    Icons.error,
                    size: 40,
                    color: MColor.skin,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _docAttachmentView(DocAttachment attachment) {
    return attachment.attachmentUrl.isURL
        ? Stack(
            children: [
              _fileView(attachment.attachmentUrl),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    controller.docAttachments.remove(attachment);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    child: Icon(
                      Icons.close,
                      size: 25,
                      color: MColor.skin,
                    ),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(17.5),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container(
            child: Center(
              child: SpinKitCircle(
                color: MColor.skin,
                size: 40.0,
              ),
            ),
          );
  }

  Widget _fileView(final url) {
    final name = url.split('?').last;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (url.isNotEmpty) {
          launchUrlString(url, mode: LaunchMode.externalApplication);
          return;
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 5, left: 12),
        decoration: BoxDecoration(
          color: MColor.xFFEEEEEE,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Center(child: Text(name)),
        ),
      ),
    );
  }

  get _priceView {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.only(top: 14, left: 10, right: 10),
      padding: EdgeInsets.only(top: 10, right: 15, bottom: 10),
      child: Obx(() {
        final rmbPrice = controller.vipEntity.value.rmbPrice ?? '0';
        final usdPrice = controller.vipEntity.value.usdPrice ?? '0';
        final rmbDesc = controller.vipEntity.value.rmbDesc ?? '';
        final usdDesc = controller.vipEntity.value.usdDesc ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                controller.switchAction();
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Text(
                    '${LocaleKeys.publish_click_price.tr} ${controller.isUSD.value ? 'RMB' : 'USD'
                        ''}',
                    style: MFont.regular14.apply(color: MColor.skin),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Radio(
                  value: 2,
                  groupValue: controller.priceType.value,
                  activeColor: MColor.skin,
                  fillColor: MaterialStateProperty.all(MColor.skin),
                  visualDensity: VisualDensity(vertical: -4),
                  onChanged: (value) {
                    controller.priceType.value = 2;
                    controller.fetchOnlyPrice();
                  },
                ),
                Text(
                  LocaleKeys.publish_stand_price.tr,
                  style: MFont.regular16.apply(color: MColor.xFF838383),
                ),
                SizedBox(width: 4),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: MColor.xFFBFBFBF)),
                  ),
                  child: _textField(
                      controller.priceController, TextInputType.number,
                      requestNewPrice: true, prefix: true),
                ),
                SizedBox(width: 10),
              ],
            ),
            Row(
              children: [
                Obx(() {
                  // if (controller.priceType.value == 1) {
                  //   FocusManager.instance.primaryFocus?.unfocus();
                  // }
                  return Radio(
                    value: 1,
                    groupValue: controller.priceType.value,
                    activeColor: MColor.skin,
                    fillColor: MaterialStateProperty.all(MColor.skin),
                    visualDensity: VisualDensity(vertical: -4),
                    onChanged: (value) {
                      controller.fetchVipPrice(isCheck: true);
                    },
                  );
                }),
                Text(
                  LocaleKeys.publish_vip_price.tr,
                  style: MFont.regular16.apply(color: MColor.xFF838383),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Obx(() {
                    return Text(
                      !controller.isUSD.value
                          ? '￥' + rmbPrice
                          : '\$' + usdPrice,
                      style: MFont.medium15.apply(color: MColor.xFF3D3D3D),
                    );
                  }),
                ),
                Text(
                  LocaleKeys.publish_vip_tips.tr,
                  style: MFont.regular14.apply(color: MColor.xFFD9A179),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  get _bottomView {
    return Container(
      padding: EdgeInsets.only(left: 23, right: 23, top: 10, bottom: 26),
      height: 85,
      color: MColor.xFFE95332,
      child: Row(
        children: [
          Text(
            '${LocaleKeys.publish_total.tr} : ',
            style: MFont.medium11.apply(color: Colors.white),
          ),
          Expanded(
            child: Obx(() {
              final text = controller.priceText.value;

              return Text(
                text,
                style: MFont.semi_Bold17.apply(color: Colors.white),
              );
            }),
          ),
          TextButton(
            onPressed: () {
              controller.submitAction();
            },
            child: Text(
              LocaleKeys.publish_submit.tr,
              style: MFont.medium18.apply(color: MColor.xFFE95332),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(StadiumBorder()),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              minimumSize: MaterialStateProperty.all(Size(135, 49)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconTextView(IconData icon, String text, String? path) {
    return Container(
      decoration: BoxDecoration(
        color: MColor.xFFF4F5F7,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black38, size: 20),
          SizedBox(width: 10),
          Text(
            text,
            style: MFont.regular12.apply(color: MColor.xFF838383),
          ),
        ],
      ),
    );
  }

  get _textViewField {
    return TextField(
      controller: controller.editingController,
      style: MFont.regular15.apply(color: MColor.xFF3D3D3D),
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLines: null,
      decoration: InputDecoration(
        hintText: LocaleKeys.publish_attention_tips.tr,
        hintStyle: MFont.regular15.apply(color: MColor.xFFA2A2A2),
        filled: true,
        isDense: false,
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
        controller.content.value = text;
      },
    );
  }

  Widget _textField(
    TextEditingController? editingController,
    TextInputType type, {
    String? hint,
    bool prefix = false,
    bool requestNewPrice = false,
    TextAlign textAlign = TextAlign.start,
    TextStyle style = MFont.regular16,
  }) {
    return Container(
      child: TextField(
        controller: editingController,
        style: style.apply(color: MColor.xFF565656),
        textAlign: textAlign,
        onTap: () {
          if (requestNewPrice) {
            if (controller.priceType.value == 1) {
              controller.fetchOnlyPrice();
            }
            controller.priceType.value = 2;
          }
        },
        keyboardType: type,
        decoration: InputDecoration(
          filled: true,
          isDense: false,
          contentPadding: EdgeInsets.zero,
          hintText: hint,
          hintStyle: style.apply(color: MColor.xFFA2A2A2),
          prefixIcon: prefix
              ? Text(
                  controller.isUSD.value ? '\$' : '￥',
                  style: style.apply(color: MColor.xFF3D3D3D),
                  textAlign: TextAlign.start,
                )
              : null,
          prefixIconConstraints: prefix
              ? BoxConstraints(
                  minWidth: 20,
                )
              : null,
          constraints: BoxConstraints(maxHeight: 30, minHeight: 20),
          fillColor: Colors.white,
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
        onChanged: (text) {
          controller.checkPrice();
          if (requestNewPrice && text.isNotEmpty) {
            controller.delayInputPrice();
          }
        },
      ),
    );
  }

  void _pickerSingle(int index) {
    if (index < 0) {
      showToast(LocaleKeys.publish_date_tips.tr);
      return;
    }
    List<int> data = [];
    for (int i = 0; i < 50; i++) {
      data.add(i + 1);
    }
    return Pickers.showSinglePicker(
      Get.context!,
      data: data,
      pickerStyle: PickerStyle(
        itemOverlay: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
                horizontal: BorderSide(color: MColor.xFF838383)),
          ),
        ),
      ),
      onConfirm: (value, _) {
        final key = controller.dateList.value[index].keys.first;
        controller.dateList.value[index][key] = value;
        controller.dateList.refresh();
      },
    );
  }
}
