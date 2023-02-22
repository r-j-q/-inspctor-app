// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:inspector/app/config/design.dart';
// import 'package:inspector/app/routes/app_pages.dart';
// import 'package:inspector/generated/assets.dart';
// import 'package:inspector/generated/locales.g.dart';
//
// class StartView extends GetView {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Image.asset(
//             Assets.imagesLoginLogo,
//             width: double.infinity,
//             height: double.infinity,
//             fit: BoxFit.cover,
//           ),
//           Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Spacer(flex: 241),
//               Center(
//                 child: Image.asset(
//                   Assets.imagesLoginLogo,
//                   fit: BoxFit.fill,
//                   height: 31,
//                 ),
//               ),
//               Spacer(flex: 265),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(horizontal: 25),
//                 child: TextButton(
//                   onPressed: () {
//                     Get.toNamed(Routes.AUTH_LOGIN);
//                   },
//                   child: Text(
//                     LocaleKeys.login_title.tr,
//                     style: MFont.semi_Bold17.apply(color: MColor.xFF48A23F),
//                   ),
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors.white),
//                     shape: MaterialStateProperty.all(StadiumBorder()),
//                     fixedSize: MaterialStateProperty.all(Size(double.infinity, 44)),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 12),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(horizontal: 25),
//                 child: TextButton(
//                   onPressed: () {
//                     Get.toNamed(Routes.AUTH_REGISTER);
//                   },
//                   child: Text(
//                     LocaleKeys.register_title.tr,
//                     style: MFont.semi_Bold17.apply(color: Colors.white),
//                   ),
//                   style: ButtonStyle(
//                     shape: MaterialStateProperty.all(StadiumBorder()),
//                     side: MaterialStateProperty.all(BorderSide(color: Colors.white, width: 1)),
//                     fixedSize: MaterialStateProperty.all(Size(double.infinity, 44)),
//                   ),
//                 ),
//               ),
//               Spacer(flex: 171),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
