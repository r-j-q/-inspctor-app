import 'package:flutter/material.dart';

///颜色
class MColor {
  MColor._();

  ///主题色
  static Color skin = Color(0xFFC42407);
  static Color skin_05 = Color(0x0DC42407);
  static Color skin_80 = Color(0xFFC42407);
  static Color skin_50 = Color(0xFFC42407).withOpacity(0.5);

  ///黑色
  static Color xFF333333 = Color(0xFF333333);
  static Color xFF3D3D3D = Color(0xFF3D3D3D);
  static Color xFF333333_60 = Color(0xFF333333).withAlpha(60);
  static Color xFF333333_50 = Color(0xFF333333).withAlpha(50);
  static Color xFF838383 = Color(0xFF838383);
  static Color xFF303535 = Color(0xFF303535);

  static Color xFFE95332 = Color(0xFFE95332);
  static Color xFFEEEEEE = Color(0xFFEEEEEE);
  static Color xFFFFFFFF = Color(0xFFFFFFFF);
  static Color xFFEBEBEB = Color(0xFFEEEEEE);
  static Color xFFF4F5F7 = Color(0xFFF4F5F7);
  static Color xFFF7F8F9 = Color(0xFFF7F8F9);
  static Color xFFA4A5A9_80 = Color(0xFFA4A5A9).withAlpha(80);
  static Color xFFD7D9DD = Color(0xFFD7D9DD);
  static Color xFFD7A17C = Color(0xFFD7A17C);
  static Color xFF9A9B9C = Color(0xFF9A9B9C);
  static Color x80E3E3E3 = Color(0x80E3E3E3);
  static Color xFFDDDDDD = Color(0xFFDDDDDD);
  static Color xFF565656 = Color(0xFF565656);
  static Color xFF999999 = Color(0xFF999999);
  static Color xFF666666 = Color(0xFF666666);
  static Color xFFCCCCCC = Color(0xFFCCCCCC);
  static Color xFFCFCFCF = Color(0xFFCFCFCF);
  static Color xFF000000 = Color(0xFF000000);
  static Color xFF797979 = Color(0xFF797979);
  static Color xFF25C56F = Color(0xFF25C56F);
  static Color xFF40A900 = Color(0xFF40A900);
  static Color xFFA2A2A2 = Color(0xFFA2A2A2);
  static Color xFFABABAC = Color(0xFFABABAC);
  static Color xFFFB6668 = Color(0xFFFB6668);
  static Color xFFEEB697 = Color(0xFFEEB697);
  static Color xFFFEE0D0 = Color(0xFFFEE0D0);
  static Color xFFEEB595 = Color(0xFFEEB595);
  static Color xFF5C3F2B = Color(0xFF5C3F2B);
  static Color xFFB6906E = Color(0xFFB6906E);
  static Color xFFBBBBBB = Color(0xFFBBBBBB);
  static Color xFFBFBFBF = Color(0xFFBFBFBF);
  static Color xFFF4F6F9 = Color(0xFFF4F6F9);
  static Color xFFE6E6E6 = Color(0xFFE6E6E6);
  static Color xFFD9A179 = Color(0xFFD9A179);
  static Color xFFDF8D14 = Color(0xFFDF8D14);
  static Color xFF1BA12B = Color(0xFF1BA12B);
  static Color xFF0081E7 = Color(0xFF0081E7);
  static Color xFFEA6A46 = Color(0xFFEA6A46);
  static Color xFFD95F66 = Color(0xFFD95F66);
}

class MFont {
  static const bold30 = TextStyle(fontSize: 30, fontWeight: FontWeight.w700);
  static const bold24 = TextStyle(fontSize: 24, fontWeight: FontWeight.w700);
  static const bold22 = TextStyle(fontSize: 22, fontWeight: FontWeight.w700);
  static const bold20 = TextStyle(fontSize: 20, fontWeight: FontWeight.w700);

  static const semi_Bold24 =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
  static const semi_Bold20 =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static const semi_Bold17 =
      TextStyle(fontSize: 17, fontWeight: FontWeight.w600);
  static const semi_Bold16 =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const semi_Bold15 =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w600);
  static const semi_Bold14 =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
  static const semi_Bold13 =
      TextStyle(fontSize: 13, fontWeight: FontWeight.w600);
  static const semi_Bold12 =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
  static const semi_Bold11 =
      TextStyle(fontSize: 11, fontWeight: FontWeight.w600);

  ///medium
  static const medium30 = TextStyle(fontSize: 30, fontWeight: FontWeight.w500);
  static const medium20 = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  static const medium18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
  static const medium17 = TextStyle(fontSize: 17, fontWeight: FontWeight.w500);
  static const medium16 = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const medium15 = TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
  static const medium14 = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static const medium13 = TextStyle(fontSize: 13, fontWeight: FontWeight.w500);
  static const medium12 = TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
  static const medium11 = TextStyle(fontSize: 11, fontWeight: FontWeight.w500);
  static const medium10 = TextStyle(fontSize: 10, fontWeight: FontWeight.w500);

  ///regular
  static const regular20 = TextStyle(fontSize: 20, fontWeight: FontWeight.w400);
  static const regular19 = TextStyle(fontSize: 19, fontWeight: FontWeight.w400);
  static const regular18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w400);
  static const regular17 = TextStyle(fontSize: 17, fontWeight: FontWeight.w400);
  static const regular16 = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  static const regular15 = TextStyle(fontSize: 15, fontWeight: FontWeight.w400);
  static const regular14 = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static const regular13 = TextStyle(fontSize: 13, fontWeight: FontWeight.w400);
  static const regular12 = TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
  static const regular11 = TextStyle(fontSize: 11, fontWeight: FontWeight.w400);
  static const regular10 = TextStyle(fontSize: 10, fontWeight: FontWeight.w400);
}

class MGradient {
  MGradient._();

  ///垂直渐变色
  static LinearGradient verticalGradient(List<Color> colors) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
    );
  }

  ///左右渐变色
  static LinearGradient horizontalGradient(List<Color> colors) {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: colors,
    );
  }
}
