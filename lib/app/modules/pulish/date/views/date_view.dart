import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspector/app/config/design.dart';
import 'package:inspector/generated/locales.g.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/date_controller.dart';

final kToday =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class DateView extends GetView<DateController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.date_title.tr),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Obx(() {
              final selectDates = controller.selectDates.value;
              return TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: kFirstDay,
                lastDay: kLastDay,
                selectedDayPredicate: (e) {
                  final current = DateTime(e.year, e.month, e.day);
                  final temp = selectDates.firstWhereOrNull((element) {
                    final now = DateTime(element.keys.first.year,
                        element.keys.first.month, element.keys.first.day);
                    if (current == now) {
                      return true;
                    }

                    return false;
                  });

                  return temp == null ? false : true;
                },
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(
                    Icons.arrow_back_ios,
                    color: MColor.xFF3D3D3D,
                    size: 16,
                  ),
                  rightChevronIcon: Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: MColor.xFF3D3D3D,
                    size: 16,
                  ),
                ),
                onDaySelected: (date1, date2) {
                  final current = DateTime(date1.year, date1.month, date1.day);
                  final temp = selectDates.firstWhereOrNull((element) {
                    final now = DateTime(element.keys.first.year,
                        element.keys.first.month, element.keys.first.day);
                    if (current == now) {
                      return true;
                    }

                    return false;
                  });
                  final person =
                      controller.outDates.value.firstWhereOrNull((element) {
                    final now = DateTime(element.keys.first.year,
                        element.keys.first.month, element.keys.first.day);
                    if (current == now) {
                      return true;
                    }

                    return false;
                  });
                  final tempNow = DateTime.now();
                  final now =
                      DateTime(tempNow.year, tempNow.month, tempNow.day);

                  if (current.millisecondsSinceEpoch >
                          now.millisecondsSinceEpoch &&
                      temp == null) {
                    controller.selectDates
                        .add({current: person?.values.first ?? 1});
                  } else {
                    controller.selectDates.removeWhere((element) {
                      final now = DateTime(element.keys.first.year,
                          element.keys.first.month, element.keys.first.day);
                      if (current == now) {
                        return true;
                      }

                      return false;
                    });
                  }

                  controller.selectDates.sort((left, right) =>
                      left.keys.first.compareTo(right.keys.first));
                  controller.selectDates.refresh();
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration:
                      BoxDecoration(color: MColor.skin, shape: BoxShape.circle),
                ),
              );
            }),
            Spacer(),
            _nextButton,
          ],
        ),
      ),
    );
  }

  get _nextButton {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(StadiumBorder()),
          backgroundColor: MaterialStateProperty.all(MColor.skin),
          minimumSize: MaterialStateProperty.all(Size(double.infinity, 49)),
        ),
        onPressed: () {
          Get.back(
              result: List<Map<DateTime, int>>.from(controller.selectDates));
        },
        child: Text(
          LocaleKeys.publish_next.tr,
          style: MFont.medium18.apply(color: Colors.white),
        ),
      ),
    );
  }
}
