import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:boysbrigade/constants/data.dart';
import 'package:boysbrigade/model/teacher_attendance.dart';

import 'package:boysbrigade/utils.dart';

class Teacher extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? groupId;
  final bool admin;
  final TeacherAttendanceCalendar attendance;

  const Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.groupId,
    required this.admin,
    required this.attendance,
  });

  double get attendancePercent {
    final int totalDays = attendance.calendar.length;
    final int countedDays = attendance.calendar
      .where((TeacherAttendanceDay day) => TeacherAttendanceExt.isPresent(day.status))
      .length;

    return (countedDays / totalDays) * 100;
  }

  TeacherAttendanceDay? get todayAttendance {
    final List<TeacherAttendanceDay> validDays = attendance.calendar.where(
      (TeacherAttendanceDay day) => day.date.toDate().isToday()
    ).toList();

    return validDays.isEmpty ? null : validDays.first;
  }

  Map<String, dynamic> toFirestore() => <String, dynamic>{
    'name': name,
    'email': email,
    'group': groupId,
    'admin': admin,
    'attendance': attendance.toFirestore(),
  };

  Teacher.fromFirestore(DocumentSnapshot<Map<String, dynamic>> document)
    : id = document.id,
      name = document.data()!['name'] as String,
      email = document.data()!['email'] as String,
      groupId = document.data()!['group'] as String?,
      admin = document.data()!['admin'] as bool,
      attendance = TeacherAttendanceCalendar.fromFirestoreData(
        document.data()!['attendance'] as List<dynamic>
      );

  @override
  List<Object?> get props => <Object?>[id, email, groupId];
}
