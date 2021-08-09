import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/subgroup.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/model/student_attendance.dart';
import 'package:boysbrigade/model/teacher.dart';
import 'package:boysbrigade/model/teacher_attendance.dart';
import 'package:boysbrigade/services/database.dart';
import 'package:boysbrigade/controller/data_ctrl.dart';
import 'package:boysbrigade/utils.dart';

import 'package:get/get.dart';

class UserStatus {
  final bool isReady, hasData;
  UserStatus({ required this.isReady, required this.hasData });
}

class UserController extends GetxController {
  bool get isReady => user != null;
  bool get hasData => isReady && groups.isNotEmpty && teachers.isNotEmpty && students.isNotEmpty;

  final Rxn<Teacher> _user = Rxn<Teacher>();
  Teacher? get user => _user.value;

  RxList<Group> _groups = <Group>[].obs;
  List<Group> get groups => _groups.toList();
  set groups(List<Group> value) => _groups.value = value;

  RxList<SubGroup> _subgroups = <SubGroup>[].obs;
  List<SubGroup> get subgroups => _subgroups.toList();
  set subgroups(List<SubGroup> value) => _subgroups.value = value;

  RxList<Teacher> _teachers = <Teacher>[].obs;
  List<Teacher> get teachers => _teachers.toList();

  RxList<Student> _students = <Student>[].obs;
  List<Student> get students => _students.toList();

  // This stream is used for properly implementing the "Remember Me" functionality
  final Rx<UserStatus> _teacherStatus = UserStatus(isReady: false, hasData: false).obs;
  Stream<UserStatus?> get teacherStatusStream => _teacherStatus.stream;

  set user(Teacher? value) {
    if (user == value)
      return;

    _user.value = value;

    if (value != null) {
      final DataController dataCtrl = Get.find<DataController>();
      groups = dataCtrl.groups.where(
        (Group group) => value.admin ? true : group.id == value.groupId
      ).toList();

      subgroups = dataCtrl.subgroups.where(
        (SubGroup subgroup) => value.admin ? true : subgroup.groupId == value.groupId
      ).toList();

      _teachers
        ..bindStream(
          Database.teachersStream(value.admin ? null : groups.first.id)
            .map((List<Teacher> teachers) => teachers.where(
              (Teacher teacher) => teacher.id != value.id
            ).toList())
        )
        ..listen((_) => _updateTeacherStatus());

      _students
        ..bindStream(Database.studentsStream(value.admin ? null : groups.first.id))
        ..listen((_) => _updateTeacherStatus());
    } else {
      _groups.close();
      _groups = <Group>[].obs;

      _subgroups.close();
      _subgroups = <SubGroup>[].obs;

      _teachers.close();
      _teachers = <Teacher>[].obs;

      _students.close();
      _students = <Student>[].obs;
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

  Future<bool> addTeacher({
    required String email,
    required String name,
    required String groupId,
  }) async {
    final String autoTeacherId = FirebaseAutoIdGenerator.autoId();
    final Teacher newTeacher = Teacher(
      id: autoTeacherId,
      email: email,
      name: name,
      groupId: groupId,
      admin: false,
      attendance: TeacherAttendanceCalendar(),
    );

    final bool opStatus = await Database.createTeacher(newTeacher);
    return opStatus;
  }

  Future<bool> removeTeacher(Teacher teacher) async {
    final bool opStatus = await Database.removeTeacher(teacher);
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

  Future<void> addTeacherAttendanceUpdate(Map<Teacher, TeacherAttendanceDay> teacherToDays) async {
    teacherToDays
      ..removeWhere((Teacher teacher, TeacherAttendanceDay day) => !day.date.toDate().isToday())
      ..forEach((Teacher teacher, TeacherAttendanceDay day) {
        final int possibleTodayIndex = teacher.attendance.calendar.indexWhere(
                (TeacherAttendanceDay day) => day.date.toDate().isToday()
        );

        if (possibleTodayIndex != -1)
          teacher.attendance.calendar[possibleTodayIndex] = day;
        else
          teacher.attendance.calendar.add(day);
      });

    final List<Teacher> newTeachers = teacherToDays.keys.toList();
    await Future.forEach<Teacher>(newTeachers, Database.saveTeacher);
  }

  void _updateTeacherStatus() {
    _teacherStatus.value = UserStatus(isReady: isReady, hasData: hasData);
  }

  void clear() {
    user = null;
  }
}
