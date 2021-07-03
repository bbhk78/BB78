import 'package:boysbrigade/constants/data.dart';
import 'package:boysbrigade/constants/ui.dart';
import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/controller/teacher_ctrl.dart';
import 'package:boysbrigade/model/student_attendance.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/pages/uniform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

import 'package:boysbrigade/pages/home.dart';

class AddAttendance extends GetWidget<AuthController> {
  const AddAttendance({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TeacherController teacherCtrl = Get.find<TeacherController>();

    final Group currGroup = teacherCtrl.groups.first;
    final Map<Student, StudentAttendanceDay> todayRollcall =
      Map<Student, StudentAttendanceDay>.fromEntries(
        teacherCtrl.students.map(
          (Student student) => MapEntry<Student, StudentAttendanceDay>(
            student,
            student.attendance.calendar.firstWhere(
              (StudentAttendanceDay day) => day.date.toDate().isToday(),
              orElse: () => StudentAttendanceDay.unknown()
            )
          )
        )
      );

    final int numStudentsRecorded = todayRollcall.values.where(
      (StudentAttendanceDay day) => day.status != AttendanceStatus.unknown
    ).length;
    final bool isUpdating = numStudentsRecorded != 0;

    return Scaffold(
      appBar: GuiUtils.simpleAppBar(
        title: 'attendance'.tr,
        subtitle: DateTimeHelper.today().formatted('dd/MM/yyyy'),
        showBackButton: true
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  currGroup.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              ListView.builder(
                padding: const EdgeInsets.only(bottom: 10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: todayRollcall.keys.length,
                itemBuilder: (BuildContext context, int studentIndex) {
                  final Student currStudent = todayRollcall.keys.elementAt(studentIndex);
                  final StudentAttendanceDay currDay = todayRollcall.values.elementAt(studentIndex);

                  return StudentAttendanceRowWidget(
                    group: currGroup,
                    student: currStudent,
                    day: currDay
                  );
                },
              ),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: FractionalOffset.bottomCenter,
                child: TextButton(
                  // TODO: make button stick to the bottom
                  onPressed: () async {
                    final bool isValid = todayRollcall.values
                      .where((StudentAttendanceDay day) => day.status == AttendanceStatus.unknown)
                      .isEmpty;

                    if (!isValid)
                      await Get.defaultDialog<void>(
                        middleText: 'need all attendance'.tr,
                        radius: 0,
                        textConfirm: 'ok'.tr,
                        barrierDismissible: false,
                        confirmTextColor: Colors.white,
                        onConfirm: () => Get.back<void>()
                      );
                    else {
                      await Get.dialog<void>(FutureProgressDialog(
                        teacherCtrl.addTodaysAttendanceUpdate(todayRollcall),
                        message: Text('saving data'.tr),
                      ));

                      await Get.offAll<void>(() => Home(startIndex: 1));
                    }
                  },
                  child: Text(
                    isUpdating ? 'update'.tr : 'submit'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'OpenSans SemiBold',
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class StudentAttendanceRowWidget extends StatelessWidget {
  final Group group;
  final Student student;
  final Rx<StudentAttendanceDay> day;

  StudentAttendanceRowWidget({
    Key? key,
    required this.group,
    required this.student,
    required StudentAttendanceDay day
  }) :
    day = day.obs,
    super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Flexible(
        flex: 4,
        fit: FlexFit.tight,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            student.name,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'OpenSans SemiBold'
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
      Flexible(
        flex: 3,
        fit: FlexFit.tight,
        child: Obx(() => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: STATUS_COLORS[day.value.status],
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              day.value.status.tr,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
        )),
      ),
      Flexible(
        flex: 2,
        fit: FlexFit.tight,
        child: IconButton(
          alignment: FractionalOffset.centerRight,
          icon: const Icon(
            Icons.edit_outlined,
            color: Colors.grey,
          ),
          onPressed: () async {
            final StudentAttendanceDay? potentialDay =
            await Get.bottomSheet<StudentAttendanceDay>(
              Wrap(children: <Widget>[
                Uniform(
                  group: group,
                  student: student,
                  day: day.value
                )
              ]),
              isScrollControlled: true,
              isDismissible: false,
              ignoreSafeArea: true,
            );

            day
              ..value = potentialDay!
              ..refresh();
          },
        ),
      ),
    ],
  );
}
