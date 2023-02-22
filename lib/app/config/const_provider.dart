import 'package:inspector/app/config/api.dart';
import 'package:inspector/app/tools/public_provider.dart';

class ConstProvider {
  //获取百度token
  Future<String?> takeBdToken() async {
    final resp =
        await PublicProvider.oriRequest(path: Api.bdToken, isPost: false) as Map<String, dynamic>;

    String? token = resp['access_token'] as String;
    return Future.value(token);
  }

  //百度地址解析
  Future<dynamic> takeBdAddress(String text) async {
    String? token = await takeBdToken();
    if (token == null) {
      return Future.value(null);
    }
    final url = Api.bdAddress + '?access_token=$token&charset=UTF-8';
    final resp = await PublicProvider.oriRequest(path: url, params: {'text': text});

    return Future.value(resp);
  }
}
