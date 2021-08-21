import 'package:boysbrigade/constants/data.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/model/student_attendance.dart';
import 'package:boysbrigade/model/subgroup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

List<DropdownMenuItem<StudentAttendance>> _attendanceStatusItems() =>
    StudentAttendance.values
        .map((StudentAttendance value) => DropdownMenuItem<StudentAttendance>(
            value: value,
            child: Text(
              value.name.tr,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans',
              ),
            )))
        .toList();

List<DropdownMenuItem<int>> _uniformMarkItems() => 0
    .to(3)
    .map((int value) => DropdownMenuItem<int>(
          value: value,
          child: Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'OpenSans',
            ),
          ),
        ))
    .toList();

class StudentAttendanceRecord extends StatelessWidget {
  final Group group;
  final SubGroup subgroup;
  final Student student;
  final Rx<StudentAttendanceDay> day;

  StudentAttendanceRecord(
      {Key? key,
      required this.group,
      required this.subgroup,
      required this.student,
      required StudentAttendanceDay day})
      : day = day.obs,
        super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * (7 / 8),
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Flexible(
                flex: 10,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'OpenSans SemiBold',
                        ),
                      ),
                      Text(
                        subgroup.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'OpenSans Regular',
                        ),
                      ),
                    ])),
            const SizedBox(height: 10),
            Flexible(
              flex: 15,
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'attendance'.tr,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Obx(() => DropdownButtonHideUnderline(
                            child: DropdownButton<StudentAttendance>(
                              onChanged: (StudentAttendance? value) {
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
                  const Divider(thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'uniform'.tr,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'marks'.tr,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 30,
              child: ListView.builder(
                shrinkWrap: true,
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
            Flexible(
              flex: 10,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () => Get.back(result: day.value),
                  child: SizedBox.expand(
                    child: Center(
                      child: Text(
                        'done'.tr,
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'OpenSans SemiBold',
                            color: Colors.black),
                      ),
                    ),
                  ),
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

  const UniformPartPointsWidget(
      {Key? key, required this.day, required this.uniformPart})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            uniformPart.tr,
            style:
                const TextStyle(fontSize: 18, fontFamily: 'OpenSans Regular'),
          ),
          Obx(() {
            final bool isPresent =
                StudentAttendanceExt.isPresent(day.value.status);
            if (!isPresent || !day.value.uniform.containsKey(uniformPart))
              day.value.uniform[uniformPart] = 0;

            return DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                // NOTE: If onChanged is null, the whole dropdown button is disabled
                onChanged: isPresent
                    ? (int? value) {
                        // NOTE: There's no reason 'value' should be a nullable string here,
                        // but dart is complaining about a type compatibility problem so meh
                        day.value.uniform[uniformPart] = value!;
                        day.refresh();
                      }
                    : null,
                value: isPresent ? (day.value.uniform[uniformPart] ?? 0) : 0,
                items: _uniformMarkItems(),
              ),
            );
          })
        ],
      );
}
