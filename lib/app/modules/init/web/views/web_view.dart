import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../controllers/web_controller.dart';

class WebView extends GetView<WebController> {
  final url = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Inspection'),
          centerTitle: true,
        ),
        body: Container(
          child: Obx(() {
            return InAppWebView(
              initialUrlRequest:
                  URLRequest(url: Uri.parse(controller.url.value)),
            );
          }),
        ));
  }
}
