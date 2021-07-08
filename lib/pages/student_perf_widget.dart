import 'package:boysbrigade/model/student_attendance.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';


class StudentPerformanceWidget extends StatelessWidget {
  final Color tileColor;
  final Student currStudent;

  const StudentPerformanceWidget({
    Key? key,
    required Student student,
    required this.tileColor
  }) :
    currStudent = student,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    final RxBool showMoreDetails = false.obs;
    final bool emptyCalendar = currStudent.attendance.calendar.isEmpty;

    return InkWell(
      child: Card(
        color: tileColor,
        child: Column(
          children: <Widget>[
            Flex(
              mainAxisAlignment: MainAxisAlignment.center,
              direction: Axis.horizontal,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      currStudent.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'OpenSans SemiBold',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'attendance'.tr,
                        style: const TextStyle(
                          fontFamily: 'OpenSans SemiBold',
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        emptyCalendar ? 'n/a'.tr : '${currStudent.attendancePercent.toInt()}%',
                        style: const TextStyle(
                          fontFamily: 'OpenSans SemiBold',
                          fontSize: 15
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'uniform'.tr,
                        style: const TextStyle(
                          fontFamily: 'OpenSans SemiBold',
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        emptyCalendar ? 'n/a'.tr : '${currStudent.uniformPercent.toInt()}%',
                        style: const TextStyle(
                          fontFamily: 'OpenSans SemiBold',
                          fontSize: 15
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Obx(() => showMoreDetails.value && !emptyCalendar
              ? const Divider(color: Colors.grey)
              : const SizedBox.shrink()
            ),
            Obx(() => showMoreDetails.value && !emptyCalendar
              ? SizedBox(
              height: 100,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount:
                currStudent.attendance.calendar.length,
                itemBuilder: (BuildContext context, int attIndex) {
                  final StudentAttendanceDay day = currStudent.attendance.calendar[attIndex];
                  final int totalPoints = day.uniform.values.reduce(MathReducers.sum);
                  final int maxPoints = day.uniform.values.length * 3;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 5
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            day.date.toDate().formatted('dd/MM'),
                            style: const TextStyle(
                              fontFamily: 'OpenSans Regular',
                              fontSize: 18
                            ),
                          ),
                          Text(
                            day.status.tr,
                            style: const TextStyle(
                              fontFamily: 'OpenSans Regular',
                              fontSize: 18
                            ),
                          ),
                          Text(
                            '$totalPoints / $maxPoints',
                            style: const TextStyle(
                              fontFamily: 'OpenSans Regular',
                              fontSize: 18
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              )
              : const SizedBox.shrink()
            )
          ],
        ),
      ),
      onTap: () => showMoreDetails.value = !showMoreDetails.value,
    );
  }
}