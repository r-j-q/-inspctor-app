import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/modules/mine/profile/views/input_text_view.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/public_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/locales.g.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(LocaleKeys.profile_title.tr),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemBuilder: (ctx, index) {
          final phone = GlobalConst.userModel?.phone ?? '';
          final email = GlobalConst.userModel?.email ?? '';
          final hold = GlobalConst.userModel?.emailHold ?? false;
          var showMore = true;
          if (phone.isNotEmpty && index == 2 && !hold) {
            showMore = false;
          } else if (email.isNotEmpty && index == 3 && hold) {
            showMore = false;
          }

          return _itemView(index, () {
            if (index == 0) {
              FilesPicker.openImage(false).then((value) {
                if (value == null || value.isEmpty) {
                  return;
                }
                controller.image.value = value;
                PublicProvider.uploadImages(value, UploadType.plain)
                    .then((value) {
                  if (value == null || value.isEmpty) {
                    showToast(LocaleKeys.profile_info_failed.tr);
                    return;
                  }
                  controller.avatar.value = value;
                  controller.fetchEditInfo();
                });
              });
            } else {
              if (!showMore) {
                return;
              }
              Get.generalDialog(
                pageBuilder: (ctx, a1, a2) {
                  return InputTextView(
                    controller.titles[index],
                    index == 2 ? TextInputType.number : TextInputType.text,
                  );
                },
              ).then((value) {
                if (value is String && value.isNotEmpty) {
                  if (index == 1) {
                    controller.name.value = value;
                  } else if (index == 2) {
                    controller.phone.value = value;
                  } else if (index == 3) {
                    controller.email.value = value;
                  } else if (index == 4) {
                    controller.wechat.value = value;
                  }
                  controller.fetchEditInfo();
                }
              });
            }
          });
        },
        separatorBuilder: (ctx, index) {
          return Divider(
            thickness: 0.5,
            color: MColor.xFFE6E6E6,
            indent: 16,
            height: 0,
          );
        },
        itemCount: controller.titles.length,
      ),
    );
  }

  Widget _itemView(int index, VoidCallback action) {
    final phone = GlobalConst.userModel?.phone ?? '';
    final email = GlobalConst.userModel?.email ?? '';
    final hold = GlobalConst.userModel?.emailHold ?? false;
    var showMore = true;
    if (phone.isNotEmpty && index == 2 && !hold) {
      showMore = false;
    } else if (email.isNotEmpty && index == 3 && hold) {
      showMore = false;
    }

    return InkWell(
      onTap: () => action(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Text(
              controller.titles[index],
              style: MFont.medium16.apply(color: MColor.xFF3D3D3D),
            ),
            SizedBox(width: 12),
            if (index == 0) ...{
              Spacer(),
              Obx(() {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    imageUrl: controller.image.value,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (ctx, a1) {
                      return Center(
                        child: SpinKitCircle(
                          color: MColor.skin,
                          size: 40.0,
                        ),
                      );
                    },
                    errorWidget: (ctx, a1, a2) {
                      return Container(
                        decoration: BoxDecoration(
                          color: MColor.xFFEEEEEE,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      );
                    },
                  ),
                );
              })
            } else ...{
              Expanded(child: Obx(() {
                final change = controller.valueChange.value;
                return Text(
                  controller.values[index],
                  style: MFont.medium16.apply(color: MColor.xFF838383),
                  maxLines: 1,
                  textAlign: TextAlign.right,
                );
              })),
            },
            if (showMore) ...{
              Icon(
                Icons.keyboard_arrow_right_outlined,
                size: 24,
                color: MColor.xFFBBBBBB,
              ),
            },
          ],
        ),
      ),
    );
  }
}
