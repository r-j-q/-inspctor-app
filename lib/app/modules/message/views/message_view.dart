import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/modules/message/controllers/message_controller.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/generated/locales.g.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class IMessageView extends GetView<MessageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.tab_message.tr),
      ),
      body: Obx(() {
        return Container(
          color: Colors.white,
          child: SmartRefresher(
            controller: controller.refreshController,
            onRefresh: () => controller.fetchList(),
            child: ListView.builder(
              itemCount: controller.conversations.isEmpty
                  ? 1
                  : controller.conversations.length,
              itemBuilder: (ctx, index) {
                if (controller.conversations.isEmpty) {
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
                            style:
                                MFont.regular15.apply(color: MColor.xFF666666),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    final model = controller.conversations[index];
                    Get.toNamed(Routes.CHAT, arguments: model.id)
                        ?.then((value) {
                      controller.fetchList();
                    });
                    // Get.toNamed(Routes.CHAT, arguments: model)?.then((value) {
                    //   controller.fetchList();
                    // });
                  },
                  child: _itemView(index),
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _itemView(int index) {
    final model = controller.conversations[index];
    String avatar = '';
    /* if ((model.target is JMUserInfo)) {
      avatar = (model.target as JMUserInfo).avatarThumbPath;
    } else {
      final name = (model.target as JMGroupInfo).name;
      avatar = name.isEmpty ? 'o' : name;
    }
    final unread = model.unreadCount;*/
    final unread = model.unread;
    String text = model.record!["brief"];
    /*if (model.latestMessage is JMTextMessage) {
      text = (model.latestMessage as JMTextMessage).text;
    } else if (model.latestMessage is JMImageMessage) {
      text = '[图片]';
    }

    final isFile = File('//$avatar').existsSync();
    final title = model.title[0];*/
    avatar = model.object_info!["avatar"];
    //final isFile = File('//$avatar').existsSync();
    final isFile = true;

    final title = "234";
    String? datetime = model.datetime;
    Map? object_info = model.object_info;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: isFile
                      ? Image.network(avatar, fit: BoxFit.cover)
                      : Container(
                          decoration: BoxDecoration(
                            color: MColor.xFFCCCCCC,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              title,
                              style:
                                  MFont.semi_Bold15.apply(color: Colors.white),
                            ),
                          ),
                        ),
                ),
                Visibility(
                  visible: unread! > 0,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      child: Center(
                          child: Text("$unread",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, color: MColor.xFFFFFFFF))),
                      width: 16,
                      height: 16,
                      margin: EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: MColor.xFFE95332,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                object_info!["title"],
                                style: MFont.medium15
                                    .apply(color: MColor.xFF333333),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              datetime!,
                              style: MFont.regular15
                                  .apply(color: MColor.xFF999999),
                            ),
                          ],
                        ),
                        Text(
                          text,
                          style: MFont.regular12.apply(color: MColor.xFF999999),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: MColor.xFFEEEEEE,
                    height: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
