import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/teacher.dart';
import 'package:boysbrigade/model/teacher_attendance.dart';
import 'package:boysbrigade/services/database.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

class GroupsController extends GetxController {
  final RxList<Group> _groupsList = <Group>[].obs;
  List<Group> get groups => _groupsList.toList();

  final RxList<Teacher> _teachersList = <Teacher>[].obs;
  List<Teacher> get teachers => _teachersList.toList();

  @override
  void onInit() {
    super.onInit();
    _groupsList
      ..bindStream(Database.groupsStream())
      ..listen((List<Group> groups) async {
        final List<Teacher> teachers = await getAllTeachers();
        _teachersList.addAll(teachers);
      });
  }

  Future<List<Teacher>> getAllTeachers() async {
    final List<String> groupIds = groups.map((Group group) => group.teacherId).toList();
    final List<Teacher> teachers = await Database.getTeachersByIds(groupIds);
    return teachers;
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
}
