import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:inspector/app/modules/message/chat/controllers/chat_controller.dart';
import 'package:inspector/app/modules/message/controllers/message_controller.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

class JMessage {
  static JMessage share = JMessage();
  static final JmessageFlutter _instance = JmessageFlutter();
  JmessageFlutter get instance => _instance;
  //监听聊天室消息的监听id
  static const String chatRoomMsgListenerID = "chatRoomMsgListenerID";
  JMUserInfo? userInfo;
  final isLogin = false.obs;
  final String _appKey = '661b3ac7cffebe8fe9fbe4cd';

  JMessage() {
    init();

    Timer.periodic(Duration(seconds: 10), (timer) {
      if (!isLogin.value) {
        // share.login();
      }
    });
  }

  void init() {
    _instance.setDebugMode(enable: true);
    _instance.init(isOpenMessageRoaming: true, appkey: _appKey);
    _instance.applyPushAuthority(
        JMNotificationSettingsIOS(sound: true, alert: true, badge: true));
    addListener();
  }

  void login() async {
    final uid = GlobalConst.userModel?.uid;
    if (uid != null) {
      // await _instance.logout().catchError((_) {});
      _instance
          .login(username: 'user${uid.toString()}', password: '123456')
          .then((value) {
        logger.e('JMessage login ${value?.toJson()}');
        isLogin.value = true;
      }).catchError((e) {
        logger.e('JMessage login error ${e.toString()}');
        isLogin.value = false;
      });
    }
  }

  Future<List<JMConversationInfo>> allConversations() async {
    return _instance.getConversations();
  }

  Future<List<dynamic>> messageList(
      JMConversationType type, String id, int offset) async {
    if (type == JMConversationType.single) {
      final type = JMSingle.fromJson({'username': id, 'appKey': _appKey});
      return _instance.getHistoryMessages(type: type, from: offset, limit: 10);
    } else if (type == JMConversationType.group) {
      final type = JMGroup.fromJson({'groupId': id, 'appKey': _appKey});
      return _instance.getHistoryMessages(type: type, from: offset, limit: 10);
    }

    return Future.value([]);
  }

  void readAll(
      JMConversationInfo? conversationInfo, String? userId, String? groupId) {
    dynamic conversation;

    if (conversationInfo != null) {
      if (conversationInfo.conversationType == JMConversationType.single) {
        final user = (conversationInfo.target as JMUserInfo).username;
        conversation = JMSingle.fromJson({'username': user});
      } else if (conversationInfo.conversationType ==
          JMConversationType.group) {
        final info = conversationInfo.target as JMGroupInfo;
        conversation =
            JMGroup.fromJson({'type': JMGroupType.private, 'groupId': info.id});
      }
    } else if (groupId != null) {
      conversation =
          JMGroup.fromJson({'type': JMGroupType.private, 'groupId': groupId});
    } else {
      conversation = JMSingle.fromJson({'username': userId});
    }
    JMessage.share.instance.resetUnreadMessageCount(target: conversation);
  }

  void sendMessage(String? text, String? path, JMMessageType type,
      JMConversationInfo? conversationInfo, String? userId, String? groupId) {
    dynamic conversation;
    if (conversationInfo != null) {
      if (conversationInfo.conversationType == JMConversationType.single) {
        final user = (conversationInfo.target as JMUserInfo).username;
        conversation = JMSingle.fromJson({'username': user});
      } else if (conversationInfo.conversationType ==
          JMConversationType.group) {
        final info = conversationInfo.target as JMGroupInfo;
        conversation =
            JMGroup.fromJson({'type': JMGroupType.private, 'groupId': info.id});
      }
    } else if (groupId != null) {
      conversation =
          JMGroup.fromJson({'type': JMGroupType.private, 'groupId': groupId});
    } else {
      conversation = JMSingle.fromJson({'username': userId});
    }
    if (type == JMMessageType.text) {
      _instance
          .sendTextMessage(type: conversation, text: text)
          .then((value) {})
          .catchError((e) {
        logger.e('send message error ${e.toString()}');
      });
    } else if (type == JMMessageType.image) {
      _instance
          .sendImageMessage(type: conversation, path: path)
          .then((value) {})
          .catchError((e) {
        logger.e('send message error ${e.toString()}');
      });
    }
  }

  Future<List<JMGroupMemberInfo>> memberList(String? id) async {
    return _instance.getGroupMembers(id: id);
  }

  void addListener() async {
    print('add listener receive ReceiveMessage');

    _instance.addReceiveMessageListener((msg) {
      //+
      print('listener receive event - message ： ${msg.toJson()}');

      /* 下载原图测试
      if (msg is JMImageMessage) {
        print('收到一条图片消息' + 'id='+ msg.id + ',serverMessageId='+msg.serverMessageId);
        print('开始下载图片消息的原图');
        _instance.downloadOriginalImage(target: msg.from, messageId: msg.id).then((value) {
          print('下载图片--回调-1');
          print('图片消息，filePath = ' + value['filePath']);
          print('图片消息，messageId = ' + value['messageId'].toString());
          print('下载图片--回调-2');
        });
      }
       */
      Get.find<MessageController>().fetchList();
      Get.find<ChatController>(tag: 'group').fetchList();
      Get.find<ChatController>(tag: 'singe').fetchList();
      logger.d('【收到消息】${msg.toJson()}');
    });

    _instance.addClickMessageNotificationListener((msg) {
      //+
      print(
          'listener receive event - click message notification ： ${msg.toJson()}');
    });

    _instance.addSyncOfflineMessageListener((conversation, msgs) {
      print('listener receive event - sync office message ');

      List<Map> list = [];
      for (JMNormalMessage msg in msgs) {
        print('offline msg: ${msg.toJson()}');
        list.add(msg.toJson());
      }

      logger.d("【离线消息】${list.toString()}");
    });

    _instance.addSyncRoamingMessageListener((conversation) {
      verifyConversation(conversation);
      print('listener receive event - sync roaming message');
    });

    _instance.addContactNotifyListener((JMContactNotifyEvent event) {
      print('listener receive event - contact notify ${event.toJson()}');
    });

    _instance.addMessageRetractListener((msg) {
      print('listener receive event - message retract event');
      print("${msg.toString()}");
      verifyMessage(msg);
    });

    _instance.addReceiveChatRoomMessageListener(chatRoomMsgListenerID,
        (messageList) {
      print('listener receive event - chat room message ');
    });

    _instance
        .addReceiveTransCommandListener((JMReceiveTransCommandEvent event) {
      expect(event.message, isNotNull,
          reason: 'JMReceiveTransCommandEvent.message is null');
      expect(event.sender, isNotNull,
          reason: 'JMReceiveTransCommandEvent.sender is null');
      expect(event.receiver, isNotNull,
          reason: 'JMReceiveTransCommandEvent.receiver is null');
      expect(event.receiverType, isNotNull,
          reason: 'JMReceiveTransCommandEvent.receiverType is null');
      print('listener receive event - trans command');
    });

    _instance.addReceiveApplyJoinGroupApprovalListener(
        (JMReceiveApplyJoinGroupApprovalEvent event) {
      print("listener receive event - apply join group approval");

      expect(event.eventId, isNotNull,
          reason: 'JMReceiveApplyJoinGroupApprovalEvent.eventId is null');
      expect(event.groupId, isNotNull,
          reason: 'JMReceiveApplyJoinGroupApprovalEvent.groupId is null');
      expect(event.isInitiativeApply, isNotNull,
          reason:
              'JMReceiveApplyJoinGroupApprovalEvent.isInitiativeApply is null');
      expect(event.sendApplyUser, isNotNull,
          reason: 'JMReceiveApplyJoinGroupApprovalEvent.sendApplyUser is null');
      expect(event.joinGroupUsers, isNotNull,
          reason:
              'JMReceiveApplyJoinGroupApprovalEvent.joinGroupUsers is null');
      expect(event.reason, isNotNull,
          reason: 'JMReceiveApplyJoinGroupApprovalEvent.reason is null');
      print('flutter receive event receive apply jocin group approval');
    });

    _instance.addReceiveGroupAdminRejectListener(
        (JMReceiveGroupAdminRejectEvent event) {
      expect(event.groupId, isNotNull,
          reason: 'JMReceiveGroupAdminRejectEvent.groupId is null');
      verifyUser(event.groupManager);
      expect(event.reason, isNotNull,
          reason: 'JMReceiveGroupAdminRejectEvent.reason is null');
      print('listener receive event - group admin rejected');
    });

    _instance.addReceiveGroupAdminApprovalListener(
        (JMReceiveGroupAdminApprovalEvent event) {
      expect(event.isAgree, isNotNull,
          reason: 'addReceiveGroupAdminApprovalListener.isAgree is null');
      expect(event.applyEventId, isNotNull,
          reason: 'addReceiveGroupAdminApprovalListener.applyEventId is null');
      expect(event.groupId, isNotNull,
          reason: 'addReceiveGroupAdminApprovalListener.groupId is null');

      expect(event.isAgree, isNotNull,
          reason: 'addReceiveGroupAdminApprovalListener.isAgree is null');

      verifyUser(event.groupAdmin);
      for (var user in event.users!) {
        verifyUser(user);
      }
      print('listener receive event - group admin approval');
    });

    _instance.addReceiveMessageReceiptStatusChangelistener(
        (JMConversationInfo conversation, List<String> serverMessageIdList) {
      print("listener receive event - message receipt status change");

      //for (var serverMsgId in serverMessageIdList) {
      //  _instance.getMessageByServerMessageId(type: conversation.target, serverMessageId: serverMsgId);
      //}
    });
  }

  void verifyUser(JMUserInfo? user) {
    expect(user, isNotNull, reason: 'user');
    expect(user?.username, isNotNull, reason: 'user.username');
    expect(user?.appKey, isNotNull, reason: 'user.appkey');
    expect(user?.nickname, isNotNull, reason: 'user.nickname');
    expect(user?.avatarThumbPath, isNotNull, reason: 'user.avatarThumbPath');
    expect(user?.birthday, isNotNull, reason: 'user.birthday');
    expect(user?.region, isNotNull, reason: 'user.region');
    expect(user?.signature, isNotNull, reason: 'user.signature');
    expect(user?.address, isNotNull, reason: 'user.address');
    expect(user?.noteName, isNotNull, reason: 'user.noteName');
    expect(user?.noteText, isNotNull, reason: 'user.noteText');
    expect(user?.isNoDisturb, isNotNull, reason: 'user.isNoDisturb');
    expect(user?.isInBlackList, isNotNull, reason: 'user.isInBlackList');
    expect(user?.isFriend, isNotNull, reason: 'user.isFriend');
    expect(user?.extras, isNotNull, reason: 'user.extras');
  }

  void verifyConversation(JMConversationInfo conversation) {
    expect(conversation, isNotNull, reason: 'conversation is null');
    expect(conversation.conversationType, isNotNull,
        reason: 'conversation conversationType is null');
    expect(conversation.title, isNotNull, reason: 'conversation title is null');
    expect(conversation.unreadCount, isNotNull,
        reason: 'conversation unreadCount is null');
    expect(conversation.target, isNotNull,
        reason: 'conversation target is null');

    // do not test lastMessage, if conversation do not have lastmessage it will be null
    // expect(conversation.latestMessage, isNotNull, reason: 'conversation conversationType is null');
  }

  void verifyMessage(dynamic msg) {
    expect(msg.id, isNotNull, reason: 'message id is null');
    expect(msg.serverMessageId, isNotNull,
        reason: 'serverMessageId id is null');
    expect(msg.isSend, isNotNull, reason: 'message isSend is null');
    expect(msg.createTime, isNotNull, reason: 'message createTime is null');
    expect(msg.from, isNotNull, reason: 'message from is null');
    verifyUser(msg.from);

    expect(msg.target, isNotNull, reason: 'message from is null');
    if (msg.target is JMUserInfo) {
      verifyUser(msg.target);
    }
    if (msg.target is JMGroupInfo) {
      verifyGroupInfo(msg.target);
    }
  }

  void verifyGroupInfo(JMGroupInfo group) {
    expect(group, isNotNull, reason: 'group is null');
    expect(group.id, isNotNull, reason: 'group id is null');
    expect(group.name, isNotNull, reason: 'group name is null');
    expect(group.desc, isNotNull, reason: 'group desc is null');
    expect(group.level, isNotNull, reason: 'group level is null');
    expect(group.owner, isNotNull, reason: 'group owner is null');
    expect(group.ownerAppKey, isNotNull, reason: 'group ownerAppKey is null');
    expect(group.maxMemberCount, isNotNull,
        reason: 'group maxMemberCount is null');
    expect(group.isNoDisturb, isNotNull, reason: 'group isNoDisturb is null');
    expect(group.isBlocked, isNotNull, reason: 'group isBlocked is null');
  }

  void verifyGroupMember(JMGroupMemberInfo groupMember) {
    expect(groupMember, isNotNull);
    expect(groupMember.groupNickname, isNotNull);
    expect(groupMember.joinGroupTime, isNotNull);
    verifyUser(groupMember.user);
  }
}
