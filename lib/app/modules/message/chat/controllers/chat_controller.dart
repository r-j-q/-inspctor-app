import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:inspector/app/modules/message/jmessage.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/modules/message/chat_provider.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

class ChatController extends GetxController {
  ChatProvider provider = ChatProvider();
  final messages = <types.Message>[].obs;
  types.User? mineUser;
  types.User? otherUser;
  JMConversationInfo? conversation;
  String? userId;
  final title = '消息'.obs;
  String? groupId;
  int offset = 0;
  int conversation_id = 0;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is int) {
      conversation_id = Get.arguments;
    }
    final uid = GlobalConst.userModel?.uid ?? 0;
    final head = GlobalConst.userModel?.head ?? '';
    mineUser = types.User(id: 'user$uid', imageUrl: head);
    fetchList();
    /* if (Get.arguments is JMConversationInfo) {
      conversation = Get.arguments;
      title.value = conversation?.title ?? '消息';
    }
    if (Get.arguments is String) {
      userId = Get.arguments;
      title.value = userId ?? '消息';
    }
    groupId = Get.parameters['gid'];
    final name = Get.parameters['name'];
    if (name != null) {
      title.value = name;
    }

    final uid = GlobalConst.userModel?.uid ?? 0;
    final head = GlobalConst.userModel?.head ?? '';
    mineUser = types.User(id: 'user$uid', imageUrl: head);

    fetchList();*/
  }

  void fetchList() {
    provider.takeChatMsg(conversation_id, 1, 50).then((value) async {
      groupId = value.data["conversation"]["object_id"];
      userId = value.data["conversation"]["object_id"];
      title.value = value.data["conversation"]["object_info"]["title"];
      value.data["list"].forEach((element) {
        messages.add(element);
      });
    }).whenComplete(() {});
  }

  void fetchListb() {
    String tid = userId ?? '-';
    JMConversationType type = JMConversationType.single;
    if (conversation != null) {
      if (conversation?.conversationType == JMConversationType.single) {
        tid = (conversation?.target as JMUserInfo).username;
      } else if (conversation?.conversationType == JMConversationType.group) {
        tid = (conversation?.target as JMGroupInfo).id;
        type = JMConversationType.group;
      }
    } else if (groupId != null) {
      tid = groupId!;
      type = JMConversationType.group;
    }

    JMessage.share.messageList(type, tid, offset).then((value) {
      value.reversed.forEach((element) {
        if (element is JMEventMessage) {
          final user = types.User(
              id: element.from.username,
              imageUrl: element.from.avatarThumbPath);
          final msg = types.TextMessage(
              author: user, id: element.id, text: element.eventType.name);
          messages.add(msg);
        } else if (element is JMTextMessage) {
          final user = types.User(
              id: element.from.username,
              imageUrl: element.from.avatarThumbPath);
          final msg = types.TextMessage(
              author: user, id: element.id, text: element.text);
          messages.add(msg);
        } else if (element is JMImageMessage) {
          final user = types.User(
              id: element.from.username,
              imageUrl: element.from.avatarThumbPath);
          final msg = types.ImageMessage(
            author: user,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: element.id,
            name: element.thumbPath.split('/').last,
            size: 100,
            uri: element.thumbPath,
          );
          messages.add(msg);
        }
        JMessage.share.readAll(conversation, userId, groupId);
        messages.refresh();
      });
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
