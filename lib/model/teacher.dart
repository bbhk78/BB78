import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:boysbrigade/constants/data.dart';
import 'package:boysbrigade/model/teacher_attendance.dart';

class Teacher extends Equatable {
  final String id;
  final String email;
  final String? groupId;
  final bool admin;
  final TeacherAttendanceCalendar attendance;

  const Teacher({
    required this.id,
    required this.email,
    required this.groupId,
    required this.admin,
    required this.attendance,
  });

  double get attendancePercent {
    final int totalDays = attendance.calendar.length;
    final int countedDays = attendance.calendar
      .where((TeacherAttendanceDay day) => AttendanceStatus.isPresent(day.status))
      .length;

    return (countedDays / totalDays) * 100;
  }

  Map<String, dynamic> toFirestore() => <String, dynamic>{
    'email': email,
    'group': groupId,
    'admin': admin,
    'attendance': attendance.toFirestore(),
  };

  Teacher.fromFirestore(DocumentSnapshot<Map<String, dynamic>> document)
    : id = document.id,
      email = document.data()!['email'] as String,
      groupId = document.data()!['group'] as String?,
      admin = document.data()!['admin'] as bool,
      attendance = TeacherAttendanceCalendar.fromFirestoreData(
        document.data()!['attendance'] as List<dynamic>
      );

  @override
  List<Object?> get props => <Object?>[id, email, groupId];
}
