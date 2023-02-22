import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/memeber_controller.dart';

class MemeberView extends GetView<MemeberController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.group_title.tr),
        centerTitle: true,
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.members.value.length,
          itemBuilder: (ctx, index) {
            return _itemView(index);
          },
        );
      }),
    );
  }

  Widget _itemView(int index) {
    final model = controller.members[index];
    final isFile = File('//${model.user?.avatarThumbPath}').existsSync();
    var name = model.user?.nickname ?? '';
    if (name.isEmpty) {
      name = model.user?.username ?? '';
    }
    if (name.isEmpty) {
      name = '-';
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.toNamed(Routes.CHAT, arguments: model.user!.username);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: MColor.xFFEEEEEE, width: 1)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                color: MColor.xFFEEEEEE,
                width: 50,
                height: 50,
                child: isFile
                    ? Image.file(File('//${model.user?.avatarThumbPath}'))
                    : Container(
                        decoration: BoxDecoration(
                          color: MColor.xFFCCCCCC,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: MFont.medium15.apply(color: MColor.xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
