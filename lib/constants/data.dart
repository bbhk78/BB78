const int MAX_POINTS_PER_UNIFORM_PART = 3;
const int YEAR_OFFSET = 3;


enum StudentAttendance {
  unknown, present, late, sick, absent, pe
}

extension StudentAttendanceExt on StudentAttendance {
  static const Map<StudentAttendance, String> names = <StudentAttendance, String>{
    StudentAttendance.unknown: '...',
    StudentAttendance.present: 'present',
    StudentAttendance.late: 'late',
    StudentAttendance.sick: 'sick',
    StudentAttendance.absent: 'absent',
    StudentAttendance.pe: 'pe',
  };

  static StudentAttendance parse(String name) {
    for (final MapEntry<StudentAttendance, String> entry in names.entries)
      if (entry.value == name)
        return entry.key;
    return StudentAttendance.unknown;
  }

  String get name => names[this]!;

  static List<String> get all => names.values.toList();
  static bool isPresent(StudentAttendance status) =>
    status == StudentAttendance.present ||
    status == StudentAttendance.late;
}


enum TeacherAttendance {
  unknown, present, late, sick, absent
}

extension TeacherAttendanceExt on TeacherAttendance {
  static const Map<TeacherAttendance, String> names = <TeacherAttendance, String>{
    TeacherAttendance.unknown: '...',
    TeacherAttendance.present: 'present',
    TeacherAttendance.late: 'late',
    TeacherAttendance.sick: 'sick',
    TeacherAttendance.absent: 'absent'
  };

  static TeacherAttendance parse(String name) {
    for (final MapEntry<TeacherAttendance, String> entry in names.entries)
      if (entry.value == name)
        return entry.key;
    return TeacherAttendance.unknown;
  }

  String get name => names[this]!;

  static List<String> get all => names.values.toList();
  static bool isPresent(TeacherAttendance status) =>
    status == TeacherAttendance.present ||
    status == TeacherAttendance.late;
}