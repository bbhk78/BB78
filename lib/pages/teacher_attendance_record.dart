import 'package:boysbrigade/constants/data.dart';
import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/teacher.dart';
import 'package:boysbrigade/model/teacher_attendance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


List<DropdownMenuItem<String>> _attendanceStatusItems() => AttendanceStatus.all
  .map((String value) => DropdownMenuItem<String>(
    value: value,
    child: Text(
      value.tr,
      style: const TextStyle(
        fontSize: 20,
        fontFamily: 'OpenSans SemiBold',
        fontWeight: FontWeight.bold,
      ),
    )))
  .toList();

class TeacherAttendanceRecord extends GetWidget<AuthController> {
  final Group group;
  final Teacher teacher;
  final Rx<TeacherAttendanceDay> day;

  TeacherAttendanceRecord({
    Key? key,
    required this.group,
    required this.teacher,
    required TeacherAttendanceDay day
  }) :
    day = day.obs,
    super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * (2.5 / 10),
    color: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          teacher.name,
          style: const TextStyle(
            fontSize: 22,
            fontFamily: 'OpenSans SemiBold',
          ),
        ),
        Text(
          group.name,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'OpenSans Regular',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'attendance'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans SemiBold',
              ),
            ),
            Obx(() => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                onChanged: (String? value) {
                  // NOTE: There's no reason 'value' should be a nullable string here,
                  // but dart is complaining about a type compatibility problem so meh
                  day.value.status = value!;
                  day.refresh();
                },
                value: day.value.status,
                items: _attendanceStatusItems(),
              ),
            ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey.shade400,
            ),
            onPressed: () => Get.back(result: day.value),
            child: Center(
              child: Text(
                'done'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'OpenSans SemiBold',
                  color: Colors.black
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
