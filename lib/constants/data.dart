const int MAX_POINTS_PER_UNIFORM_PART = 3;
const int YEAR_OFFSET = 3;

class StudentAttendanceStatus {
  static String get unknown => '...';
  static String get present => 'present';
  static String get late    => 'late';
  static String get sick    => 'sick';
  static String get absent  => 'absent';
  static String get pe      => 'pe';

  static List<String> get all => <String>[
    unknown, present, late, sick, absent, pe
  ];

  static bool isPresent(String status) => <String>[present, late].contains(status);
}

class TeacherAttendanceStatus {
  static String get unknown => '...';
  static String get present => 'present';
  static String get late    => 'late';
  static String get sick    => 'sick';
  static String get absent  => 'absent';

  static List<String> get all => <String>[
    unknown, present, late, sick, absent
  ];

  static bool isPresent(String status) => <String>[present, late].contains(status);
}