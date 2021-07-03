import 'package:boysbrigade/constants/data.dart';
import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/model/student_attendance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

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

List<DropdownMenuItem<int>> _uniformMarkItems() => 0.to(3)
  .map((int value) => DropdownMenuItem<int>(
    value: value,
    child: Text(
      value.toString(),
      style: const TextStyle(
        fontSize: 20,
        fontFamily: 'OpenSans SemiBold',
        fontWeight: FontWeight.bold,
      ),
    ),
  )).toList();

class Uniform extends GetWidget<AuthController> {
  final Group group;
  final Student student;
  final Rx<StudentAttendanceDay> day;

  Uniform({
    Key? key,
    required this.group,
    required this.student,
    required StudentAttendanceDay day
  }) :
    day = day.obs,
    super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * (4 / 5),
    color: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          student.name,
          style: const TextStyle(
            fontSize: 20,
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
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
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'uniform'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans SemiBold',
              ),
            ),
            Text(
              'marks'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans SemiBold',
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: group.uniformClass.length,
            itemBuilder: (BuildContext context, int uniformIndex) {
              final String uniformPart = group.uniformClass[uniformIndex];

              return UniformPartPointsWidget(
                day: day,
                uniformPart: uniformPart,
              );
            },
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(10),
          alignment: FractionalOffset.bottomCenter,
          child: TextButton(
            onPressed: () => Get.back(result: day.value),
            child: Text(
              'done'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'OpenSans SemiBold',
                color: Colors.black
              )
            ),
          ),
        ),
      ],
    ),
  );
}


class UniformPartPointsWidget extends StatelessWidget {
  final Rx<StudentAttendanceDay> day;
  final String uniformPart;

  const UniformPartPointsWidget({
    Key? key,
    required this.day,
    required this.uniformPart
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 32, right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          uniformPart.tr,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'OpenSans Regular'
          ),
        ),
        Obx(() {
          final bool isPresent = AttendanceStatus.isPresent(day.value.status);
          if (!isPresent || !day.value.uniform.containsKey(uniformPart))
            day.value.uniform[uniformPart] = 0;

          return DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              // NOTE: If onChanged is null, the whole dropdown button is disabled
              onChanged: isPresent ? (int? value) {
                // NOTE: There's no reason 'value' should be a nullable string here,
                // but dart is complaining about a type compatibility problem so meh
                day.value.uniform[uniformPart] = value!;
                day.refresh();
              } : null,
              value: isPresent ? (day.value.uniform[uniformPart] ?? 0) : 0,
              items: _uniformMarkItems(),
            ),
          );
        })
      ],
    ),
  );
}
