import 'package:boysbrigade/controller/user_ctrl.dart';
import 'package:boysbrigade/model/teacher.dart';
import 'package:boysbrigade/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

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
        final UserController userCtrl = Get.find<UserController>();
        final String? userEmail = user?.email;

        if (userEmail != null) {
          final Teacher? currTeacher =
              await Database.getTeacherByEmail(userEmail);

          if (userCtrl.user?.id != currTeacher?.id) userCtrl.user = currTeacher;
        }
      });
  }

  Future<void> loginTeacher(String email, String password) async {
    /*UserCredential _authResult = */ await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password);
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.find<UserController>()
        ..readonly = false
        ..clear();
    } on FirebaseAuthException catch (err) {
      Get.snackbar<void>('Error signing out!', err.message ?? 'Unknown reason');
    }
  }
}
