import 'package:boysbrigade/controller/subgroup_ctrl.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/subgroup.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/model/student_attendance.dart';
import 'package:boysbrigade/model/teacher.dart';
import 'package:boysbrigade/model/teacher_attendance.dart';
import 'package:boysbrigade/services/database.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/controller/groups_ctrl.dart';

import 'package:boysbrigade/utils.dart';

class TeacherStatus {
  final bool isReady, hasData;
  TeacherStatus({ required this.isReady, required this.hasData });
}

class TeacherController extends GetxController {
  bool get isReady => teacher != null;
  bool get hasData => isReady && groups.isNotEmpty && students.isNotEmpty;

  final Rxn<Teacher> _teacher = Rxn<Teacher>();
  Teacher? get teacher => _teacher.value;

  // This stream is used for properly implementing the "Remember Me" functionality
  final Rx<TeacherStatus> _teacherStatus = TeacherStatus(isReady: false, hasData: false).obs;
  Stream<TeacherStatus?> get teacherStatusStream => _teacherStatus.stream;

  final RxList<Student> _students = <Student>[].obs;
  List<Student> get students => _students.toList();

  final RxList<Group> _groups = <Group>[].obs;
  List<Group> get groups => _groups.toList();
  set groups(List<Group> value) => _groups.value = value;

  final RxList<SubGroup> _subgroups = <SubGroup>[].obs;
  List<SubGroup> get subgroups => _subgroups.toList();
  set subgroups(List<SubGroup> value) => _subgroups.value = value;

  set teacher(Teacher? value) {
    if (teacher == value)
      return;

    _teacher.value = value;

    if (value != null) {
      final GroupsController groupsCtrl = Get.find<GroupsController>();
      groups = groupsCtrl.groups.where(
        (Group group) => value.admin ? true : group.id == value.groupId
      ).toList();

      final SubGroupsController subGroupsCtrl = Get.find<SubGroupsController>();
      subgroups = subGroupsCtrl.subGroups.where(
        (SubGroup subgroup) => value.admin ? true : subgroup.groupId == value.groupId
      ).toList();

      _students
        ..bindStream(Database.studentsStream(value.admin ? null : groups.first.id))
        ..listen((_) => _updateTeacherStatus());
    }

    _updateTeacherStatus();
  }

  Future<bool> addStudent({
    required String groupId,
    required String subgroupId,
    required String name,
  }) async {
    final String autoStudentId = FirebaseAutoIdGenerator.autoId();
    final Student newStudent = Student(
      id: autoStudentId,
      groupId: groupId,
      subgroupId: subgroupId,
      name: name,
      attendance: StudentAttendanceCalendar(),
    );

    final bool opStatus = await Database.createStudent(newStudent);
    return opStatus;
  }

  Future<bool> removeStudent(Student student) async {
    final bool opStatus = await Database.removeStudent(student);
    return opStatus;
  }

  Future<void> addStudentAttendanceUpdate(Map<Student, StudentAttendanceDay> studentsToDays) async {
    studentsToDays
      ..removeWhere((Student student, StudentAttendanceDay day) => !day.date.toDate().isToday())
      ..forEach((Student student, StudentAttendanceDay day) {
        final int possibleTodayIndex = student.attendance.calendar.indexWhere(
          (StudentAttendanceDay day) => day.date.toDate().isToday()
        );

        if (possibleTodayIndex != -1)
          student.attendance.calendar[possibleTodayIndex] = day;
        else
          student.attendance.calendar.add(day);
      });

    final List<Student> newStudents = studentsToDays.keys.toList();
    await Future.forEach<Student>(newStudents, Database.saveStudent);
  }

  void _updateTeacherStatus() {
    _teacherStatus.value = TeacherStatus(isReady: isReady, hasData: hasData);
  }

  void clear() {
    teacher = null;
    _groups.clear();
    _subgroups.clear();
    _students.clear();
  }
}
