import 'package:boysbrigade/controller/teacher_ctrl.dart';
import 'package:boysbrigade/model/teacher.dart';
import 'package:boysbrigade/model/teacher_attendance.dart';
import 'package:boysbrigade/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rxn<User> _firebaseUser = Rxn<User>();
  User? get user => _firebaseUser.value;
  Stream<User?> get userStream => _firebaseUser.stream;

  @override
  void onInit() {
    super.onInit();
    _firebaseUser
      ..bindStream(_auth.authStateChanges())
      ..listen((User? user) async {
        final TeacherController teacherCtrl = Get.find<TeacherController>();
        final String? userEmail = user?.email;

        if (userEmail != null) {
          final Teacher? currTeacher = await Database.getTeacher(userEmail);

          if (teacherCtrl.teacher?.id != currTeacher?.id)
            teacherCtrl.teacher = currTeacher;
        }
      });
  }

  Future<bool> signUpTeacher({
    required String email,
    required String password,
    required String groupId
  }) async {
    try {
      final UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password
      );

      final String? userEmail = _authResult.user?.email;
      if (userEmail == null)
        return false;

      final String autoTeacherId = FirebaseAutoIdGenerator.autoId();
      final Teacher newTeacher = Teacher(
        id: autoTeacherId,
        email: userEmail,
        groupId: groupId,
        admin: false,
        attendance: TeacherAttendanceCalendar(),
      );

      final bool opStatus = await Database.createTeacher(newTeacher);
      if (opStatus)
        Get.find<TeacherController>().teacher = newTeacher;

      return opStatus;
    } on FirebaseAuthException catch (err) {
      Get.snackbar<void>('Error creating account!', err.message ?? 'Unknown reason');
      return false;
    }
  }

  Future<void> loginTeacher(String email, String password) async {
    /*UserCredential _authResult = */await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password
    );
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.find<TeacherController>().clear();
    } on FirebaseAuthException catch (err) {
      Get.snackbar<void>('Error signing out!', err.message ?? 'Unknown reason');
    }
  }
}