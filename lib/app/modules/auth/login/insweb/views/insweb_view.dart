import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../controllers/insweb_controller.dart';

class InswebView extends GetView<InswebController> {
  String? url;
  String? title;
  bool isIns = false;

  InswebView() {
    url = Get.parameters['url'];
    title = Get.parameters['title'];
    if (Get.arguments is bool) {
      isIns = Get.arguments as bool;
    }
    EasyLoading.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(title ?? '-'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url!)),
        onLoadStart: (ctx, uri) {
          if (uri?.queryParameters['code'] != null) {
            final code = uri!.queryParameters['code'];
            Get.back(result: code);
          }
        },
        onLoadStop: (ctx, _) {
          EasyLoading.dismiss();
        },
        onLoadError: (ctx, uri, b, c) {
          if (isIns) {
            Get.back();
          }
          EasyLoading.dismiss();
        },
        onLoadHttpError: (ctx, uri, b, c) {
          EasyLoading.dismiss();
          if (isIns) {
            Get.back();
          }
        },
      ),
    );
  }
}
