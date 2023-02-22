import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/constant.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/app/data/area_list_entity.dart';
import 'package:inspector/app/modules/auth/login/controllers/auth_login_controller.dart';
import 'package:inspector/app/modules/auth/register/controllers/auth_register_controller.dart';
import 'package:inspector/app/routes/app_pages.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/public_provider.dart';
import 'package:inspector/app/tools/tools.dart';
import 'package:inspector/generated/assets.dart';
import 'package:inspector/generated/locales.g.dart';

class AuthLoginView extends GetView<AuthLoginController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // Image.asset(
            //   Assets.imagesListBack,
            //   width: double.infinity,
            //   height: double.infinity,
            //   fit: BoxFit.cover,
            // ),
            Container(color: Colors.blueGrey),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20,
                sigmaY: 20,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 22.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      child: _logoView,
                      margin: EdgeInsets.only(top: 89, left: 20),
                    ),
                    Expanded(
                      child: Container(
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            SizedBox(height: 47.0.pixRatio),
                            _typeView,
                            SizedBox(height: 20.0.pixRatio),
                            _textField(0),
                            SizedBox(height: 10.0.pixRatio),
                            _textField(1),
                            SizedBox(height: 10.0.pixRatio),
                            _loginButton,
                            _changeView,
                            SizedBox(height: 16.0.pixRatio),
                            _otherView,
                          ],
                        ),
                      ),
                    ),
                    _bottomView,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  get _logoView {
    return GestureDetector(
      onTap: () {
        if (controller.isNext > 0 && controller.isNext < 10) {
          controller.isNext++;
          return;
        }
        controller.isNext++;
        Future.delayed(Duration(seconds: 1), () async {
          if (controller.isNext >= 5) {
            controller.isNext = 0;
            final env =
                GlobalConst.sharedPreferences?.getBool(Constant.env) ?? true;
            if (env) {
              showToast('develop');
              await GlobalConst.sharedPreferences?.setBool(Constant.env, false);
            } else {
              showToast('release');
              await GlobalConst.sharedPreferences?.setBool(Constant.env, true);
            }
            GlobalConst.tempModel = null;
            await GlobalConst.sharedPreferences?.remove(Constant.kUser);
            AppPages.INITIAL();
          } else {
            controller.isNext = 0;
          }
        });
      },
      child: Image.asset(Assets.imagesLoginLogo),
    );
  }

  get _typeView {
    TextStyle defaultStyle = MFont.medium20.apply(color: Colors.white);
    TextStyle selectedStyle = MFont.semi_Bold24.apply(color: Colors.white);

    return Obx(() {
      bool isEmail =
          (controller.accountType.value == AccountType.email) ? true : false;

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              controller.accountType.value = AccountType.email;
              controller.loginType.value = LoginType.password;
              controller.codeController.text = '';
              controller.emailController.text = '';
              controller.mobile.value = '';
              controller.password.value = '';
              controller.code.value = '';
            },
            child: Text(
              LocaleKeys.login_email_login.tr,
              style: isEmail ? selectedStyle : defaultStyle,
            ),
          ),
          SizedBox(width: 24),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              controller.accountType.value = AccountType.mobile;
              //mydev
              controller.loginType.value = LoginType.password;
              //controller.loginType.value = LoginType.code;
              controller.codeController.text = '';
              controller.emailController.text = '';
              controller.email.value = '';
              controller.code.value = '';
              controller.password.value = '';
            },
            child: Text(
              LocaleKeys.login_mobile_login.tr,
              style: isEmail ? defaultStyle : selectedStyle,
            ),
          ),
        ],
      );
    });
  }

  Widget _textField(int index) {
    return Obx(() {
      bool isCode =
          (controller.loginType.value == LoginType.code) ? true : false;
      bool isEmail = controller.accountType.value == AccountType.email;

      String hintText = '';
      Widget? rightView;
      if (index == 0) {
        if (isEmail) {
          hintText = LocaleKeys.login_email_tips.tr;
        } else {
          hintText = LocaleKeys.login_mobile_tips.tr;
        }
        if (isCode) {
          rightView = _sendButton;
        }
      } else {
        if (isCode) {
          hintText = LocaleKeys.login_verify_tips.tr;
        } else {
          hintText = LocaleKeys.login_password_tips.tr;
        }
      }

      TextInputType type = TextInputType.text;
      if (index == 0 && controller.accountType.value == AccountType.email) {
        type = TextInputType.emailAddress;
      } else if (index == 0 &&
          controller.accountType.value == AccountType.mobile) {
        type = TextInputType.phone;
      }
      if (index == 1 && controller.loginType.value == LoginType.code) {
        type = TextInputType.number;
      } else if (index == 1 &&
          controller.loginType.value == LoginType.password) {
        type = TextInputType.text;
      }

      return Container(
        child: TextField(
          controller: index == 0
              ? controller.emailController
              : controller.codeController,
          cursorColor: Colors.white,
          style: MFont.medium18.apply(color: Colors.white),
          //obscureText: isEmail && !isCode && index == 1,
          //mydev
          obscureText: !isCode && index == 1,
          keyboardType: type,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: MFont.medium18.apply(color: MColor.xFFD7D9DD),
            labelStyle: MFont.medium18.apply(color: Colors.white),
            suffixIcon: rightView,
            prefixIcon: !isEmail && index == 0 ? _areaButton : null,
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
            if (isEmail && index == 0) {
              controller.email.value = text;
            } else if (!isEmail && index == 0) {
              controller.mobile.value = text;
            } else if (isCode && index == 1) {
              controller.code.value = text;
            } else {
              controller.password.value = text;
            }
          },
        ),
      );
    });
  }

  get _areaButton {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.AREALIST)?.then((value) {
          AreaListEntity entity = value;
          controller.areaCode.value = int.parse(entity.code);
        });
      },
      child: Container(
        padding: EdgeInsets.only(left: 17, right: 5, top: 12, bottom: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              return Text(
                '+${controller.areaCode}',
                textAlign: TextAlign.center,
                style: MFont.medium18.apply(color: MColor.xFFD7D9DD),
              );
            }),
            SizedBox(width: 5),
            Container(
              color: MColor.xFFD7D9DD,
              width: 1,
            ),
          ],
        ),
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

  get _loginButton {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(StadiumBorder()),
        backgroundColor: MaterialStateProperty.all(MColor.skin),
        minimumSize: MaterialStateProperty.all(Size(double.infinity, 49)),
      ),
      onPressed: () {
        if (controller.isCheck.value) {
          controller.loginEmail();
        } else {
          showToast(LocaleKeys.login_agreement.tr);
        }
      },
      child: Text(
        LocaleKeys.login_submit.tr,
        style: MFont.medium18.apply(color: Colors.white),
      ),
    );
  }

  get _changeView {
    return Obx(() {
      var isCode = controller.loginType.value == LoginType.code;
      var isEmail = controller.accountType.value == AccountType.email;

      if (!isEmail) {
        //mydev
        // return Container();
      }

      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.codeController.text = '';
          if (controller.loginType.value == LoginType.code) {
            controller.loginType.value = LoginType.password;
            controller.code.value = '';
          } else {
            controller.loginType.value = LoginType.code;
            controller.code.value = '';
          }
          if (controller.accountType.value == AccountType.email) {
            controller.email.value = controller.emailController.text;
          }
        },
        child: Container(
          padding: EdgeInsets.only(top: 10.0.pixRatio),
          child: Center(
            child: Text(
              isCode
                  ? LocaleKeys.login_password_login.tr
                  : LocaleKeys.login_verify_login.tr,
              style: MFont.medium18.apply(color: Colors.white),
            ),
          ),
        ),
      );
    });
  }

  get _otherView {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _textItem(
          MFont.medium15.apply(color: Colors.white),
          LocaleKeys.login_register.tr,
          action: () {
            Get.toNamed(Routes.Register, arguments: BindPageType.register);
          },
        ),
        SizedBox(width: 20),
        _textItem(
          MFont.medium15.apply(color: Colors.white),
          '${LocaleKeys.login_forget_password.tr}?',
          action: () {
            Get.toNamed(Routes.Register, arguments: BindPageType.reset);
          },
        ),
      ],
    );
  }

  Widget _textItem(TextStyle style, String text, {VoidCallback? action}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        action?.call();
      },
      child: Text(
        text,
        style: style,
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
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              controller.isCheck.value = !controller.isCheck.value;
            },
            child: Container(
              child: Obx(() {
                if (controller.isCheck.value) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: 0, right: 10, top: 10, bottom: 10),
                    child: Icon(Icons.check_circle_outline,
                        size: 20, color: MColor.skin),
                  );
                }
                return Container(
                  padding:
                      EdgeInsets.only(left: 0, right: 14, top: 12, bottom: 12),
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: MColor.skin),
                    ),
                  ),
                );
              }),
            ),
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
