import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/generated/assets.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/apply_controller.dart';

class ApplyView extends GetView<ApplyController> {
  //0: 未提交 1:未审核 2：已审核  3:审核被拒
  var checkStatus = GlobalConst.userModel?.checkStatus ?? 0;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(LocaleKeys.apply_title.tr),
        centerTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: Get.height - media.padding.top - kToolbarHeight,
                child: Column(
                  children: [
                    Spacer(),
                    _nextButton,
                  ],
                ),
              ),
            ),
            Container(
              height: Get.height - media.padding.top - kToolbarHeight - 84,
              child: Column(
                children: [
                  if (checkStatus > 0) ...{
                    Container(
                      height: 40,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          checkStatus == 1
                              ? LocaleKeys.apply_checking.tr
                              : checkStatus == 2
                                  ? LocaleKeys.apply_check_success.tr
                                  : LocaleKeys.apply_check_failed.tr,
                          style: MFont.semi_Bold15.apply(
                              color: checkStatus == 2
                                  ? MColor.xFF25C56F
                                  : MColor.skin),
                        ),
                      ),
                      color: MColor.xFFEEEEEE,
                    ),
                  },
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        if (index == 5) {
                          return _inputFiled(index);
                        } else if (index == 6) {
                          return IgnorePointer(
                            ignoring: checkStatus == 2,
                            child: _inputFiled(index),
                          );
                        }
                        if (index < controller.titles.length) {
                          return _itemView(index, () {
                            if (index == 0) {
                            } else if (index == 1) {
                              _pickerSingle(index, ['男', '女']);
                            } else if (index == 2) {
                              _pickerDate(index);
                            } else if (index == 3) {
                              _pickerSingle(index, [
                                '小学',
                                '初中',
                                '中专',
                                '高中',
                                '大专',
                                '本科',
                                '硕士',
                                '博士'
                              ]);
                            } else if (index == 4) {
                              _pickerAddress(index);
                            } else if (index == 5) {
                            } else if (index == 6) {}
                          });
                        } else if (index == 7) {
                          return _shebaoView;
                        } else if (index == 8) {
                          return _contentView;
                        } else if (index == 9) {
                          return _resumeView;
                        } else {
                          return IgnorePointer(
                            ignoring: checkStatus == 2,
                            child: _cardView,
                          );
                        }
                      },
                      separatorBuilder: (ctx, index) {
                        if (index == 8) {
                          return Container();
                        }
                        return Visibility(
                          visible: index < 3 ? false : true,
                          child: Divider(
                            thickness: index == 7 ? 10 : 0.5,
                            color: index == 7
                                ? MColor.xFFF4F5F7
                                : MColor.xFFE6E6E6,
                            indent: index == 7 ? 0 : 16,
                            height: index == 7 ? 10 : 0.5,
                          ),
                        );
                      },
                      itemCount: controller.titles.length + 4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemView(int index, VoidCallback action) {
    return Visibility(
      visible: index < 3 ? false : true,
      child: InkWell(
        onTap: () => action(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Text(
                controller.titles[index],
                style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Obx(() {
                  final change = controller.valueChange.value;
                  return Text(
                    controller.values[index],
                    style: MFont.medium16.apply(color: MColor.xFF838383),
                    maxLines: 1,
                    textAlign: TextAlign.right,
                  );
                }),
              ),
              Icon(
                Icons.keyboard_arrow_right_outlined,
                size: 24,
                color: MColor.xFFBBBBBB,
              ),
            ],
          ),
        ),
      ),
    );
  }

  get _shebaoView {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Obx(() {
        return Row(
          children: [
            Expanded(
              child: Text(
                LocaleKeys.apply_shebao.tr,
                style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                controller.shebao.value = false;
              },
              child: Container(
                height: 40,
                child: Row(
                  children: [
                    Icon(
                      controller.shebao.value
                          ? Icons.radio_button_off
                          : Icons.radio_button_on,
                      color: MColor.skin,
                    ),
                    Text(
                      '无',
                      style: MFont.medium16.apply(color: MColor.xFF333333),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                controller.shebao.value = true;
              },
              child: Container(
                height: 40,
                child: Row(
                  children: [
                    Icon(
                      !controller.shebao.value
                          ? Icons.radio_button_off
                          : Icons.radio_button_on,
                      color: MColor.skin,
                    ),
                    Text(
                      '有',
                      style: MFont.medium16.apply(color: MColor.xFF333333),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _inputFiled(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Obx(() {
        final isUsd = controller.accountType.value == 1 ? false : true;
        return Row(
          children: [
            Text(
              '* ',
              style: MFont.medium16.apply(color: MColor.skin),
            ),
            Text(
              controller.titles[index],
              style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 40,
                child: TextField(
                  controller: index == 5
                      ? controller.editingController1
                      : controller.editingController2,
                  minLines: 1,
                  style: MFont.medium16.apply(color: MColor.xFF565656),
                  textAlign: TextAlign.end,
                  scrollPadding: EdgeInsets.zero,
                  keyboardType: index == 5
                      ? TextInputType.numberWithOptions(
                          decimal: true, signed: true)
                      : TextInputType.datetime,
                  decoration: InputDecoration(
                    hintText:
                        '${LocaleKeys.bind_hint.tr}${controller.titles[index]}',
                    hintStyle: MFont.medium16.apply(color: MColor.xFF999999),
                    filled: true,
                    fillColor: Colors.transparent,
                    isDense: false,
                    focusedBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  onChanged: (text) {
                    controller.values.value[index] = text;
                  },
                ),
              ),
            ),
            if (index == 5) ...{
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  controller.accountType.value = 1;
                },
                child: Container(
                  height: 40,
                  child: Row(
                    children: [
                      Icon(
                        isUsd ? Icons.radio_button_off : Icons.radio_button_on,
                        color: MColor.skin,
                      ),
                      Text(
                        '￥',
                        style: MFont.medium16.apply(color: MColor.xFF333333),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  controller.accountType.value = 2;
                },
                child: Container(
                  height: 40,
                  child: Row(
                    children: [
                      Icon(
                        !isUsd ? Icons.radio_button_off : Icons.radio_button_on,
                        color: MColor.skin,
                      ),
                      Text(
                        '\$',
                        style: MFont.medium16.apply(color: MColor.xFF333333),
                      ),
                    ],
                  ),
                ),
              ),
            },
          ],
        );
      }),
    );
  }

  get _contentView {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.apply_file.tr,
            style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
          ),
          SizedBox(height: 10),
          _textViewField,
        ],
      ),
    );
  }

  get _resumeView {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          LocaleKeys.apply_upload_file.tr,
          style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
        ),
        SizedBox(height: 10),
        _resumeUploadView(),
      ]),
    );
  }

  get _textViewField {
    return TextField(
      controller: controller.editingController,
      style: MFont.regular15.apply(color: MColor.xFF565656),
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLines: null,
      decoration: InputDecoration(
        hintText: LocaleKeys.apply_file_tip.tr,
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

  get _cardView {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '',
            style: MFont.medium16.apply(color: MColor.skin),
          ),
          Text.rich(
            TextSpan(
                text: '* ',
                style: MFont.medium16.apply(color: MColor.skin),
                children: [
                  TextSpan(
                    text: LocaleKeys.apply_upload_card.tr,
                    style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
                  )
                ]),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _cardImageView(true)),
              SizedBox(width: 10),
              Expanded(child: _cardImageView(false)),
            ],
          )
        ],
      ),
    );
  }

  Widget _resumeUploadView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.only(top: 14, left: 10, right: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Obx(
        () {
          return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (_, position) {
                if (position == controller.resumes.length) {
                  return _plusView;
                } else {
                  return _resumeItemView(
                      position, controller.resumes[position]);
                }
              },
              itemCount: controller.resumes.length + 1);
        },
      ),
    );
  }

  Widget _resumeItemView(int position, ResumeInfo resume) {
    return GestureDetector(
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    Assets.imagesProductNote,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(children: [
                Positioned.fill(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (resume.type == ResumeType.pic &&
                            resume.resumeUrl.isURL) ...{
                          CachedNetworkImage(
                            imageUrl: resume.resumeUrl,
                            fit: BoxFit.cover,
                            placeholder: (ctx, _) {
                              return Container(
                                child: Center(
                                  child: SpinKitCircle(
                                    color: MColor.skin,
                                    size: 40.0,
                                  ),
                                ),
                              );
                            },
                            errorWidget: (ctx, a1, a2) {
                              return Container(
                                child: Center(
                                  child: Icon(
                                    Icons.link_off,
                                    size: 40,
                                    color: MColor.skin,
                                  ),
                                ),
                              );
                            },
                          )
                        } else if (resume.type == ResumeType.doc) ...{
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle,
                                size: 26,
                                color: MColor.skin,
                              ),
                              SizedBox(height: 10),
                              Text(
                                LocaleKeys.apply_card_back.tr,
                                style: MFont.regular12
                                    .apply(color: MColor.xFF3D3D3D),
                              ),
                            ],
                          )
                        } else ...{
                          Container(
                            child: Center(
                              child: SpinKitCircle(
                                color: MColor.skin,
                                size: 40.0,
                              ),
                            ),
                          )
                        }
                      ]),
                ),
                Positioned(
                  child: GestureDetector(
                      onTap: () {
                        controller.deleteResume(position);
                      },
                      child: Icon(
                        Icons.highlight_remove,
                        color: MColor.skin,
                        size: 25,
                      )),
                  top: 0,
                  right: 0,
                ),
              ])),
        ),
      ),
    );
  }

  get _plusView {
    return GestureDetector(
        onTap: () {
          Pickers.showSinglePicker(
            Get.context!,
            data: ["上传图片", "上传文件"],
            pickerStyle: PickerStyle(
              itemOverlay: Container(
                decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(color: MColor.xFF838383)),
                ),
              ),
            ),
            onConfirm: (value, index) {
              controller.uploadResume(index == 0);
            },
          );
        },
        child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(6),
            ),
            margin: EdgeInsets.only(top: 14),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle,
                  size: 26,
                  color: MColor.skin,
                ),
                SizedBox(height: 10),
                Text(
                  LocaleKeys.apply_upload_file.tr,
                  style: MFont.regular12.apply(color: MColor.xFF3D3D3D),
                ),
              ],
            )
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage(
            //       Assets.imagesAddTask,
            //     ),
            //     fit: BoxFit.fill,
            //   ),
            // ),
            ));
  }

  Widget _cardImageView(bool front) {
    return GestureDetector(
      onTap: () {
        controller.uploadIdCardImage(front, cropWidth: 155, cropHeight: 96);
      },
      child: AspectRatio(
        aspectRatio: 155.0 / 96,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  front ? Assets.imagesAcrdFront : Assets.imagesCardBack,
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: Obx(() {
              var url = '';
              if (front) {
                url = controller.cardFrontUrl.value;
              } else {
                url = controller.cardBackUrl.value;
              }
              if (url.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle,
                      size: 26,
                      color: front ? MColor.xFF838383 : MColor.skin,
                    ),
                    SizedBox(height: 10),
                    Text(
                      front
                          ? LocaleKeys.apply_card_front.tr
                          : LocaleKeys.apply_card_back.tr,
                      style: MFont.regular12.apply(color: MColor.xFF3D3D3D),
                    ),
                  ],
                );
              } else if (url.isURL) {
                return CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (ctx, _) {
                    return Container(
                      child: Center(
                        child: SpinKitCircle(
                          color: MColor.skin,
                          size: 40.0,
                        ),
                      ),
                    );
                  },
                  errorWidget: (ctx, a1, a2) {
                    return Container(
                      child: Center(
                        child: Icon(
                          Icons.link_off,
                          size: 40,
                          color: MColor.skin,
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container(
                  child: Center(
                    child: SpinKitCircle(
                      color: MColor.skin,
                      size: 40.0,
                    ),
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  get _nextButton {
    var text = LocaleKeys.home_update.tr;
    if (checkStatus == 0) {
      text = LocaleKeys.apply_submit.tr;
    }
    return Container(
      margin: EdgeInsets.only(left: 23, right: 23, bottom: 25, top: 10),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(StadiumBorder()),
          backgroundColor: MaterialStateProperty.all(MColor.skin),
          minimumSize: MaterialStateProperty.all(Size(double.infinity, 49)),
        ),
        onPressed: () {
          controller.fetchApply();
        },
        child: Text(
          text,
          style: MFont.medium18.apply(color: Colors.white),
        ),
      ),
    );
  }

  void _pickerSingle(int index, List<String> data) {
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
        controller.values[index] = value;
      },
    );
  }

  void _pickerDate(int index) {
    return Pickers.showDatePicker(
      Get.context!,
      pickerStyle: PickerStyle(
        itemOverlay: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
                horizontal: BorderSide(color: MColor.xFF838383)),
          ),
        ),
      ),
      onConfirm: (value) {
        controller.values[index] =
            '${value.year.toString()}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
      },
    );
  }

  void _pickerAddress(int index) {
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
        controller.province.value = province;
        controller.city.value = city;
        controller.area.value = area ?? '';
        controller.values[index] = '$province$city$area';
      },
    );
  }
}
