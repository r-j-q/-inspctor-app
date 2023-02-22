// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:inspector/app/config/constant.dart';
// import 'package:inspector/app/config/design.dart';
// import 'package:inspector/app/routes/app_pages.dart';
// import 'package:inspector/app/tools/global_const.dart';
// import 'package:inspector/generated/locales.g.dart';
//
// class LanguageView extends GetView<InitController> {
//   bool isMine = false;
//   LanguageView() {
//     if (Get.arguments != null) {
//       isMine = Get.arguments;
//       controller.language.value = GlobalConst.sharedPreferences?.getInt(Constant.kLanguage) ?? 999;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(LocaleKeys.language_title.tr),
//       ),
//       body: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             SizedBox(height: 24),
//             _titleView,
//             SizedBox(height: 32),
//             _languageItem(LocaleKeys.language_English.tr, 0),
//             SizedBox(height: 12),
//             _languageItem(LocaleKeys.language_Chinese.tr, 1),
//             SizedBox(height: 12),
//             _languageItem(LocaleKeys.language_French.tr, 2),
//             SizedBox(height: 12),
//             _languageItem(LocaleKeys.language_German.tr, 3),
//             Spacer(),
//             _nextButton,
//             SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }
//
//   get _titleView {
//     return Container(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         LocaleKeys.language_select.tr,
//         style: MFont.semi_Bold24.apply(color: MColor.xFF333333),
//       ),
//     );
//   }
//
//   Widget _languageItem(String text, int index) {
//     return Obx(() {
//       var selected = index == controller.language.value;
//
//       return GestureDetector(
//         onTap: () => controller.language.value = index,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             color: selected ? MColor.skin_80 : MColor.xFFCCCCCC,
//           ),
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//           child: Row(
//             children: [
//               Icon(
//                 Icons.check,
//                 size: 24,
//                 color: selected ? MColor.skin : MColor.xFFCCCCCC,
//               ),
//               SizedBox(width: 12),
//               Text(
//                 text,
//                 style: MFont.semi_Bold15.apply(
//                   color: selected ? MColor.skin : MColor.xFF333333,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
//
//   get _nextButton {
//     return Container(
//       height: 34,
//       width: double.infinity,
//       child: TextButton(
//         style: ButtonStyle(
//           shape: MaterialStateProperty.all(StadiumBorder()),
//           backgroundColor: MaterialStateProperty.all(MColor.skin),
//         ),
//         onPressed: () async {
//           if (controller.language.value == 999) {
//             return;
//           }
//           if (controller.language.value == 3) {
//             Get.updateLocale(Locale('de', 'DE'));
//           } else if (controller.language.value == 2) {
//             Get.updateLocale(Locale('fr', 'FR'));
//           } else if (controller.language.value == 1) {
//             Get.updateLocale(Locale('zh', 'CN'));
//           } else {
//             Get.updateLocale(Locale('en', 'US'));
//           }
//           await GlobalConst.sharedPreferences
//               ?.setInt(Constant.kLanguage, controller.language.value);
//           if (isMine) {
//             Get.back();
//           } else {
//             AppPages.INITIAL();
//           }
//         },
//         child: Text(
//           LocaleKeys.public_next.tr,
//           style: MFont.regular15.apply(color: MColor.xFFEEEEEE),
//         ),
//       ),
//     );
//   }
// }
