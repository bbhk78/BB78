import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:boysbrigade/constants/data.dart';
import 'package:boysbrigade/utils.dart';

class StudentAttendanceDay {
  Timestamp date;
  String status;
  Map<String, int> uniform = HashMap<String, int>();

  StudentAttendanceDay.unknown()
      : date = Timestamp.fromDate(DateTimeHelper.today()),
        status = UNKNOWN_ATTENDANCE;

  StudentAttendanceDay({
    required this.date,
    required this.status,
    required this.uniform,
  });

  Map<String, dynamic> toFirestore() => <String, dynamic>{
        'date': date,
        'status': status,
        'uniform': uniform
      };

  StudentAttendanceDay.fromFirestoreData(Map<String, dynamic> data)
      : date = data['date'] as Timestamp,
        status = data['status'] as String,
        uniform = TypeUtils.parseHashMap<String, int>(data['uniform']);
}

class StudentAttendanceCalendar {
  List<StudentAttendanceDay> calendar = const <StudentAttendanceDay>[];

  StudentAttendanceCalendar({this.calendar = const <StudentAttendanceDay>[]});

  bool get hasUniformDays => calendar
      .where((StudentAttendanceDay day) => day.status != PE_ATTENDANCE)
      .isNotEmpty;

  List<dynamic> toFirestore() =>
      calendar.map((StudentAttendanceDay day) => day.toFirestore()).toList();

  StudentAttendanceCalendar.fromFirestoreData(List<dynamic> data) {
    calendar = data
        .map<StudentAttendanceDay>((dynamic day) =>
            StudentAttendanceDay.fromFirestoreData(day as Map<String, dynamic>))
        .toList();
  }
}
