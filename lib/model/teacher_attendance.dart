import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:boysbrigade/constants/data.dart';
import 'package:boysbrigade/utils.dart';

class TeacherAttendanceDay {
  Timestamp date;
  TeacherAttendance status;

  TeacherAttendanceDay.unknown()
    : date = Timestamp.fromDate(DateTimeHelper.today()),
      status = TeacherAttendance.unknown;

  TeacherAttendanceDay({
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toFirestore() => <String, dynamic>{
    'date': date,
    'status': status.name
  };

  TeacherAttendanceDay.fromFirestoreData(Map<String, dynamic> data)
    : date = data['date'] as Timestamp,
      status = TeacherAttendanceExt.parse(data['status'] as String);
}

class TeacherAttendanceCalendar {
  List<TeacherAttendanceDay> calendar = const <TeacherAttendanceDay>[];

  TeacherAttendanceCalendar({ this.calendar = const <TeacherAttendanceDay>[] });

  List<dynamic> toFirestore() => calendar
    .map((TeacherAttendanceDay day) => day.toFirestore())
    .toList();

  TeacherAttendanceCalendar.fromFirestoreData(List<dynamic> data) {
    calendar = data.map<TeacherAttendanceDay>(
      (dynamic day) => TeacherAttendanceDay.fromFirestoreData(day as Map<String, dynamic>)
    ).toList();
  }
}