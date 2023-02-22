import 'package:get/get_rx/get_rx.dart';

class OrderExplain {
  late String icon;
  late String title;
  late String content;
  late String pointTitle;
  late String points;
  String? otherTitle;
  String? otherContent;
  late int type;
  final isSelected = false.obs;

  OrderExplain(this.icon, this.title, this.content, this.pointTitle, this.points, this.otherTitle,
      this.otherContent, this.type);
}
