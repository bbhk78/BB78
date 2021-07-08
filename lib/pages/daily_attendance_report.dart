import 'package:boysbrigade/constants/data.dart';
import 'package:boysbrigade/constants/ui.dart';
import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/controller/groups_ctrl.dart';
import 'package:boysbrigade/controller/teacher_ctrl.dart';
import 'package:boysbrigade/model/student_attendance.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/model/teacher.dart';
import 'package:boysbrigade/model/teacher_attendance.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

class DailyAttendanceReport extends GetWidget<AuthController> {
  const DailyAttendanceReport({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GroupsController groupsCtrl = Get.find<GroupsController>();
    final TeacherController teacherCtrl = Get.find<TeacherController>();

    final List<Group> groups = teacherCtrl.groups;
    final List<Student> students = teacherCtrl.students;
    final List<Teacher> teachers = groupsCtrl.teachers;

    // First construct student views
    final List<Widget> tabs = groups.map((Group group) => Text(
      group.name,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
    )).toList();
    
    final List<Widget> tabViews = groups.map((Group group) {
      final List<Student> groupStudents = students
        .where((Student student) => student.groupId == group.id)
        .toList();

      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10
        ),
        child: StudentGroupReportWidget(students: groupStudents),
      );
    }).toList();

    // Then construct teacher view if applicable
    if (teacherCtrl.teacher!.admin) {
      tabs.add(
        const Text('T',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        )
      );

      final Widget teacherView = Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10
        ),
        child: TeacherGroupReportWidget(teachers: teachers),
      );

      tabViews.add(teacherView);
    }

    return Scaffold(
      appBar: GuiUtils.simpleAppBar(
        title: 'day'.tr,
        subtitle: DateTimeHelper.today().formatted('dd/MM/yyyy')
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * (7 / 10),
            child: DefaultTabController(
              length: groups.length,
              child: ContainedTabBarView(
                tabBarProperties: const TabBarProperties(height: 32),
                tabs: tabs,
                views: tabViews
              )
            )
          ),
        ],
      ),
    );
  }
}


class StudentGroupReportWidget extends StatelessWidget {
  final List<Student> students;
  final int _studentsWithDays;

  StudentGroupReportWidget({
    Key? key,
    required this.students,
  }): _studentsWithDays = students
        .map((Student student) => student.todayAttendance)
        .where((StudentAttendanceDay? day) => day != null)
        .length, super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      if (students.length != _studentsWithDays)
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
          itemCount: students.length,
          itemBuilder: (BuildContext context, int studentIndex) {
            final Student currStudent = students[studentIndex];
            final StudentAttendanceDay currDay = currStudent.todayAttendance!;

            return StudentAttendanceRowWidget(
              student: currStudent,
              day: currDay
            );
          },
        )
    ],
  );
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


class TeacherGroupReportWidget extends StatelessWidget {
  final List<Teacher> teachers;
  final int _teachersWithDays;

  TeacherGroupReportWidget({
    Key? key,
    required this.teachers,
  }) : _teachersWithDays = teachers
        .map((Teacher teacher) => teacher.todayAttendance)
        .where((TeacherAttendanceDay? day) => day != null)
        .length, super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      if (teachers.length != _teachersWithDays)
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
          itemCount: teachers.length,
          itemBuilder: (BuildContext context, int teacherIndex) {
            final Teacher currTeacher = teachers[teacherIndex];
            final TeacherAttendanceDay currDay = currTeacher.todayAttendance!;

            return TeacherAttendanceRowWidget(
              teacher: currTeacher,
              day: currDay
            );
          },
        )
    ],
  );
}


class TeacherAttendanceRowWidget extends StatelessWidget {
  final Teacher teacher;
  final TeacherAttendanceDay day;

  const TeacherAttendanceRowWidget({
    Key? key,
    required this.teacher,
    required this.day
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String attendanceStatus = day.status;

    return Row(
      children: <Widget>[
        Flexible(
          fit: FlexFit.tight,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              teacher.name,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Flexible(
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
      ],
    );
  }
}
