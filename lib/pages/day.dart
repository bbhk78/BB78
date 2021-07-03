import 'package:boysbrigade/constants/data.dart';
import 'package:boysbrigade/constants/ui.dart';
import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/controller/teacher_ctrl.dart';
import 'package:boysbrigade/model/student_attendance.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

class Day extends GetWidget<AuthController> {
  const Day({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TeacherController teacherCtrl = Get.find<TeacherController>();

    final List<Group> groups = teacherCtrl.groups;
    final List<Student> students = teacherCtrl.students;

    return Scaffold(
      appBar: GuiUtils.simpleAppBar(
        title: 'day'.tr,
        subtitle: DateTimeHelper.today().formatted('dd/MM/yyyy')
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groups.length,
                itemBuilder: (BuildContext context, int groupIndex) {
                  final Group currGroup = groups[groupIndex];
                  final List<Student> groupStudents = students
                    .where((Student student) => student.groupId == currGroup.id)
                    .toList();

                  final int studentsWithDays = groupStudents
                    .map((Student student) => student.todayAttendance)
                    .where((StudentAttendanceDay? day) => day != null)
                    .length;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          currGroup.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        if (groupStudents.length != studentsWithDays)
                          Center(
                            child: Text(
                              'not available'.tr,
                              // TODO: Make the text vertically center on the page
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'OpenSans SemiBold',
                              )
                            )
                          )
                        else
                          ListView.builder(
                            padding: const EdgeInsets.only(bottom: 10),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: groupStudents.length,
                            itemBuilder: (BuildContext context, int studentIndex) {
                              final Student currStudent = groupStudents[studentIndex];
                              final StudentAttendanceDay currDay = currStudent.todayAttendance!;

                              return StudentAttendanceRowWidget(
                                student: currStudent,
                                day: currDay
                              );
                            },
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class StudentAttendanceRowWidget extends StatelessWidget {
  final Student student;
  final StudentAttendanceDay day;

  const StudentAttendanceRowWidget({
    Key? key,
    required this.student,
    required this.day
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String attendanceStatus = day.status;
    final int countedPoints = day.uniform.values.reduce(MathReducers.sum);
    final int maxPoints = day.uniform.values.length * MAX_POINTS_PER_UNIFORM_PART;

    return Row(
      children: <Widget>[
        Flexible(
          flex: 4,
          fit: FlexFit.tight,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              student.name,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: STATUS_COLORS[attendanceStatus],
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                attendanceStatus.tr,
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              '$countedPoints / $maxPoints',
              style: TextStyle(
                fontSize: 18,
                color: countedPoints == 0 ? Colors.grey : Colors.black
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ),
      ],
    );
  }
}
