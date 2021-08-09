import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:boysbrigade/constants/data.dart';
import 'package:boysbrigade/utils.dart';

class StudentAttendanceDay {
  Timestamp date;
  StudentAttendance status;
  Map<String, int> uniform = HashMap<String, int>();

  StudentAttendanceDay.unknown()
    : date = Timestamp.fromDate(DateTimeHelper.today()),
      status = StudentAttendance.unknown;

  StudentAttendanceDay.simple({
    required this.date,
    required this.status,
  });

  StudentAttendanceDay({
    required this.date,
    required this.status,
    required this.uniform,
  });

  Map<String, dynamic> toFirestore() => <String, dynamic>{
    'date': date,
    'status': status.name,
    'uniform': uniform
  };

  StudentAttendanceDay.fromFirestoreData(Map<String, dynamic> data)
    : date = data['date'] as Timestamp,
      status = StudentAttendanceExt.parse(data['status'] as String),
      uniform = TypeUtils.parseHashMap<String, int>(data['uniform']);
}

class StudentAttendanceCalendar {
  List<StudentAttendanceDay> calendar = const <StudentAttendanceDay>[];

  StudentAttendanceCalendar({ this.calendar = const <StudentAttendanceDay>[] });

  List<dynamic> toFirestore() => calendar
    .map((StudentAttendanceDay day) => day.toFirestore())
    .toList();

  StudentAttendanceCalendar.fromFirestoreData(List<dynamic> data) {
    calendar = data.map<StudentAttendanceDay>(
      (dynamic day) => StudentAttendanceDay.fromFirestoreData(day as Map<String, dynamic>)
    ).toList();
  }
}