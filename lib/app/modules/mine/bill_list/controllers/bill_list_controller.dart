import 'package:get/get.dart';
import 'package:inspector/app/data/bill_entity.dart';
import 'package:inspector/app/modules/auth/mine_provider.dart';
import 'package:inspector/app/tools/tools.dart';

class BillListController extends GetxController {
  final provider = MineProvider();
  final month = DateTime.now().obs;
  var startTime = 0;
  var endTime = 0;
  final billInfo = BillEntity().obs;

  @override
  void onInit() {
    super.onInit();

    takeTime(DateTime.now());
  }

  @override
  void onReady() {
    super.onReady();
  }

  void takeTime(DateTime time) {
    month.value = time;
    final firstDay = DateTime(time.year, time.month); //本月第一天
    var nextFirstDay = DateTime(time.year, time.month + 1); //下月第一天
    final lastDay = nextFirstDay.subtract(Duration(seconds: 1));

    startTime = firstDay.millisecondsSinceEpoch ~/ 1000;
    endTime = lastDay.millisecondsSinceEpoch ~/ 1000;
    fetchBillList();
  }

  void fetchBillList() {
    provider.takeBillList(startTime, endTime).then((value) async {
      if (value.isSuccess) {
        billInfo.value = value.data ?? BillEntity();
      } else {
        showToast(value.message ?? '');
      }
    });
  }

  @override
  void onClose() {}
}
