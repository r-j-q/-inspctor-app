import 'package:get/get.dart';
import 'package:inspector/app/modules/message/jmessage.dart';
//mydev
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:inspector/app/data/publish_conv_entity.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/app/modules/message/chat_provider.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MessageController extends GetxController {
  RefreshController refreshController = RefreshController();
  ChatProvider provider = ChatProvider();
  //final conversations = <JMConversationInfo>[].obs;
  final lists = <int>[0, 1].obs;
  final conversations = <PublishConvRows>[].obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    fetchList();
  }

  void fetchList() async {
    var total = 0;
    provider.takeChatLog(1, 50).then((value) async {
      if (value.isSuccess) {
        var models = value.data?.rows ?? [];
        total = value.data?.total ?? 0;
        print("===models====");
        print(models);
        print("=====models=====");
        // if (!isMore) {
        //   listEntity.value = [];
        // }
        conversations.value = [];
        conversations.addAll(models);
      } else {
        conversations.value = [];
        showToast(value.message ?? '');
      }
      conversations.refresh();
    }).whenComplete(() {
      EasyLoading.dismiss();
      refreshController.refreshCompleted();
      if (total <= conversations.length && conversations.isNotEmpty) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    });
    // try {
    //   conversations.value = await JMessage.share.allConversations();
    // } catch (e, stack) {
    // } finally {
    //   refreshController.refreshCompleted();
    // }
  }

  @override
  void onClose() {}

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }
}
