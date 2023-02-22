import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/modules/auth/register/controllers/auth_register_controller.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/public_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/assets.dart';
import 'package:inspector/generated/locales.g.dart';

class AuthRegisterView extends GetView<AuthRegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          controller.pageType == BindPageType.register
              ? LocaleKeys.login_register.tr
              : LocaleKeys.login_forget_password.tr,
          style: MFont.medium18.apply(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Image.asset(
          //   Assets.imagesLoginLogo,
          //   width: double.infinity,
          //   height: double.infinity,
          //   fit: BoxFit.cover,
          // ),
          Container(color: Colors.blueGrey),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 22.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Offstage(
                    //   child: Container(
                    //     child: Image.asset(Assets.imagesLoginLogo),
                    //     margin: EdgeInsets.only(top: 20),
                    //   ),
                    //   offstage: !controller.isRegister,
                    // ),
                    SizedBox(height: 50),
                    _textField(0),
                    SizedBox(height: 15),
                    _textField(1),
                    SizedBox(height: 15),
                    _textField(2),
                    SizedBox(height: 15),
                    _nextButton,
                    SizedBox(height: 20),
                    if (controller.pageType == BindPageType.register) ...{
                      _bottomView,
                    }
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  get _titleView {
    return Container(
      alignment: Alignment.center,
      child: Text(
        LocaleKeys.login_register.tr,
        style: MFont.semi_Bold24.apply(color: Colors.white),
      ),
    );
  }

  Widget _textField(int index) {
    String hintText = '';
    Widget? rightView;
    if (index == 0) {
      hintText = LocaleKeys.registry_email_phone_tips.tr;
    } else if (index == 1) {
      hintText = LocaleKeys.login_verify_tips.tr;
    } else {
      hintText = LocaleKeys.login_password_tips.tr;
    }

    return Container(
      child: TextField(
        controller: index == 0
            ? controller.emailController
            : index == 1
                ? controller.codeController
                : controller.passController,
        cursorColor: Colors.white,
        style: MFont.medium18.apply(color: Colors.white),
        obscureText: index == 2,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: MFont.medium18.apply(color: MColor.xFFD7D9DD),
          labelStyle: MFont.medium18.apply(color: Colors.white),
          suffixIcon: index == 0 ? _sendButton : null,
          filled: true,
          isDense: false,
          contentPadding: EdgeInsets.only(left: 17),
          constraints: BoxConstraints(maxHeight: 48, minHeight: 48),
          fillColor: MColor.xFFA4A5A9_80,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(29),
            borderSide: BorderSide(color: MColor.xFFA4A5A9_80),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(29),
            borderSide: BorderSide(color: MColor.xFFA4A5A9_80),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(29),
            borderSide: BorderSide(color: MColor.xFFA4A5A9_80),
          ),
        ),
        onChanged: (text) {
          if (index == 0) {
            controller.email.value = text;
          } else if (index == 1) {
            controller.code.value = text;
          } else {
            controller.password.value = text;
          }
        },
      ),
    );
  }

  get _sendButton {
    return TextButton(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(MFont.regular13),
        foregroundColor: MaterialStateProperty.all(MColor.xFF333333),
        minimumSize: MaterialStateProperty.all(Size(10, 20)),
        visualDensity: VisualDensity.compact,
      ),
      onPressed: () => controller.takeCode(),
      child: Container(
        padding: EdgeInsets.only(right: 17),
        child: Obx(() {
          final time = controller.time.value;
          return Text(
            time == 61 ? LocaleKeys.login_take_code.tr : '$time s',
            style: MFont.medium18.apply(color: Colors.white),
            textAlign: TextAlign.right,
          );
        }),
      ),
    );
  }

  get _eyesButton {
    return IconButton(
      padding: EdgeInsets.only(top: 20),
      onPressed: () {
        controller.isSee.value = !controller.isSee.value;
      },
      icon: Obx(() {
        return Image.asset(
          controller.isSee.value
              ? Assets.imagesLoginLogo
              : Assets.imagesLoginLogo,
          width: 20,
          height: 20,
          color: Colors.white,
        );
      }),
    );
  }

  get _nextButton {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(StadiumBorder()),
        backgroundColor: MaterialStateProperty.all(MColor.skin),
        minimumSize: MaterialStateProperty.all(Size(double.infinity, 49)),
      ),
      onPressed: () {
        if (controller.pageType == BindPageType.bindMobile) {
          controller.bindAction();
        } else if (controller.pageType == BindPageType.reset) {
          controller.resetPassAction();
        } else if (controller.pageType == BindPageType.register) {
          if (!controller.isCheck.value) {
            showToast(LocaleKeys.login_agreement.tr);
            return;
          }
          controller.registerAction();
        }
      },
      child: Text(
        LocaleKeys.public_ok.tr,
        style: MFont.medium18.apply(color: Colors.white),
      ),
    );
  }

  get _bottomView {
    return Container(
      margin: EdgeInsets.only(bottom: 42.0.pixRatio),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            iconSize: 15,
            padding: EdgeInsets.only(right: 4),
            constraints: BoxConstraints(maxWidth: 20, maxHeight: 20),
            onPressed: () {
              controller.isCheck.value = !controller.isCheck.value;
            },
            icon: Obx(() {
              if (controller.isCheck.value) {
                return Icon(Icons.check_circle_outline,
                    size: 15, color: MColor.skin);
              }
              return Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: MColor.skin),
                ),
              );
            }),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Get.toNamed(
                  Routes.WEB,
                  parameters: {
                    'url': '${Server.web}/privacy/index.html',
                    'title'
                        '': LocaleKeys.login_agreement.tr
                  },
                );
              },
              child: Text(
                LocaleKeys.login_agreement.tr.fixAutoLines(),
                style: MFont.semi_Bold15.apply(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
