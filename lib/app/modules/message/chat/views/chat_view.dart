import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/modules/message/jmessage.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView {
  String? page = 'group';
  ChatView() {
    if (Get.arguments is String) {
      page = 'singe';
    }
    Get.put(ChatController(), tag: page);
  }

  @override
  ChatController get controller {
    return Get.find<ChatController>(tag: page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title.value),
        centerTitle: true,
        actions: [
          if (controller.conversation?.conversationType ==
                  JMConversationType.group ||
              controller.groupId != null) ...{
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (controller.groupId != null) {
                  Get.toNamed(Routes.MEMEBER, arguments: controller.groupId);
                } else {
                  final info = controller.conversation?.target as JMGroupInfo;
                  Get.toNamed(Routes.MEMEBER, arguments: info.id);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.group,
                  size: 25,
                  color: MColor.xFF333333,
                ),
              ),
            ),
          },
        ],
      ),
      body: Obx(() {
        return Chat(
          theme: DefaultChatTheme(
            inputBackgroundColor: Colors.white,
            sendButtonIcon: Icon(
              Icons.send,
              color: Colors.black,
            ),
            attachmentButtonIcon: Icon(
              Icons.image,
              color: Colors.black,
            ),
            inputContainerDecoration: BoxDecoration(
              border: Border.all(color: MColor.xFFEEEEEE),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            inputTextColor: Colors.black,
          ),
          messages: controller.messages.value,
          onSendPressed: (text) {},
          user: controller.mineUser!,
          onAvatarTap: (user) {
            Get.toNamed(Routes.CHAT, arguments: user.id);
          },
          isLastPage: false,
          showUserAvatars: true,
          onEndReached: () {
            controller.offset += 1;
            controller.fetchList();
            return Future.value();
          },
          avatarBuilder: (uid) {
            final message = controller.messages.value
                .firstWhere((element) => element.author.id == uid);
            final url = message.author.imageUrl ?? '';
            if (url.isURL) {
              return _avatarView(url);
            }
            final file = File('//$url');

            if (file.existsSync()) {
              return Container(
                margin: EdgeInsets.only(right: 6),
                child: Image.file(
                  File(url),
                  width: 50,
                  height: 50,
                ),
              );
            } else {
              return Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: MColor.xFFCCCCCC,
                  borderRadius: BorderRadius.circular(6),
                ),
              );
            }
          },
          customBottomWidget: Input(
            onAttachmentPressed: () => _handleImageSelection(),
            onSendPressed: (text) {
              _handleSendPressed(text);
            },
            sendButtonVisibilityMode: SendButtonVisibilityMode.always,
          ),
        );
      }),
    );
  }

  Widget _avatarView(String? url) {
    return ClipRRect(
      child: Container(
        width: 55,
        height: 50,
        padding: EdgeInsets.only(right: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: MColor.xFFEEEEEE,
            child: CachedNetworkImage(
              imageUrl: url ?? '',
              placeholder: (ctx, a1) {
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
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleAtachmentPressed() {
    Get.bottomSheet(
      SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                  _handleImageSelection();
                },
                child: Center(
                  child: Text('Photo'),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = chat.ImageMessage(
        author: controller.mineUser!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: '${DateTime.now().millisecondsSinceEpoch}',
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );
      controller.messages.insert(0, message);
      controller.messages.refresh();
      JMessage.share.sendMessage(null, result.path, JMMessageType.image,
          controller.conversation, controller.userId, controller.groupId);
    }
  }

  void _handleSendPressed(chat.PartialText message) {
    final textMessage = chat.TextMessage(
      author: controller.mineUser!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: '${DateTime.now().millisecondsSinceEpoch}',
      text: message.text,
    );

    controller.messages.insert(0, textMessage);
    controller.messages.refresh();
    JMessage.share.sendMessage(message.text, null, JMMessageType.text,
        controller.conversation, controller.userId, controller.groupId);
  }
}
