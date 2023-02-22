import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:r_upgrade/r_upgrade.dart';

class UpdateAppView extends StatefulWidget {
  final Map<String, dynamic> info;
  UpdateAppView(this.info, {Key? key}) : super(key: key);

  @override
  State<UpdateAppView> createState() => _UpdateAppViewState();
}

class _UpdateAppViewState extends State<UpdateAppView> {
  double percent = 0;
  bool isDown = false;
  int uid = 0;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      RUpgrade.stream.listen((DownloadInfo info) {
        if (info.status == DownloadStatus.STATUS_FAILED) {
          if (Platform.isAndroid) {
            RUpgrade.cancel(uid);
            showToast('下载失败');
            isDown = false;
          }
          return;
        } else if (info.status == DownloadStatus.STATUS_SUCCESSFUL && info.id != null) {
          RUpgrade.install(info.id!);
        }
        setState(() {
          if (percent == 100) {
            return;
          }
          percent = info.percent ?? 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isForce = widget.info['isMustUpdate'] ?? false;
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              Center(
                child: Text(
                  '${widget.info['version']}版本全新上线',
                  style: MFont.semi_Bold17.apply(color: MColor.xFF333333),
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.info['content'],
                  style: MFont.regular13.apply(color: MColor.xFF666666),
                ),
              ),
              if (isDown && Platform.isAndroid) ...{
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: percent / 100,
                      valueColor: AlwaysStoppedAnimation<Color>(MColor.skin),
                      backgroundColor: MColor.xFFCCCCCC,
                    ),
                  ),
                ),
              },
              if (!isForce) ...{
                SizedBox(height: 16),
                Divider(height: 1, color: MColor.xFFCCCCCC),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 14),
                          child: Center(
                            child: Text(
                              '取消',
                              style: MFont.semi_Bold15.apply(color: MColor.xFF333333),
                            ),
                          ),
                        ),
                        onTap: () {
                          if (Platform.isAndroid) {
                            RUpgrade.cancel(uid);
                            isDown = false;
                          }
                          Get.back();
                        },
                      ),
                    ),
                    Container(
                      color: MColor.xFFCCCCCC,
                      width: 0.5,
                      height: 50,
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 14),
                          child: Center(
                            child: Text(
                              '立即更新',
                              style: MFont.semi_Bold15.apply(color: MColor.skin),
                            ),
                          ),
                        ),
                        onTap: () {
                          final url = widget.info['url'];
                          percent = 0;
                          toUpdate(url);
                          isDown = true;
                        },
                      ),
                    ),
                  ],
                ),
              } else ...{
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      height: 44,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MColor.xFF25C56F,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Text(
                          '立即更新',
                          style: MFont.semi_Bold15.apply(color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      final url = widget.info['url'];

                      percent = 0;
                      toUpdate(url);
                      isDown = true;
                    },
                  ),
                ),
                SizedBox(height: 16),
              },
            ],
          ),
        ),
      ),
    );
  }

  void toUpdate(String url) async {
    if (Platform.isAndroid) {
      if (isDown) {
        return;
      }
      uid = await RUpgrade.upgrade(url,
              fileName: 'inspection.apk', isAutoRequestInstall: true, useDownloadManager: true) ??
          0;
    } else {
      RUpgrade.upgradeFromAppStore('414478124');
    }
  }
}
