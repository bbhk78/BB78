import 'package:boysbrigade/constants/data.dart';
import 'package:boysbrigade/controller/data_ctrl.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/model/student_attendance.dart';

import 'package:boysbrigade/utils.dart';

class Student extends Equatable {
  final String id;
  final String groupId;
  final String subgroupId;
  final String name;
  final StudentAttendanceCalendar attendance;

  const Student({
    required this.id,
    required this.groupId,
    required this.subgroupId,
    required this.name,
    required this.attendance,
  });

  double get attendancePercent {
    final int totalDays = attendance.calendar.length;
    final int countedDays = attendance.calendar
      .where((StudentAttendanceDay day) =>
        StudentAttendanceExt.isPresent(day.status)
        || day.status == StudentAttendance.pe
      )
      .length;

    return (countedDays / totalDays) * 100;
  }

  double get uniformPercent {
    final DataController dataCtrl = Get.find<DataController>();
    final Group currGroup = dataCtrl.groups.firstWhere((Group group) => group.id == groupId);

    final List<StudentAttendanceDay> countedDays = attendance.calendar
      .where((StudentAttendanceDay day) => day.status != StudentAttendance.pe)
      .toList();

    final int totalPoints = countedDays.length * currGroup.uniformClass.length * MAX_POINTS_PER_UNIFORM_PART;
    final int countedPoints = countedDays
      .map((StudentAttendanceDay day) => day.uniform.values.reduce(MathReducers.sum))
      .reduce(MathReducers.sum);

    return (countedPoints / totalPoints) * 100;
  }

  StudentAttendanceDay? get todayAttendance {
    final List<StudentAttendanceDay> validDays = attendance.calendar.where(
      (StudentAttendanceDay day) => day.date.toDate().isToday()
    ).toList();

    return validDays.isEmpty ? null : validDays.first;
  }

  Map<String, dynamic> toFirestore() => <String, dynamic>{
    'group': groupId,
    'subgroup': subgroupId,
    'name': name,
    'attendance': attendance.toFirestore()
  };

  Student.fromFirestore(DocumentSnapshot<Map<String, dynamic>> document)
    : id = document.id,
      groupId = document.data()!['group'] as String,
      subgroupId = document.data()!['subgroup'] as String,
      name = document.data()!['name'] as String,
      attendance = StudentAttendanceCalendar.fromFirestoreData(
        document.data()!['attendance'] as List<dynamic>
      );

  @override
  List<Object> get props => <Object>[id, groupId, subgroupId, name];
}