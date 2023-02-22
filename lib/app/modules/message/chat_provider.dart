import 'package:inspector/app/data/public_model.dart';
import 'package:inspector/app/data/publish_conv_entity.dart';
import 'package:inspector/app/tools/public_provider.dart';

class ChatProvider {
  //获取聊天记录
  Future<BaseModel<PublishConvEntity>> takeChatLog(int page, int pageSize) {
    //var params = {'limit': pageSize, 'page': page};
    return PublicProvider.request<PublishConvEntity>(
        path: "chat/conversation/list?page=$page&limit=$pageSize&is_app=1",
        isPost: false,
        chat: true);
  }

  //消息列表
  Future<BaseModel<dynamic>> takeChatMsg(int id, int page, int pageSize) {
    return PublicProvider.request<dynamic>(
        path: "chat/records?conversation_id=$id&page=$page&limit=$pageSize",
        isPost: false,
        chat: true);
  }
}
