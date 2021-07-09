import 'package:boysbrigade/constants/data.dart';
import 'package:boysbrigade/constants/ui.dart';
import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/controller/teacher_ctrl.dart';
import 'package:boysbrigade/model/student_attendance.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/model/subgroup.dart';
import 'package:boysbrigade/pages/student_attendance_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

import 'package:boysbrigade/pages/home.dart';

class AddStudentAttendance extends GetWidget<AuthController> {
  const AddStudentAttendance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TeacherController teacherCtrl = Get.find<TeacherController>();

    final Group currGroup = teacherCtrl.groups.first;
    final Map<Student, StudentAttendanceDay> todayRollcall =
        Map<Student, StudentAttendanceDay>.fromEntries(teacherCtrl.students.map(
            (Student student) => MapEntry<Student, StudentAttendanceDay>(
                student,
                student.attendance.calendar.firstWhere(
                    (StudentAttendanceDay day) => day.date.toDate().isToday(),
                    orElse: () => StudentAttendanceDay.unknown()))));

    final int numStudentsRecorded = todayRollcall.values
        .where((StudentAttendanceDay day) =>
            day.status != AttendanceStatus.unknown)
        .length;
    final bool isUpdating = numStudentsRecorded != 0;

    return Scaffold(
        appBar: GuiUtils.simpleAppBar(
            title: 'attendance'.tr,
            subtitle: DateTimeHelper.today().formatted('dd/MM/yyyy'),
            showBackButton: true),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 10),
            shrinkWrap: true,
            itemCount: teacherCtrl.subgroups.length,
            itemBuilder: (BuildContext context, int subgroupIndex) {
              final SubGroup currSubGroup =
                  teacherCtrl.subgroups[subgroupIndex];
              final List<Student> subGroupStudents = todayRollcall.keys
                  .where((Student student) =>
                      currSubGroup.studentIds.contains(student.id))
                  .toList();

              return ListView(
                  padding: const EdgeInsets.only(bottom: 10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        currSubGroup.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(thickness: 0.5),
                    ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: subGroupStudents.length,
                      itemBuilder: (BuildContext context, int studentIndex) {
                        final Student currStudent =
                            subGroupStudents[studentIndex];
                        final StudentAttendanceDay currDay = todayRollcall
                            .entries
                            .firstWhere((MapEntry<Student, StudentAttendanceDay>
                                    entry) =>
                                entry.key.id == currStudent.id)
                            .value;

                        return StudentAttendanceRowWidget(
                            group: currGroup,
                            subgroup: currSubGroup,
                            student: currStudent,
                            day: currDay);
                      },
                    ),
                  ]);
            },
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          child: TextButton(
            onPressed: () async {
              final bool isValid = todayRollcall.values
                  .where((StudentAttendanceDay day) =>
                      day.status == AttendanceStatus.unknown)
                  .isEmpty;

              if (!isValid)
                await Get.defaultDialog<void>(
                    middleText: 'need all attendance'.tr,
                    radius: 0,
                    textConfirm: 'ok'.tr,
                    barrierDismissible: false,
                    confirmTextColor: Colors.black,
                    buttonColor: Colors.grey.shade300,
                    onConfirm: () => Get.back<void>());
              else {
                await Get.dialog<void>(FutureProgressDialog(
                  teacherCtrl.addStudentAttendanceUpdate(todayRollcall),
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
        ));
  }
}

class StudentAttendanceRowWidget extends StatelessWidget {
  final Group group;
  final SubGroup subgroup;
  final Student student;
  final Rx<StudentAttendanceDay> day;

  StudentAttendanceRowWidget(
      {Key? key,
      required this.group,
      required this.subgroup,
      required this.student,
      required StudentAttendanceDay day})
      : day = day.obs,
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                    StudentAttendanceRecord(
                        group: group,
                        subgroup: subgroup,
                        student: student,
                        day: day.value)
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
