import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/modules/auth/login/controllers/auth_login_controller.dart';
import 'package:inspector/generated/locales.g.dart';

class AreaCodeView extends GetView<AuthLoginController> {
  AreaCodeView() {
    controller.fetchAreaList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.login_area_selected.tr),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 10),
            _searchView,
            Expanded(child: _listView),
          ],
        ),
      ),
    );
  }

  get _searchView {
    return Container(
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          prefixIcon: Icon(
            Icons.search,
            size: 24,
            color: MColor.xFF999999,
          ),
          fillColor: MColor.xFFEEEEEE,
          filled: true,
          isDense: true,
          hintText: LocaleKeys.login_area_selected.tr,
          hintStyle: MFont.regular13.apply(color: MColor.xFF999999),
          labelStyle: MFont.regular13.apply(color: MColor.xFF333333),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MColor.xFFEEEEEE, width: 0),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MColor.xFFEEEEEE, width: 0),
          ),
          constraints: BoxConstraints(maxHeight: 40),
        ),
        onChanged: (text) {
          controller.searchWords();
        },
      ),
    );
  }

  get _listView {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Obx(() {
        return ListView.builder(
          itemCount: controller.areaList.value.length,
          itemBuilder: (ctx, index) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                var code = controller.areaList.value[index];
                Get.back(result: code);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Text(
                      controller.areaList.value[index].name,
                      style: MFont.medium18.apply(color: Colors.black),
                    ),
                    Spacer(),
                    Text(
                      '+ ${controller.areaList.value[index].code}',
                      style: MFont.medium18.apply(color: Colors.black),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
