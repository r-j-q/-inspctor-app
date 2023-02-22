import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/generated/locales.g.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../controllers/check_controller.dart';

class CheckView extends GetView<CheckController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.check_title.tr),
        centerTitle: true,
      ),
      backgroundColor: MColor.xFFF4F5F7,
      body: Obx(() {
        final status = controller.status.value;

        return Column(
          children: [
            Obx(() {
              final status = controller.status.value;
              if (status <= 0) {
                return Container();
              }
              return Container(
                height: 40,
                width: double.infinity,
                child: Center(
                  child: Text(
                    status == 1 || status == 5
                        ? LocaleKeys.check_checking.tr
                        : status == 2
                            ? LocaleKeys.check_check_success.tr
                            : LocaleKeys.check_check_failed.tr,
                    style: MFont.semi_Bold15
                        .apply(color: status == 2 ? MColor.xFF25C56F : MColor.skin),
                  ),
                ),
                color: MColor.xFFEEEEEE,
              );
            }),
            Expanded(
              child: ListView(
                children: [
                  _cardView([
                    Text(
                      LocaleKeys.check_picture.tr,
                      style: MFont.semi_Bold15.apply(color: MColor.xFF3D3D3D),
                    ),
                    SizedBox(height: 12),
                    Obx(() {
                      final paths = controller.picturesPaths;
                      final urls = controller.picturesUrls;

                      return Column(
                        children: [
                          for (int i = 0; i < urls.length; i++) ...{
                            _imageView(i, paths[i], urls[i]),
                          },
                        ],
                      );
                    }),
                  ]),
                  _cardView([
                    Text(
                      LocaleKeys.check_report.tr,
                      style: MFont.semi_Bold15.apply(color: MColor.xFF3D3D3D),
                    ),
                    SizedBox(height: 12),
                    Obx(() {
                      final url = controller.reportUrl.value;
                      final path = controller.reportPath.value;

                      return _reportView(path, url);
                    }),
                  ]),
                  _cardView([
                    Text(
                      LocaleKeys.check_file.tr,
                      style: MFont.semi_Bold15.apply(color: MColor.xFF3D3D3D),
                    ),
                    SizedBox(height: 12),
                    Obx(() {
                      final url = controller.fileUrl.value;
                      final path = controller.filePath.value;

                      return _fileView(path, url);
                    }),
                  ]),
                ],
              ),
            ),
            Obx(() {
              final status = controller.status.value;
              if (status == 2) {
                return Container();
              }
              return _textButton(LocaleKeys.check_submit.tr, action: () {
                controller.saveReport();
              });
            }),
            SizedBox(height: 30),
          ],
        );
      }),
    );
  }

  Widget _cardView(List<Widget> itemViews) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: EdgeInsets.only(left: 16, right: 16, top: 10),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: itemViews,
      ),
    );
  }

  Widget _imageView(int index, String path, String url) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  final status = controller.status.value;
                  if (status == 2) {
                    if (url.isURL) {
                      final imageProvider = Image.network(url).image;
                      showImageViewer(
                        Get.context!,
                        imageProvider,
                        onViewerDismissed: () {
                          print("dismissed");
                        },
                        immersive: false,
                        useSafeArea: true,
                      );
                    }
                  } else {
                    controller.uploadImage(false, index);
                  }
                },
                child: Container(
                  width: 70,
                  height: 70,
                  child: url.isURL
                      ? _netImageView(url)
                      : path.isNotEmpty
                          ? _circleView
                          : _addView,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: IgnorePointer(
                  ignoring: controller.status.value == 2,
                  child: _textViewField(index),
                ),
              ),
            ],
          ),
        ),
        if (controller.status.value != 2) ...{
          Visibility(
            visible: url.isEmpty ? false : true,
            child: Container(
              width: 70,
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    controller.deleteImage(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: MColor.xFFCCCCCC,
                    ),
                  ),
                ),
              ),
            ),
          ),
        },
      ],
    );
  }

  get _addView {
    return DottedBorder(
      borderType: BorderType.RRect,
      color: MColor.xFFCCCCCC,
      radius: Radius.circular(6),
      child: Container(
        child: Center(
          child: Icon(
            Icons.add,
            size: 48,
            color: MColor.xFFABABAC,
          ),
        ),
      ),
    );
  }

  get _circleView {
    return DottedBorder(
      borderType: BorderType.RRect,
      color: MColor.xFFCCCCCC,
      radius: Radius.circular(6),
      child: Center(
        child: SpinKitCircle(
          color: MColor.skin,
          size: 40.0,
        ),
      ),
    );
  }

  Widget _netImageView(String url) {
    return DottedBorder(
      borderType: BorderType.RRect,
      color: MColor.xFFCCCCCC,
      radius: Radius.circular(6),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (ctx, a1) {
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
              color: MColor.xFFCCCCCC,
            ),
          );
        },
      ),
    );
  }

  Widget _textViewField(int index) {
    return TextField(
      controller: controller.textControllers[index],
      style: MFont.regular15.apply(color: MColor.xFF3D3D3D),
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: LocaleKeys.check_hint.tr,
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
    );
  }

  Widget _reportView(String path, String url) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (controller.status.value == 2) {
              if (url.isURL) {
                final imageProvider = Image.network(url).image;
                showImageViewer(
                  Get.context!,
                  imageProvider,
                  onViewerDismissed: () {
                    print("dismissed");
                  },
                  immersive: false,
                  useSafeArea: true,
                );
              }
            } else {
              controller.uploadImage(true, 0);
            }
          },
          child: Container(
            height: 100,
            width: Get.width / 2,
            child: url.isURL
                ? _netImageView(url)
                : path.isNotEmpty
                    ? _circleView
                    : _addView,
          ),
        ),
        if (controller.status.value != 2) ...{
          Visibility(
            visible: url.isEmpty ? false : true,
            child: Container(
              height: 100,
              width: Get.width / 2,
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    controller.deleteReport();
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
        },
      ],
    );
  }

  Widget _fileView(String path, String url) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (url.isNotEmpty) {
              launchUrlString(url, mode: LaunchMode.externalApplication);
              return;
            }
            controller.uploadFile();
          },
          child: Container(
            height: 30,
            child: url.isURL
                ? DottedBorder(
                    borderType: BorderType.RRect,
                    color: MColor.xFFCCCCCC,
                    radius: Radius.circular(6),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Text(url.split('?').last),
                      ),
                    ),
                  )
                : path.isNotEmpty
                    ? _circleView
                    : DottedBorder(
                        borderType: BorderType.RRect,
                        color: MColor.xFFCCCCCC,
                        radius: Radius.circular(6),
                        child: Container(
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 24,
                              color: MColor.xFFABABAC,
                            ),
                          ),
                        ),
                      ),
          ),
        ),
        if (controller.status.value != 2) ...{
          Visibility(
            visible: url.isEmpty ? false : true,
            child: Container(
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    controller.deleteFile();
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
        },
      ],
    );
  }

  Widget _textButton(String title, {@required VoidCallback? action}) {
    return Container(
      padding: EdgeInsets.only(left: 22, right: 22, top: 18),
      child: TextButton(
        onPressed: () {
          action!();
        },
        child: Text(
          title,
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
