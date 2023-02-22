import 'package:get/get.dart';
import 'package:inspector/app/modules/message/jmessage.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

class MemeberController extends GetxController {
  final members = <JMGroupMemberInfo>[].obs;
  String? groupId;

  @override
  void onInit() {
    super.onInit();
    groupId = Get.arguments;

    fetchList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void fetchList() async {
    members.value = await JMessage.share.memberList(groupId);
    members.refresh();
  }

  @override
  void onClose() {}
}
