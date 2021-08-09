import 'package:boysbrigade/constants/data.dart';
import 'package:boysbrigade/constants/ui.dart';
import 'package:boysbrigade/controller/user_ctrl.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/teacher.dart';
import 'package:boysbrigade/model/teacher_attendance.dart';
import 'package:boysbrigade/pages/teacher_attendance_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';
import 'package:boysbrigade/utils.dart';

class AddTeacherAttendance extends GetWidget<UserController> {
  const AddTeacherAttendance({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<Teacher, TeacherAttendanceDay> todayRollcall =
      Map<Teacher, TeacherAttendanceDay>.fromEntries(
        controller.teachers.map(
          (Teacher teacher) => MapEntry<Teacher, TeacherAttendanceDay>(
            teacher,
            teacher.attendance.calendar.firstWhere(
              (TeacherAttendanceDay day) => day.date.toDate().isToday(),
              orElse: () => TeacherAttendanceDay.unknown()
            )
          )
        )
      );

    final int numTeachersRecorded = todayRollcall.values
      .where((TeacherAttendanceDay day) => day.status != TeacherAttendance.unknown)
      .length;
    final bool isUpdating = numTeachersRecorded != 0;

    return Scaffold(
        appBar: GuiUtils.simpleAppBar(
          title: 'attendance'.tr,
          subtitle: DateTimeHelper.today().formatted('dd/MM/yyyy'),
          showBackButton: true
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.groups.length,
              itemBuilder: (BuildContext context, int groupIndex) {
                final Group currGroup = controller.groups[groupIndex];
                final List<Teacher> teachersList = controller.teachers
                  .where((Teacher teacher) => teacher.groupId == currGroup.id)
                  .toList();
                
                return ListView(
                  padding: const EdgeInsets.only(bottom: 10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        currGroup.name,
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
                      itemCount: teachersList.length,
                      itemBuilder: (BuildContext context, int studentIndex) {
                        final Teacher currTeacher = teachersList[studentIndex];
                        final TeacherAttendanceDay currDay = todayRollcall.entries
                          .firstWhere((MapEntry<Teacher, TeacherAttendanceDay> entry) => entry.key.id == currTeacher.id)
                          .value;

                        return TeacherAttendanceRowWidget(
                          group: currGroup,
                          teacher: currTeacher,
                          day: currDay
                        );
                      },
                    ),
                  ]
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          child: TextButton(
            onPressed: () async {
              final UserController userCtrl = Get.find<UserController>();

              final bool isValid = todayRollcall.values
                .where((TeacherAttendanceDay day) => day.status == TeacherAttendance.unknown)
                .isEmpty;

              if (!isValid)
                await Get.defaultDialog<void>(
                  middleText: 'need all teacher attendance'.tr,
                  radius: 0,
                  textConfirm: 'ok'.tr,
                  barrierDismissible: false,
                  confirmTextColor: Colors.black,
                  buttonColor: Colors.grey.shade300,
                  onConfirm: () => Get.back<void>()
                );
              else {
                await Get.dialog<void>(
                  FutureProgressDialog(
                    userCtrl.addTeacherAttendanceUpdate(todayRollcall),
                    message: Text('saving data'.tr),
                  )
                );

                Get.back<void>();
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

class TeacherAttendanceRowWidget extends StatelessWidget {
  final Group group;
  final Teacher teacher;
  final Rx<TeacherAttendanceDay> day;

  TeacherAttendanceRowWidget({
    Key? key,
    required this.group,
    required this.teacher,
    required TeacherAttendanceDay day
  }) : day = day.obs, super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Flexible(
        flex: 4,
        fit: FlexFit.tight,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            teacher.name,
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
            color: STATUS_COLORS[day.value.status.name],
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              day.value.status.name.tr,
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
            final TeacherAttendanceDay? potentialDay = await Get.bottomSheet<TeacherAttendanceDay>(
              Wrap(children: <Widget>[
                TeacherAttendanceRecord(
                  group: group,
                  teacher: teacher,
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
