import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/review_controller.dart';

class ReviewView extends GetView<ReviewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.review_title.tr),
        centerTitle: true,
      ),
      backgroundColor: MColor.xFFEEEEEE,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _scoreView,
                _textViewField,
                _cardView([
                  Text(
                    LocaleKeys.review_picture.tr,
                    style: MFont.semi_Bold15.apply(color: MColor.xFF3D3D3D),
                  ),
                  SizedBox(height: 12),
                  Obx(() {
                    final paths = controller.picturesPaths;
                    final urls = controller.picturesUrls;

                    return Wrap(
                      runSpacing: 12,
                      spacing: 12,
                      children: [
                        for (int i = 0; i < urls.length; i++) ...{
                          _imageView(i, paths[i], urls[i]),
                        },
                      ],
                    );
                  }),
                ]),
              ],
            ),
          ),
          _textButton(LocaleKeys.review_submit.tr, action: () {
            controller.saveComment();
          }),
        ],
      ),
    );
  }

  get _scoreView {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.review_score.tr,
            style: MFont.medium15.apply(color: MColor.xFF3D3D3D),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _checkView(0),
              SizedBox(width: 5),
              _checkView(1),
              SizedBox(width: 5),
              _checkView(2),
              SizedBox(width: 5),
              _checkView(3),
              SizedBox(width: 5),
              _checkView(4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _checkView(int index) {
    return Obx(() {
      final selectedIndex = controller.scoreIndex.value;
      var text = LocaleKeys.review_score1.tr;
      if (index == 1) {
        text = LocaleKeys.review_score2.tr;
      } else if (index == 2) {
        text = LocaleKeys.review_score3.tr;
      } else if (index == 3) {
        text = LocaleKeys.review_score4.tr;
      } else if (index == 4) {
        text = LocaleKeys.review_score5.tr;
      }
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.scoreIndex.value = index;
        },
        child: Row(
          children: [
            Icon(
              selectedIndex == index ? Icons.radio_button_checked : Icons.radio_button_off,
              color: MColor.skin,
              size: 20,
            ),
            // SizedBox(width: 5),
            Text(
              text,
              style: MFont.regular13.apply(color: MColor.xFF3D3D3D),
            ),
          ],
        ),
      );
    });
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
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              controller.uploadImage(false, index);
            },
            child: Container(
              width: (Get.width - 72) / 2,
              height: 100,
              child: path.isEmpty
                  ? DottedBorder(
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
                    )
                  : url.isURL
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            File(path),
                            fit: BoxFit.cover,
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
        ),
        Visibility(
          visible: url.isEmpty ? false : true,
          child: Container(
            width: (Get.width - 72) / 2,
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
      ],
    );
  }

  get _textViewField {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: controller.editingController,
        style: MFont.regular15.apply(color: MColor.xFF3D3D3D),
        keyboardType: TextInputType.multiline,
        minLines: 5,
        maxLines: null,
        decoration: InputDecoration(
          hintText: LocaleKeys.review_tips.tr,
          hintMaxLines: 2,
          hintStyle: MFont.regular15.apply(color: MColor.xFFA2A2A2),
          filled: true,
          isDense: false,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          fillColor: Colors.white,
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
      ),
    );
  }

  Widget _textButton(String title, {@required VoidCallback? action}) {
    return Container(
      padding: EdgeInsets.only(left: 22, right: 22, top: 18, bottom: 30),
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
